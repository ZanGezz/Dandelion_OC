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

+ (void)load {
    //交换添加子视图
    //swizzleMethods([self class], @selector(addSubview:), @selector(runtimes_addSubview:));
}

void swizzleMethods(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)runtimes_addSubview:(UIView *)view {
    
    // 判断不让 UITableViewCellContentView addSubView自己
    // 还需要注意 屏蔽掉一些系统直接添加在Cell上的控件，如 UITableViewCellEditControl、UITableViewCellReorderControl
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")] || [view isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")] || [view isKindOfClass:NSClassFromString(@"UITableViewCellReorderControl")]) {
        [self runtimes_addSubview:view];
        NSLog(@"UITableViewCell+TipsView.h");
    } else {
        [self.contentView addSubview:view];
    }
}

@end
