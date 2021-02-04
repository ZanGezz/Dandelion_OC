//
//  LLJFViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/11.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJFViewController.h"
#import "BFBackButton.h"

@interface LLJFViewController ()<UINavigationControllerDelegate>


@end

@implementation LLJFViewController

#pragma mark - 重写初始化方法 -
- (instancetype)init {
    self = [super init];
    if (self) {
        
        /**
         *  *ios13新增 UIModalPresentationAutomatic默认模式 无法铺满屏幕
         *  *ios13无法用kvc为_placeholderLabel赋值
         */
        //pressent全屏模式
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        //push隐藏tabbar
        self.hidesBottomBarWhenPushed = YES;
        //ios11自适应安全区
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //导航栏代理回调用于隐藏显示导航栏
    self.navigationController.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBaseUI];
}
#pragma mark - 设置base基础UI -
- (void)setUpBaseUI{
    
    //创建返回按钮
    [self createLeftBackBtnWithImageName:@"head_back" backAction:nil];
    
    self.view.backgroundColor = LLJColor(241, 241, 241, 1);
    
    self.title = self.titleName;
}

#pragma mark - 统一返回按钮 -
- (void)createLeftBackBtnWithImageName:(NSString *)imageName backAction:(void (^)(void))backBlock{
    
    UIImage *image = [UIImage imageNamed:imageName];
    BFBackButton *leftBtn = [BFBackButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
    leftBtn.backBlock = backBlock;
    UIView *leftView = [[UIView alloc]initWithFrame:leftBtn.bounds];
    [leftBtn setImage:image forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftBtn];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftBar;
}
- (void)back:(BFBackButton *)sender{
    
    !sender.backBlock ?: sender.backBlock();
    
    if (!sender.backBlock) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 销毁中间详情页控制器 -
- (void)removeNavSubControllerByName:(NSString *)vcName {
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    if (mutArr.count > 2) {
        for (UIViewController *VC in mutArr) {
            if ([NSStringFromClass([VC class]) isEqualToString:vcName]) {
                [mutArr removeObject:VC];
                break;
            }
        }
    }
    self.navigationController.viewControllers = mutArr;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //判断要显示的控制器是否是自己隐藏显示导航头
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]] && self.hiddenNavgationBarWhenPushIn;
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - 隐藏状态栏 -
- (BOOL)prefersStatusBarHidden
{
    return self.hiddenStatusBarWhenPushIn;
}

- (void)dealloc {
    self.navigationController.delegate = nil;
}

@end
