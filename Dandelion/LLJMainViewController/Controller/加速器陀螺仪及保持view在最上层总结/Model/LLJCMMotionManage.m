//
//  LLJCMMotionManage.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/29.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJCMMotionManage.h"

@interface LLJCMMotionManage ()

@property (nonatomic, strong) CMMotionManager *manage;

@end

@implementation LLJCMMotionManage

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.gyroUpdateInterval = 0.01;
        self.accelerometerUpdateInterval = 0.01;
    }
    return self;
}
/**
 *  加速计push方式获取
 */
- (void)cmmotionStartAccelerometerUpdates:(updateBlock)block {
    
    // 2.判断加速计是否可用
    if (![self.manage isAccelerometerAvailable]) {
        [MBProgressHUD showMessag:@"加速计无法使用" toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
        return;
    }
    // 3.设置加速计更新频率，以秒为单位
    self.manage.accelerometerUpdateInterval = self.accelerometerUpdateInterval;
    
    [self.manage startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        //获取加速度
        CMAcceleration acceleration = accelerometerData.acceleration;
        dispatch_async(dispatch_get_main_queue(), ^{
            !block ?: block(acceleration.x,acceleration.y,acceleration.z,error);
        });
    }];
}

- (void)stopAccelerometerUpdate {
    if ([_manage isAccelerometerActive]) {
        [_manage stopAccelerometerUpdates];
    }
}

/**
 *  陀螺仪push方式获取
 */
- (void)cmmotionStartGyroUpdates:(updateBlock)block {
    // 2.判断陀螺仪是否可用
    if (![self.manage isGyroAvailable]) {
        [MBProgressHUD showMessag:@"陀螺仪不可用" toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
        return;
    }
    // 3.设置陀螺仪更新频率，以秒为单位
    self.manage.gyroUpdateInterval = self.gyroUpdateInterval;
    // 4.开始实时获取
    [self.manage startGyroUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        //获取陀螺仪数据
        CMRotationRate rotationRate = gyroData.rotationRate;
        dispatch_async(dispatch_get_main_queue(), ^{
            !block ?: block(rotationRate.x,rotationRate.y,rotationRate.z,error);
        });
    }];
}

//停止获取陀螺仪数据
- (void)stopGyroUpdate {
    if ([_manage isGyroActive]) {
        [_manage stopGyroUpdates];
    }
}

- (CMMotionManager *)manage {
    if (!_manage) {
        _manage = [[CMMotionManager alloc]init];
    }
    return _manage;
}

@end
