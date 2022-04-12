//
//  LLJVideoPlayer.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/22.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJVideoPlayer.h"

@interface LLJVideoPlayer ()


@end

@implementation LLJVideoPlayer

- (void)createDefaultPlayerUI {
    
    //初始化工具类
    LLJWeakSelf(self);
    LLJDefaultPlayerUI *defaultUI = [[LLJDefaultPlayerUI alloc]initWithSuperView:self model:self.model controlManage:self.controlManage];
    self.defaultUI = defaultUI;
    //标题
    self.defaultUI.title = @"败家讲谈";
    //返回
    self.defaultUI.backClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"返回1");
        if (weakSelf.isCurrentFullScreen) {
            [weakSelf.rotateManage viewRotate];
        } else {
            [weakSelf.superViewController.navigationController popViewControllerAnimated:YES];
        }
    };
    //清晰度
    self.defaultUI.definiteClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"上一集");
        NSURL *url;
        for (int i = 0; i < self.model.videoUrlArray.count; i ++) {
            url = weakSelf.model.videoUrlArray[i];
            if ([url.absoluteString isEqualToString:weakSelf.model.videoUrl.absoluteString]) {
                if (i > 0) {
                    url = weakSelf.model.videoUrlArray[i-1];
                    [weakSelf nextPlayer:url];
                    [weakSelf createDefaultPlayerUI];
                    break;
                } else {
                    [MBProgressHUD showMessag:@"第一集了" toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
                }
            }
        }
    };
    //速率
    self.defaultUI.rateClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"下一集");
        NSURL *url;
        for (int i = 0; i < self.model.videoUrlArray.count; i ++) {
            url = weakSelf.model.videoUrlArray[i];
            if ([url.absoluteString isEqualToString:weakSelf.model.videoUrl.absoluteString]) {
                if (weakSelf.model.videoUrlArray.count > i + 1) {
                    url = weakSelf.model.videoUrlArray[i+1];
                    [weakSelf nextPlayer:url];
                    [weakSelf createDefaultPlayerUI];
                    break;
                } else {
                    [MBProgressHUD showMessag:@"最后一集了" toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
                }
            }
        }
    };
    //锁屏
    self.defaultUI.lockClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"锁屏");
        weakSelf.controlManage.topViewAlwaysHidden = YES;
        weakSelf.controlManage.bottomViewAlwaysHidden = YES;
    };
    //解锁屏
    self.defaultUI.unLockClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"解锁屏");
        weakSelf.controlManage.topViewAlwaysHidden = NO;
        weakSelf.controlManage.bottomViewAlwaysHidden = NO;
    };
    //开始播放
    self.defaultUI.playClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"开始播放");
        if (weakSelf.playManage.status == LLJPlayerStatusEnd) {
            [weakSelf.playManage llj_seekToTime:0 andPlay:YES completionHandler:^(BOOL finished) {
                
            }];
            //刷新时长
            weakSelf.defaultUI.sliderValue = 0;
            weakSelf.defaultUI.currentTimeLabelText = [LLJHelper formatSecondsToString:weakSelf.playManage.totalTime*weakSelf.defaultUI.sliderValue hourHidden:NO];
        } else {
            [weakSelf play];
        }
    };
    //暂停
    self.defaultUI.pauseClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"暂停");
        [weakSelf pause];
    };
    //全屏
    self.defaultUI.fullScreenClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"全屏");
        [weakSelf.rotateManage viewRotate];
    };
    //旋转
    self.defaultUI.rotationClick = ^(UIButton * _Nonnull sender) {
        NSLog(@"全屏");
        [weakSelf rotateLayer];
    };
    
    //slider开始
    self.defaultUI.sliderBegin = ^(UISlider * _Nonnull sender) {
        NSLog(@"slider开始");
        [weakSelf pause];
        
    };
    //slider Moving
    self.defaultUI.sliderMoving = ^(UISlider * _Nonnull sender) {
        NSLog(@"slider Moving = %f",weakSelf.playManage.totalTime*sender.value);
        //刷新总时长
        weakSelf.defaultUI.currentTimeLabelText = [LLJHelper formatSecondsToString:weakSelf.playManage.totalTime*sender.value hourHidden:NO];
        
    };
    //slider结束
    self.defaultUI.sliderEnd = ^(UISlider * _Nonnull sender) {
        NSLog(@"slider结束 = %f",weakSelf.playManage.totalTime*sender.value);
        [weakSelf.playManage llj_seekToTime:weakSelf.playManage.totalTime*sender.value andPlay:YES completionHandler:^(BOOL finished) {
        }];
    };
    
    //创建控制回调
    [self makeControlManage];
}

//创建控制回调
- (void)makeControlManage {
    
    LLJWeakSelf(self);
    //手势事件
    self.gesManage.gesClick = ^(LLJGesClickType type, UIGestureRecognizerState state, CGFloat totalValue, CGFloat unitValue) {
        
        switch (type) {
            case LLJGesClickTypeTapOnce:
            {
                //单击显示隐藏控制层
                [weakSelf.controlManage controlViewHidden:!weakSelf.controlManage.isCurrentControlViewAllHidden];
            }
                break;
            case LLJGesClickTypeTapTwice:
            {
                //双击切换全屏半屏
                [weakSelf.rotateManage viewRotate];
            }
                break;
            case LLJGesClickTypePanLeftAndVertical:
            {
                //调整亮度
                weakSelf.defaultUI.brightValue = [LLJHelper getSystemBright] + unitValue;

            }
                break;
            case LLJGesClickTypePanRightAndVertical:
            {
                //调整音量
                weakSelf.defaultUI.volumeValue = [LLJHelper getSystemVolume] + unitValue;
            }
                break;
            case LLJGesClickTypePanHorizontal:
            {
                switch (state) {
                    case UIGestureRecognizerStateChanged:
                    {
                        //快进前暂停
                        if (weakSelf.playManage.isPlaying) {
                            [weakSelf pause];
                        }
                        //快进中刷新时长
                        weakSelf.defaultUI.sliderValue += unitValue;
                        weakSelf.defaultUI.currentTimeLabelText = [LLJHelper formatSecondsToString:weakSelf.playManage.totalTime*weakSelf.defaultUI.sliderValue hourHidden:NO];
                        
                    }
                        break;
                    case UIGestureRecognizerStateEnded:
                    {
                        //快进
                        [weakSelf.playManage llj_seekToTime:weakSelf.playManage.totalTime*weakSelf.defaultUI.sliderValue andPlay:YES completionHandler:^(BOOL finished) {
                        }];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
        
    };
    
    
    //旋转屏幕回调
    self.rotateManage.rotateScreen = ^(BOOL toFull) {
        [weakSelf.defaultUI updateVolumeViewTransForm];
    };
    
    
    
    //播放状态
    self.playManage.playStatus = ^(LLJPlayerStatus status) {
        switch (status) {
            case LLJPlayerStatusPause:{
                [weakSelf.defaultUI upDatePlayButtonStatus:NO];
            }
                break;
            case LLJPlayerStatusPlaying:{
                [weakSelf.defaultUI upDatePlayButtonStatus:YES];
            }
                break;
            case LLJPlayerStatusReadyToPlay:{
                //必须在视频准备播放之后获取播放总时长，否则获取不到
            }
                break;
            case LLJPlayerStatusEnd:{
                //播放完毕
                [weakSelf.defaultUI upDatePlayButtonStatus:NO];
                NSLog(@"播放完毕");
            }
                break;
                
            default:
                break;
        }
    };
    //缓冲状态
    self.playManage.loadedTime = ^(CGFloat value) {
        weakSelf.defaultUI.loadValue = value;
    };
    
    //播放当前时长
    self.playManage.currentPlayTime = ^(NSInteger currentTime, NSInteger totalTime, CGFloat value) {
        
        //刷新当前时长
        weakSelf.defaultUI.totalTimeLabelText = [LLJHelper formatSecondsToString:totalTime hourHidden:NO];
        //刷新总时长
        weakSelf.defaultUI.currentTimeLabelText = [LLJHelper formatSecondsToString:currentTime hourHidden:NO];
        //刷新进度
        weakSelf.defaultUI.sliderValue = value;
    };
}

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame playModel:(LLJVideoPlayModel *)model {
    self = [super initWithFrame:frame playModel:model];
    if (self) {
        [self createDefaultPlayerUI];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
