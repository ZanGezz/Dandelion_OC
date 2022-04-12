//
//  LLJNaviController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJNaviController.h"
#import "LLJFViewController.h"

@interface LLJNaviController ()<UIGestureRecognizerDelegate>

@end

@implementation LLJNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setUpUI];
}
//设置导航栏
- (void)setUpUI{

    //开启左滑返回功能
    self.interactivePopGestureRecognizer.delegate = self;
    //设置导航栏
    [self setUpMyNavigationBar];
}
#pragma mark - 设置导航栏 -
- (void)setUpMyNavigationBar{
    
    //是否隐藏黑线
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc]init];
        appearance.shadowImage = [UIImage new];
        appearance.shadowColor = [UIColor clearColor];
        //设置字体颜色
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
    //设置背景默认白色
    [self setUpBackGroundColor:LLJBlackColor];
    //设置默认字体18颜色白色
    [self setUpTitleColor:LLJWhiteColor font:LLJFontName(@"PingFangSC-Medium",18)];
}

//设置字体和颜色
- (void)setUpTitleColor:(UIColor *)titleColor font:(UIFont *)titleFont{
    
    //是否隐藏黑线
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:titleFont};
        //设置字体颜色
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        //设置字体颜色
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor,NSFontAttributeName:titleFont}];
    }
}
//设置背景颜色
- (void)setUpBackGroundColor:(UIColor *)color{
    
    //颜色生成图片  透明背景色为白色透明度为0
    UIImage *backGroundImage = [LLJHelper imageWithRenderColor:color renderSize:CGSizeMake(SCREEN_WIDTH, LLJTopHeight)];
    [self setUpBackGroundImage:backGroundImage];
}

//设置背景图片
- (void)setUpBackGroundImage:(UIImage *)image{
    
    //是否隐藏黑线
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = self.navigationBar.standardAppearance;
        appearance.backgroundImage = image;
        //设置字体颜色
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        [self.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//左滑返回功能
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count <= 1) {
            //跟试图禁止左滑手势
            return NO;
        } else {
            LLJFViewController *viewController = [self.viewControllers lastObject];
            if (viewController.forbidGesturePopViewController) {
                return NO;
            } else {
                return YES;
            }
        }
    }
    return NO;
}

@end
