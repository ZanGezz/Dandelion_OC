//
//  LLJViewRotateManage.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/9.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJViewRotateManage.h"
#import "LLJBaseVideoPlayer.h"

@interface LLJViewRotateManage ()

@property (nonatomic, strong) LLJVideoPlayModel *model;
@property (nonatomic, strong) LLJBaseVideoPlayer *rotateView;
@property (nonatomic) CGRect smallScreenFrame;
@property (nonatomic) UIInterfaceOrientation lastOrientation;


@end

@implementation LLJViewRotateManage

- (instancetype)initWithModel:(LLJVideoPlayModel *)model rotateView:(nonnull UIView *)rotateView
{
    self = [super init];
    if (self) {
        
        self.rotateView = (LLJBaseVideoPlayer *)rotateView;
        self.lastOrientation = UIInterfaceOrientationPortrait;
        self.model = model;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewRotate {
    
    if (self.model.rotateScreenWhenRotateToFullView) {
        if (!self.rotateView.isCurrentFullScreen) {
            //强制旋屏横屏
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
            [UIViewController attemptRotationToDeviceOrientation];
        }else{
            //强制旋屏竖屏
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
            [UIViewController attemptRotationToDeviceOrientation];
        }
    }else{
        
        BOOL fullScreen = NO;
        if (!self.rotateView.isCurrentFullScreen) {
            //强制旋屏横屏
            [UIView animateWithDuration:0.35 animations:^{
                self.rotateView.transform = CGAffineTransformMakeRotation(M_PI_2);
            }];
            fullScreen = YES;
        }else{
            //强制旋屏竖屏
            [UIView animateWithDuration:0.35 animations:^{
                self.rotateView.transform = CGAffineTransformIdentity;
            }];
            fullScreen = NO;
        }
        self.model.transform = self.rotateView.transform;
        !self.rotateScreen ?: self.rotateScreen(fullScreen);
    }
}

- (void)changeRotation{
    
    BOOL isFullScreenNow = NO;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            isFullScreenNow = NO;
            if (!self.model.rotateScreenWhenRotateToFullView) {
                [UIView animateWithDuration:0.35 animations:^{
                    self.rotateView.transform = CGAffineTransformIdentity;
                }];
            }
            self.lastOrientation = interfaceOrientation;
            self.model.transform = self.rotateView.transform;
            !self.rotateScreen ?: self.rotateScreen(isFullScreenNow);
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            isFullScreenNow = YES;
            if (!self.model.rotateScreenWhenRotateToFullView) {
                switch (self.lastOrientation) {
                    case UIInterfaceOrientationPortrait:{
                        [UIView animateWithDuration:0.35 animations:^{
                            self.rotateView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                        }];
                    }
                        break;
                    case UIInterfaceOrientationLandscapeLeft:{
                        [UIView animateWithDuration:0.35 animations:^{
                            self.rotateView.transform = CGAffineTransformMakeRotation(0);
                        }];
                    }
                        break;
                    case UIInterfaceOrientationLandscapeRight: {
                        [UIView animateWithDuration:0.35 animations:^{
                            self.rotateView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                        }];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            self.lastOrientation = interfaceOrientation;
            self.model.transform = self.rotateView.transform;
            !self.rotateScreen ?: self.rotateScreen(isFullScreenNow);
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            isFullScreenNow = YES;
            
            if (!self.model.rotateScreenWhenRotateToFullView) {
                switch (self.lastOrientation) {
                    case UIInterfaceOrientationPortrait:
                    {
                        [UIView animateWithDuration:0.35 animations:^{
                            self.rotateView.transform = CGAffineTransformMakeRotation(M_PI_2);
                        }];
                    }
                        break;
                    case UIInterfaceOrientationLandscapeLeft:
                    {
                        [UIView animateWithDuration:0.35 animations:^{
                            self.rotateView.transform = CGAffineTransformMakeRotation(M_PI_2);
                        }];
                    }
                        break;
                    case UIInterfaceOrientationLandscapeRight:
                    {
                        [UIView animateWithDuration:0.35 animations:^{
                            self.rotateView.transform = CGAffineTransformMakeRotation(0);
                        }];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            self.lastOrientation = interfaceOrientation;
            self.model.transform = self.rotateView.transform;
            !self.rotateScreen ?: self.rotateScreen(isFullScreenNow);
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:{
            
        }
        default:
            break;
    }
    [self rotateScreen:isFullScreenNow];
}

#pragma mark - 旋转屏幕 -
- (void)rotateScreen:(BOOL)toFull {
    
    if (toFull) {
        if (!self.model.rotateScreenWhenRotateToFullView) {
            self.rotateView.frame = self.rotateView.animateCommenRotateViewFullScreenFrame;
        }else{
            self.rotateView.frame = self.rotateView.animateCommenFullScreenFrame;
        }
        for (CALayer *layer in self.rotateView.layer.sublayers) {
            layer.frame = self.rotateView.bounds;
        }
        //self.playerLayer.frame = self.bounds;
    }else {
        self.rotateView.frame = self.rotateView.animateCommenSmallScreenFrame;
        
        for (CALayer *layer in self.rotateView.layer.sublayers) {
            layer.frame = self.rotateView.bounds;
        }
        //self.playerLayer.frame = self.bounds;
    }
    //重新获取bounds
    [self.model setValue:[NSValue valueWithCGRect:self.rotateView.bounds] forKeyPath:@"playerBounds"];
    //控制层旋转屏幕重新布局
    [self.rotateView.controlManage rotateScreen:toFull];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
