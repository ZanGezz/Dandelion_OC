//
//  LLJGesManage.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/11.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLJVideoPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LLJGesClickType) {
    LLJGesClickTypeTapOnce,                 //单击
    LLJGesClickTypeTapTwice,                //双击
    LLJGesClickTypePanLeftAndVertical,      //左侧竖直
    LLJGesClickTypePanRightAndVertical,     //右侧竖直
    LLJGesClickTypePanHorizontal            //水平
};

@interface LLJGesManage : NSObject

@property (nonatomic) CGFloat pan_base_s;          //基础活动距离,计算滑动百分比使用，即：value = pan_s / pan_base_s；

@property (nonatomic, copy) void (^gesClick)(LLJGesClickType type, UIGestureRecognizerState state, CGFloat totalValue, CGFloat unitValue);

- (instancetype)initWithTapView:(UIView *)tapView model:(LLJVideoPlayModel *)model;

@end

NS_ASSUME_NONNULL_END
