//
//  LLJBridgeViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/3/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJBridgeViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "LLJWKWebViewController.h"


@interface LLJBridgeViewController ()<UINavigationControllerDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;
@property (nonatomic, strong) WKPreferences *preference;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIProgressView *myProgressView;
@property (nonatomic) BOOL finishLoad;

@end

@implementation LLJBridgeViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //注销截获网络请求
    [FWWebLoadHelper cancelMonitorRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载本地缓存
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - webview加载 -
- (void)loadRequest{
    
    //[FWWebLoadHelper startMonitorRequest:self.configuration];

    self.finishLoad = NO;
    NSURL *url;
    self.urlString = @"http://5gd.cn/bcV0VT";
    if (self.urlString.length == 0) {
        self.urlString = [[NSBundle mainBundle]pathForResource:@"index.html" ofType:@""];
    }
    if ([self.urlString hasPrefix:@"http"]) {
        url = [NSURL URLWithString:self.urlString];
    }else{
        url = [NSURL fileURLWithPath:self.urlString];
    }
    NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:policy timeoutInterval:3600];
    [self.webView loadRequest:req];
}

#pragma mark - 页面加载完成之后调用 -
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    self.finishLoad = YES;
    //发送token
    [self sendToken];

    //发送token给html
    [self.bridge callHandler:@"initParams" data:nil responseCallback:^(id responseData) {
    }];
    
    //禁止页面缩放
    NSString* javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    [webView evaluateJavaScript:javascript completionHandler:nil];
}
//就是这么的简单粗暴 禁止通用链接跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    //返回+2的枚举值
//    NSLog(@"url = %@,kkkkk = %d",webView.URL.absoluteString,(WKNavigationActionPolicyAllow + 2));
//    decisionHandler(WKNavigationActionPolicyAllow + 2);
//}
#pragma mark - 进度条 -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - H5 交互的事件函数 -
- (void)registerHandlers {
    
    //启用 WebViewJavascriptBridge
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];

    //ios注册，html边发起访问，handler Block接收传过来的数据
    [self.bridge registerHandler:@"productDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
            
    }];
}

#pragma mark - 发送token给html -
- (void)sendToken{
    //html注册，ios边发起访问，data要传送的数据
    [self.bridge callHandler:@"sendToken" data:nil responseCallback:^(id responseData) {
    }];
}


#pragma mark - UI -
- (void)createUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //js调用oc配置环境
    self.configuration.preferences = self.preference;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.myProgressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //加载本地缓存
    //[FWWebLoadHelper startMonitorRequest:self.configuration];

    //注册交互
    [self registerHandlers];
    //加载页面
    [self loadRequest];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
//    button.frame = CGRectMake(100, 200, 100, 40);
//    [button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
}
//- (void)tap {
//    [self.navigationController pushViewController:[LLJWKWebViewController new] animated:YES];
//}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断要显示的控制器是否是自己隐藏显示导航头
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
   
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)dealloc{
    @try {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [FWWebLoadHelper cancelMonitorRequest:self.configuration];
    } @catch (NSException *exception) {}
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

#pragma mark - 懒加载 -
- (WKPreferences *)preference{
    if (!_preference) {
        //创建设置对象
        _preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        //_preference.minimumFontSize = 30;
        //在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        _preference.javaScriptCanOpenWindowsAutomatically = YES;
        _preference.javaScriptEnabled = YES;
    }
    return _preference;
}
- (WKWebViewConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [[WKWebViewConfiguration alloc] init];
        _configuration.allowsInlineMediaPlayback = YES;
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        _configuration.userContentController = userContentController;
    }
    return _configuration;
}
- (WKWebView *)webView{
    if (!_webView) {
        //初始化webview
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, LLJTabBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTabBarHeight) configuration:self.configuration];
        if (@available(iOS 11.0,*)) {
          _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
          self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _webView.scrollView.bounces = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}
- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 0)];
        _myProgressView.tintColor = LLJCommenColor;
        _myProgressView.trackTintColor = [UIColor whiteColor];
        if (@available(iOS 14.0, *)) {
            CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            transform = CGAffineTransformMakeScale(1.0f, 0.5f);
            _myProgressView.transform = transform;
        }
    }
    
    return _myProgressView;
}

@end
