//
//  UITableView+AddTipsView.m
//  Dandelion
//
//  Created by 刘帅 on 2021/3/23.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "UITableView+AddTipsView.h"

@implementation UITableView (AddTipsView)

void addTips_swizzMethod(Class class, SEL oriSel, SEL newSel) {
    
    Method oriMethod = class_getInstanceMethod(class, oriSel);
    Method newMethod = class_getInstanceMethod([UITableView class], newSel);
    
    BOOL success = class_addMethod(class, oriSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (success) {
        class_replaceMethod(class, newSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

+ (void)load {
    
    SEL selectors[] = {
        @selector(setDelegate:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"tt_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        addTips_swizzMethod([UITableView class],originalSelector, swizzledSelector);
    }
}
- (void)tt_setDelegate:(id<UITableViewDelegate>)delegate {
    if (delegate) {
        addTips_swizzMethod([delegate class],
                            @selector(tableView:heightForRowAtIndexPath:),
                            @selector(tt_tableView:heightForRowAtIndexPath:));
    }
    [self tt_setDelegate:delegate];
}

- (CGFloat)tt_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell.tipsContent.length > 0) {
        //重设frame
        CGRect newFrame;
        newFrame.origin.x = tableView.frame.origin.x;
        newFrame.origin.y = tableView.frame.origin.y;
        newFrame.size.height = [tableView tt_tableView:tableView heightForRowAtIndexPath:indexPath];
        newFrame.size.width = tableView.frame.size.width;
        cell.frame = newFrame;
        //添加tipsLabel
        UILabel *label = [[UILabel alloc]init];
        label.text = cell.tipsContent;
        //label.text = @"错了，错了，大错特错，笨啊！！！";
        label.frame = CGRectMake(0, cell.frame.size.height, tableView.frame.size.width, 15);
        label.textColor = [UIColor redColor];
        label.tag = 9000000001;
        [tableView addSubview:label];
        return [tableView tt_tableView:tableView heightForRowAtIndexPath:indexPath] + 15;
    } else {
        UIView *label = [tableView viewWithTag:9000000001];
        [label removeFromSuperview];
        return [tableView tt_tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [tableView tt_tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
