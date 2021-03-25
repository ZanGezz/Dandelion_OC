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
#define tipsViewContent_key  @"TipsViewContent_key"
#define rowHeight_key        @"RowHeight_key"

@interface UITableViewCell ()

@property (nonatomic) BOOL showTipsView;           //是否显示tipsview

@end

@implementation UITableViewCell (TipsView)

#pragma mark - 动态添加属性 -
- (void)setShowTipsView:(BOOL)showTipsView {
    objc_setAssociatedObject(self, showTipsView_key, @(showTipsView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showTipsView {
    NSString *showTipsView = objc_getAssociatedObject(self, showTipsView_key);
    return [showTipsView boolValue];
}

- (void)setTipsContent:(NSString *)tipsContent {
    objc_setAssociatedObject(self, tipsViewContent_key, tipsContent, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)tipsContent {
    return objc_getAssociatedObject(self, tipsViewContent_key);;
}

- (CGFloat)rowHeight {
    
    if (self.tipsContent.length > 0 && self.showTipsView) {
        return self.frame.size.height;
    } else if (self.tipsContent.length == 0 && self.showTipsView) {
        return self.frame.size.height - 16;
    } else if (self.tipsContent == 0 && !self.showTipsView) {
        return self.frame.size.height;
    } else if (self.tipsContent > 0 && !self.showTipsView) {
        return self.frame.size.height + 16;
    }
    return self.frame.size.height;
}

@end
