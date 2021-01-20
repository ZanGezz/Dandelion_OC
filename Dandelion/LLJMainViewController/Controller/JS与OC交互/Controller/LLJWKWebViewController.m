//
//  LLJWKWebViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/3/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJWKWebViewController.h"
#import "LLJTabBarController.h"

@interface LLJWKWebViewController ()

@end

@implementation LLJWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(100, 200, 100, 40);
    [button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)tap {
    LLJTabBarController *tabbar = (LLJTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabbar.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
//    LLJTabBarController *tabbar = (LLJTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    tabbar.selectedIndex = 1;
}

@end
