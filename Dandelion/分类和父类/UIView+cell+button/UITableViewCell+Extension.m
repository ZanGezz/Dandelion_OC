//
//  UITableViewCell+Extension.m
//  Dandelion
//
//  Created by 刘帅 on 2020/12/28.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

+ (void)load {
    //交换添加子视图
    swizzleMethod([self class], @selector(addSubview:), @selector(runtime_addSubview:));
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
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

- (void)runtime_addSubview:(UIView *)view {
    
    // 判断不让 UITableViewCellContentView addSubView自己
    // 还需要注意 屏蔽掉一些系统直接添加在Cell上的控件，如 UITableViewCellEditControl、UITableViewCellReorderControl
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")] || [view isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")] || [view isKindOfClass:NSClassFromString(@"UITableViewCellReorderControl")]) {
        [self runtime_addSubview:view];
        NSLog(@"UITableViewCell+Extension.h");
    } else {
        [self.contentView addSubview:view];
    }
}

@end
