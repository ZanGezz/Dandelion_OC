//
//  AppDelegate+RotateHelper.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/11.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "AppDelegate+RotateHelper.h"
#import <objc/runtime.h>

@implementation AppDelegate (RotateHelper)

- (void)setOrientationMask:(UIInterfaceOrientationMask)orientationMask {
    
    NSString *orientation = [NSString stringWithFormat:@"%ld",orientationMask];
    objc_setAssociatedObject(self, @"appDelegateOrientationMask", orientation, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIInterfaceOrientationMask)orientationMask {
    
    NSString *orientation = objc_getAssociatedObject(self, @"appDelegateOrientationMask");
    return [orientation integerValue];
}

//设置屏幕旋转权限
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return self.orientationMask;
}

@end
