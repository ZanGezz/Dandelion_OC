//
//  UIViewController+CanSupportRotate.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/9.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "UIViewController+CanSupportRotate.h"

@implementation UIViewController (CanSupportRotate)

- (BOOL)shouldAutorotate {

    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
