//
//  UITableViewCell+TipsView.m
//  Dandelion
//
//  Created by 刘帅 on 2021/3/23.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "UITableViewCell+TipsView.h"
#import <objc/runtime.h>

#define showTipsView_key     @"ShowTipsView_key"
#define TipsViewContent_key  @"TipsViewContent_key"

@implementation UITableViewCell (TipsView)

#pragma mark - 动态添加属性 -
- (void)setShowTipsView:(BOOL)showTipsView {
    objc_setAssociatedObject(self, showTipsView_key, @(showTipsView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsDisplay];
}

- (BOOL)showTipsView {
    NSString *showTipsView = objc_getAssociatedObject(self, showTipsView_key);
    return [showTipsView boolValue];
}

- (void)setTipsContent:(NSString *)tipsContent {
    objc_setAssociatedObject(self, TipsViewContent_key, tipsContent, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setNeedsDisplay];
}
- (NSString *)tipsContent {
    return objc_getAssociatedObject(self, TipsViewContent_key);;
}

@end
