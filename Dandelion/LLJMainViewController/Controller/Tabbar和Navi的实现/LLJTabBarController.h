//
//  LLJTabBarController.h
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJTabBarController : UITabBarController

//移除子控制器
- (void)removeChildController:(UIViewController *)controller;
//添加子控制器
- (void)addChildController:(UIViewController *)childController;
//插入子控制器
- (void)insertChildController:(UIViewController *)childController atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
