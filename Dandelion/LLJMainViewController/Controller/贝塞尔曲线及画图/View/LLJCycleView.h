//
//  LLJCycleView.h
//  Dandelion
//
//  Created by 刘帅 on 2021/2/24.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJCycleView : UIView

//圆环圆心Label Text
@property (nonatomic, copy) NSString *text;
//圆环圆心位置
@property (nonatomic) CGPoint cycleCenterPoint;

//圆环半径
@property (nonatomic) CGFloat cycleRadius;

//线宽
@property (nonatomic) CGFloat lineWidth;

//默认YES顺时针
@property (nonatomic) CGFloat clockwise;

//是否需要加分割 默认添加 YES
@property (nonatomic) BOOL needDivision;

//分割占比 默认0.002
@property (nonatomic) double divisionRatio;

//分割颜色 默认白色
@property (nonatomic, strong) UIColor *divisionColor;

//是否开启动画 默认 NO:不开启
@property (nonatomic) BOOL strokeWithAnimation;

//动画时长 默认 1.0s
@property (nonatomic) NSTimeInterval animationDuration;

//开始角度 默认 0 度
@property (nonatomic) CGFloat startAngle;

//动画时长 默认 M_PI*2
@property (nonatomic) CGFloat endAngle;

/**
 * 开始划线
 */
- (void)strokeWithSource:(NSArray *)sourceArray;

@end

NS_ASSUME_NONNULL_END
