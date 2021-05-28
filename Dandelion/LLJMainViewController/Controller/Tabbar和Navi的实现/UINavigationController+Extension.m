//
//  UINavigationController+Extension.m
//  Dandelion
//
//  Created by 刘帅 on 2021/5/27.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

- (void)setBackToViewController:(NSString *)backToViewController {
    objc_setAssociatedObject(self, @"backToViewController", backToViewController, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)backToViewController {
    return objc_getAssociatedObject(self, @"backToViewController");
}

@end
