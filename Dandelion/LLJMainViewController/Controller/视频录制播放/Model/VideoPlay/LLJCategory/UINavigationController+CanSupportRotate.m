//
//  UINavigationController+CanSupportRotate.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/9.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "UINavigationController+CanSupportRotate.h"

@implementation UINavigationController (CanSupportRotate)

- (BOOL)shouldAutorotate {

    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];;
}

@end
