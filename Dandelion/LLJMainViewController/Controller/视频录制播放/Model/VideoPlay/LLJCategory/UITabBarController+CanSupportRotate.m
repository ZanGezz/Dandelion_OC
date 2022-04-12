//
//  UITabBarController+CanSupportRotate.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/9.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "UITabBarController+CanSupportRotate.h"

@implementation UITabBarController (CanSupportRotate)

- (BOOL)shouldAutorotate {
   
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];;
}

@end
