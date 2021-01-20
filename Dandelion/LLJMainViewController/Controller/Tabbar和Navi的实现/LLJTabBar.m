//
//  LLJTabBar.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJTabBar.h"

@implementation LLJTabBar

#pragma mark - 初始化 -
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //tabbar去除黑线
        self.translucent = NO;
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage new]];
        
        self.plusItem = [[UIButton alloc] init];
        self.plusItem.adjustsImageWhenHighlighted = NO; // 去除选择时高亮
        [self.plusItem setBackgroundImage:[UIImage imageNamed:@"icon_more_n"] forState:UIControlStateNormal];
        [self addSubview:self.plusItem];
    }
    return self;
}
#pragma mark - 布局 -
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width / 3;
    
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    NSInteger index = 0;
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *child in self.subviews) {
        if ([child isKindOfClass:class]) {
            CGFloat width = itemWidth;
            CGFloat height = child.frame.size.height;
            CGFloat x = index * width;
            CGFloat y = child.frame.origin.y;
            child.frame = CGRectMake(x, y, width, height);
            index++;
            if (index == 1) {
                CGFloat plusX = itemWidth * index + (itemWidth - self.plusItem.currentBackgroundImage.size.width)/2;
                CGFloat plusY = -(height / 3);
                self.plusItem.frame = CGRectMake(plusX, plusY, self.plusItem.currentBackgroundImage.size.width, self.plusItem.currentBackgroundImage.size.height);
                index ++;
            }
        }
    }
    [self bringSubviewToFront:self.plusItem];
}

#pragma mark - 处理超出区域点击无效的问题
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden) {
        return [super hitTest:point withEvent:event];
    } else {
        //转换坐标
        CGPoint tempPoint = [self convertPoint:point toView:self.plusItem];
        //判断点击的点是否在按钮区域内
        if ([self.plusItem pointInside:tempPoint withEvent:event]) {
            return self.plusItem;
        } else {
            return [super hitTest:point withEvent:event];
        }
    }
}

@end
