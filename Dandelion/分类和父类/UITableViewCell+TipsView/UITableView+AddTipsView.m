//
//  UITableView+AddTipsView.m
//  Dandelion
//
//  Created by 刘帅 on 2021/3/23.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "UITableView+AddTipsView.h"

@implementation UITableView (AddTipsView)


void addTipsSwizzMethod(Class class, Class newClass, SEL oriSel, SEL newSel) {
    
    Method oriMethod = class_getInstanceMethod(class, oriSel);
    Method newMethod = class_getInstanceMethod(newClass, newSel);
    
    BOOL success = class_addMethod(class, oriSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (success) {
        class_replaceMethod(class, newSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

//+ (void)load {
//
//    SEL selectors[] = {
//        @selector(setDelegate:),
//        @selector(setDataSource:)
//    };
//
//    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
//        SEL originalSelector = selectors[index];
//        SEL swizzledSelector = NSSelectorFromString([@"llj_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
//        addTipsSwizzMethod([UITableView class],[UITableView class],originalSelector, swizzledSelector);
//    }
//}
- (void)swizzlMethod:(UIViewController *)viewController {
    SEL selectors[] = {
        @selector(tableView:heightForRowAtIndexPath:),
        @selector(tableView:cellForRowAtIndexPath:)
    };

    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"llj_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        addTipsSwizzMethod([viewController class],[UITableView class],originalSelector, swizzledSelector);
    }
}

//- (void)llj_setDelegate:(id<UITableViewDelegate>)delegate {
//    if (delegate) {
//        addTipsSwizzMethod([delegate class],[self class],
//                            @selector(tableView:heightForRowAtIndexPath:),
//                            @selector(llj_tableView:heightForRowAtIndexPath:));
//    }
//    [self llj_setDelegate:delegate];
//}
//- (void)llj_setDataSource:(id<UITableViewDataSource>)dataSource {
//    if (dataSource) {
//        addTipsSwizzMethod([dataSource class],[self class],
//                    @selector(tableView:cellForRowAtIndexPath:),
//                    @selector(llj_tableView:cellForRowAtIndexPath:));
//    }
//    [self llj_setDataSource:dataSource];
//}

- (CGFloat)llj_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self llj_tableView:tableView heightForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [self llj_tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.rowHeight;
}

- (UITableViewCell *)llj_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self llj_tableView:tableView cellForRowAtIndexPath:indexPath];
    [self addTips:tableView cell:cell indexPath:indexPath];
    return cell;
}

- (void)addTips:(UITableView *)tableView cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (cell.tipsContent.length > 0) {
        //重设frame
        CGRect newFrame;
        newFrame.origin.x = tableView.frame.origin.x;
        newFrame.origin.y = tableView.frame.origin.y;
        newFrame.size.height = [tableView llj_tableView:tableView heightForRowAtIndexPath:indexPath];
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
    } else {
        UIView *label = [tableView viewWithTag:9000000001];
        [label removeFromSuperview];
    }
}
@end
