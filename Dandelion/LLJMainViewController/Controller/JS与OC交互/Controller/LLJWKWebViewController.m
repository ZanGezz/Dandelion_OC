//
//  LLJWKWebViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/3/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJWKWebViewController.h"
#import "LLJTabBarController.h"

@interface LLJWKWebViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation LLJWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
//    button.frame = CGRectMake(100, 200, 100, 40);
//    [button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    [self.view addSubview:self.webView];
    //NSString *path = [[NSBundle mainBundle]pathForResource:@"text" ofType:@"html"];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"dist/index.html" ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:path];
//    NSString *path = @"dist/index.html";
//    NSURL *url = [[NSBundle mainBundle] URLForResource:path withExtension:nil];
    //NSURL *url = [[NSBundle mainBundle]URLForResource:@"dist/index.html" withExtension:@""];
    url = [NSURL URLWithString:@"http://5gd.cn/bcV0VT"];

    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)tap {
    LLJTabBarController *tabbar = (LLJTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
//    LLJTabBarController *tabbar = (LLJTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    tabbar.selectedIndex = 1;
}

- (WKWebView *)webView{
    if (!_webView) {
        //初始化webview
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, LLJTabBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTabBarHeight)];
        if (@available(iOS 11.0,*)) {
          _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
          self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
