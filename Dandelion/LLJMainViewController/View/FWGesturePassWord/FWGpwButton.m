//
//  FWGpwButton.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/22.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWGpwButton.h"
#import "FWGpwView.h"

@interface FWGpwButton ()

@property (nonatomic, strong) FWGpwModel *model;

@end

@implementation FWGpwButton

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame model:(FWGpwModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        
        self.model = model;
    }
    return self;
}

#pragma mark - 绘制图形 -
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    __weak FWGpwView *gesView = nil;
    if ([self.superview isKindOfClass:[FWGpwView class]]) {
        gesView = (FWGpwView *)self.superview;
    }
    CGFloat radius = self.model.circleRadius - self.model.strokeWidth;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.model.strokeWidth);
    CGPoint centerPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat startAngle = -((CGFloat)M_PI/2);
    CGFloat endAngle = ((2 * (CGFloat)M_PI) + startAngle);
    [gesView.strokeColor setStroke];
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius+self.model.strokeWidth/2, startAngle, endAngle, 0);
    CGContextStrokePath(context);
    
    if (self.model.showCenterPoint) {
        [gesView.fillColor set];//同时设置填充和边框色
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, 0);
        CGContextFillPath(context);
        if (self.model.fillCenterPoint) {
            [gesView.centerPointColor set];//同时设置填充和边框色
        }else{
            [gesView.centerPointColor setStroke];//设置边框色
        }
        CGContextAddArc(context, centerPoint.x, centerPoint.y, self.model.centerPointRadius, startAngle, endAngle, 0);
        if (self.model.fillCenterPoint) {
            CGContextFillPath(context);
        }else{
            CGContextStrokePath(context);
        }
    }
}

@end
