//
//  LLJCMMotionButton.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/29.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJCMMotionButton.h"
#import "LLJCMMotionManage.h"

@interface LLJCMMotionButton ()

@property (nonatomic, strong) LLJCMMotionManage *manager;
@property (nonatomic) CGFloat speedX;
@property (nonatomic) CGFloat speedY;
@property (nonatomic) CGAffineTransform cmTransform;


@end

@implementation LLJCMMotionButton

- (void)stopCMMotion {
    [self.manager stopAccelerometerUpdate];
    self.manager = nil;
}

- (void)addCMMotion {
    
    self.topBackSpeed = 0.2;
    self.leftBackSpeed = 0.2;
    self.bottomBackSpeed = 0.2;
    self.rightBackSpeed = 0.2;
    self.speedX = self.speedY = 0;
    self.cmTransform = CGAffineTransformIdentity;
    self.manager.accelerometerUpdateInterval = 0.001;
    LLJWeakSelf(self);
    [self.manager cmmotionStartAccelerometerUpdates:^(CGFloat aX, CGFloat aY, CGFloat aZ, NSError * _Nullable error) {
        [weakSelf resetViewCenter:aX aY:aY];
    }];
}

- (void)resetViewCenter:(CGFloat)aX aY:(CGFloat)aY {
    
    CGFloat Vxp = (self.speedX + self.speedX + aX*10*self.manager.accelerometerUpdateInterval)/2;
    CGFloat Vyp = (self.speedY + self.speedY + aY*10*self.manager.accelerometerUpdateInterval)/2;
    
    //NSLog(@"ax = %f,ay = %f",aX,aY);
    self.speedX += aX*10*self.manager.accelerometerUpdateInterval;
    //y轴方向的速度加上y轴方向获得的加速度
    self.speedY += aY*10*self.manager.accelerometerUpdateInterval;

    //小方块将要移动到的x轴坐标
    CGFloat centerX = self.center.x + Vxp*self.manager.accelerometerUpdateInterval*15700;
    //小方块将要移动到的y轴坐标
    CGFloat centerY = self.center.y - Vyp*self.manager.accelerometerUpdateInterval*15700;
    
    //碰到屏幕边缘反弹
    if (centerX < self.bounds.size.width/2) {
        centerX = self.bounds.size.width/2;
        //碰到屏幕左边以0.4倍的速度反弹
        self.speedX *= - self.leftBackSpeed;
    }else if(centerX > kRootView.bounds.size.width - self.bounds.size.width/2){
        centerX = kRootView.bounds.size.width - self.bounds.size.width/2;
        //碰到屏幕右边以0.4倍的速度反弹
        self.speedX *= - self.rightBackSpeed;
    }
    if (centerY < self.bounds.size.height/2) {
        centerY = self.bounds.size.height/2;
        //碰到屏幕上边不反弹
        self.speedY *= -self.topBackSpeed;
    }else if (centerY > kRootView.bounds.size.height - self.bounds.size.height/2){
        centerY = kRootView.bounds.size.height - self.bounds.size.height/2;
        //碰到屏幕下边以1.5倍的速度反弹
        self.speedY *= - self.bottomBackSpeed;
    }

    //移动小方块
    self.center = CGPointMake(centerX, centerY);

    //计算滚动角度
    if (centerX == self.bounds.size.width/2 && centerY != self.bounds.size.height/2 && centerY != kRootView.bounds.size.height - self.bounds.size.height/2) {
        [self resetViewTransform:-self.speedY*self.manager.accelerometerUpdateInterval*15700/(self.bounds.size.width/2)];
    }else if (centerX == kRootView.bounds.size.width - self.bounds.size.width/2 && centerY != self.bounds.size.height/2 && centerY != kRootView.bounds.size.height - self.bounds.size.height/2) {
        [self resetViewTransform:self.speedY*self.manager.accelerometerUpdateInterval*15700/(self.bounds.size.width/2)];
    }else if (centerY == self.bounds.size.height/2 && centerX != kRootView.bounds.size.width - self.bounds.size.width/2 && centerX != self.bounds.size.width/2) {
        [self resetViewTransform:-self.speedX*self.manager.accelerometerUpdateInterval*15700/(self.bounds.size.height/2)];
    }else if (centerY == kRootView.bounds.size.height - self.bounds.size.height/2 && centerX != kRootView.bounds.size.width - self.bounds.size.width/2 && centerX != self.bounds.size.width/2) {
        [self resetViewTransform:self.speedX*self.manager.accelerometerUpdateInterval*15700/(self.bounds.size.height/2)];
    }
}

- (void)resetViewTransform:(CGFloat)angle{
    self.transform = CGAffineTransformRotate(self.cmTransform, angle);
    self.cmTransform = self.transform;
}

- (LLJCMMotionManage *)manager{
    if (!_manager) {
        _manager = [[LLJCMMotionManage alloc]init];
    }
    return _manager;
}
- (void)dealloc {
    [self.manager stopAccelerometerUpdate];
}

@end
