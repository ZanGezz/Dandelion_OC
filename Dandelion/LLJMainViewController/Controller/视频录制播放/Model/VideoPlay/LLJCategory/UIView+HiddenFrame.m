//
//  UIView+HiddenFrame.m
//  
//
//  Created by 刘帅 on 2020/11/6.
//

#import "UIView+HiddenFrame.h"
#import <objc/runtime.h>

#define animateCommenSmallScreenFrameKey  @"animateCommenSmallScreenFrameKey"
#define animateHiddenSmallScreenFrameKey  @"animateHiddenSmallScreenFrameKey"
#define animateCommenFullScreenFrameKey   @"animateCommenFullScreenFrameKey"
#define animateHiddenFullScreenFrameKey   @"animateHiddenFullScreenFrameKey"
#define animateCommenRotateViewFullScreenFrameKey   @"animateCommenRotateViewFullScreenFrameKey"
#define animateHiddenRotateViewFullScreenFrameKey   @"animateHiddenRotateViewFullScreenFrameKey"

@implementation UIView (HiddenFrame)

- (void)setAnimateCommenSmallScreenFrame:(CGRect)animateCommenSmallScreenFrame {
    
    NSValue *rectValue = [NSValue valueWithCGRect:animateCommenSmallScreenFrame];

    objc_setAssociatedObject(self, animateCommenSmallScreenFrameKey, rectValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGRect)animateCommenSmallScreenFrame {
    
    NSValue *rectValue = objc_getAssociatedObject(self, animateCommenSmallScreenFrameKey);
    return [rectValue CGRectValue];
}

- (void)setAnimateHiddenSmallScreenFrame:(CGRect)animateHiddenSmallScreenFrame {
    
    NSValue *rectValue = [NSValue valueWithCGRect:animateHiddenSmallScreenFrame];

    objc_setAssociatedObject(self, animateHiddenSmallScreenFrameKey, rectValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGRect)animateHiddenSmallScreenFrame {
    
    NSValue *rectValue = objc_getAssociatedObject(self, animateHiddenSmallScreenFrameKey);
    return [rectValue CGRectValue];
}

- (void)setAnimateCommenFullScreenFrame:(CGRect)animateCommenFullScreenFrame {
    
    NSValue *rectValue = [NSValue valueWithCGRect:animateCommenFullScreenFrame];

    objc_setAssociatedObject(self, animateCommenFullScreenFrameKey, rectValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)animateCommenFullScreenFrame {
    
    NSValue *rectValue = objc_getAssociatedObject(self, animateCommenFullScreenFrameKey);
    return [rectValue CGRectValue];
}

- (void)setAnimateHiddenFullScreenFrame:(CGRect)animateHiddenFullScreenFrame {
    
    NSValue *rectValue = [NSValue valueWithCGRect:animateHiddenFullScreenFrame];

    objc_setAssociatedObject(self, animateHiddenFullScreenFrameKey, rectValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)animateHiddenFullScreenFrame {
    
    NSValue *rectValue = objc_getAssociatedObject(self, animateHiddenFullScreenFrameKey);
    
    return [rectValue CGRectValue];
}

- (void)setAnimateCommenRotateViewFullScreenFrame:(CGRect)animateCommenRotateViewFullScreenFrame {
    
    NSValue *rectValue = [NSValue valueWithCGRect:animateCommenRotateViewFullScreenFrame];

    objc_setAssociatedObject(self, animateCommenRotateViewFullScreenFrameKey, rectValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGRect)animateCommenRotateViewFullScreenFrame {
    
    NSValue *rectValue = objc_getAssociatedObject(self, animateCommenRotateViewFullScreenFrameKey);
    
    return [rectValue CGRectValue];
}

- (void)setAnimateHiddenRotateViewFullScreenFrame:(CGRect)animateHiddenRotateViewFullScreenFrame {
    
    NSValue *rectValue = [NSValue valueWithCGRect:animateHiddenRotateViewFullScreenFrame];

    objc_setAssociatedObject(self, animateHiddenRotateViewFullScreenFrameKey, rectValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)animateHiddenRotateViewFullScreenFrame {
    
    NSValue *rectValue = objc_getAssociatedObject(self, animateHiddenRotateViewFullScreenFrameKey);
    
    return [rectValue CGRectValue];
}

@end
