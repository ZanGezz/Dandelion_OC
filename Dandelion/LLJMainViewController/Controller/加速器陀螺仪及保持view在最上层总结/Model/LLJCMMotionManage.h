//
//  LLJCMMotionManage.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/29.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>

NS_ASSUME_NONNULL_BEGIN

//typedef简化Block的声明 声明一类block
typedef void (^updateBlock)(CGFloat aX,CGFloat aY,CGFloat aZ, NSError * _Nullable error);

@interface LLJCMMotionManage : NSObject

/**
 *  陀螺仪多少秒触发一次回调，默认0.01秒
 */
@property (nonatomic) NSTimeInterval gyroUpdateInterval;
/**
 *  计时器多少秒触发一次回调，默认0.01秒
 */
@property (nonatomic) NSTimeInterval accelerometerUpdateInterval;
/**
 *  加速计push方式获取
 */
- (void)cmmotionStartAccelerometerUpdates:(updateBlock)block;
/**
 *  停止加速度
 */
- (void)stopAccelerometerUpdate;

/**
 *  陀螺仪push方式获取
 */
- (void)cmmotionStartGyroUpdates:(updateBlock)block;

/**
 *  停止陀螺仪
 */
- (void)stopGyroUpdate;

@end

NS_ASSUME_NONNULL_END
