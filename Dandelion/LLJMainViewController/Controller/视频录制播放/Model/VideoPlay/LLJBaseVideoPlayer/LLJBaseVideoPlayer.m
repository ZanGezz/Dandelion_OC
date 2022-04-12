//
//  LLJBaseVideoPlayer.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/27.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJBaseVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "LLJVideoHelper.h"

@interface LLJBaseVideoPlayer ()

@property (nonatomic, strong) AVAsset           *asset;
@property (nonatomic, strong) AVPlayer          *player;
@property (nonatomic, strong) AVPlayerItem      *item;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer;

@end

@implementation LLJBaseVideoPlayer

#pragma mark - 播放 -
- (void)play {
    
    [self.player play];
}
- (void)pause {
    [self.player pause];
}


#pragma mark - set 和 get 方法实现 -
- (BOOL)isCurrentFullScreen {
    
    if(!self.model.rotateScreenWhenRotateToFullView) {
        if (ceilf(self.frame.size.height) == SCREEN_HEIGHT) {
            return YES;
        }else{
            return NO;
        }
    }else {
        if (ceilf(self.frame.size.width) == (SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH)) {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark - 旋转Layer -
- (void)rotateLayer {
    
    CATransform3D turnTrans = CATransform3DRotate(self.playerLayer.transform,-M_PI/2, 0, 0, 1);
    self.playerLayer.transform = turnTrans;
    //重设frame
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 释放工具类 -
- (void)toolRelease {
    
    [self pause];
    [self playerRelease];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer     = nil;
    [self.controlManage subViewRemoveFormSuperView];
    self.controlManage   = nil;
    self.rotateManage    = nil;
    self.playManage      = nil;
    self.gesManage       = nil;
}
- (void)playerRelease {
    self.player          = nil;
    self.asset           = nil;
    self.item            = nil;
}

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame playModel:(nonnull LLJVideoPlayModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [model setValue:[NSValue valueWithCGRect:self.bounds] forKeyPath:@"playerBounds"];
        self.animateCommenSmallScreenFrame = frame;
        self.animateCommenFullScreenFrame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        self.animateCommenRotateViewFullScreenFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
        self.model = model;
        [self creatPlayer:model];
    
    }
    return self;
}
- (void)creatPlayer:(LLJVideoPlayModel *)model {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    _asset = [AVURLAsset URLAssetWithURL:self.model.videoUrl options:nil];
    _item = [AVPlayerItem playerItemWithAsset:_asset];
    _player = [AVPlayer playerWithPlayerItem:_item];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    self.playerLayer.frame = self.bounds;
    self.layer.masksToBounds = YES;
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    //[self.layer addSublayer:self.playerLayer];
    
    LLJPlayManage *playManage = [[LLJPlayManage alloc]initWithPlayModel:model player:self.player];
    self.playManage = playManage;
    
    LLJViewRotateManage *rotateManage  = [[LLJViewRotateManage alloc]initWithModel:model rotateView:self];
    self.rotateManage = rotateManage;

    LLJControlViewManage *controlManage = [[LLJControlViewManage alloc]initWithPlayerModel:model];
    self.controlManage = controlManage;

    LLJGesManage *gesManage     = [[LLJGesManage alloc]initWithTapView:self.controlManage.centerView model:model];
    self.gesManage = gesManage;

}

- (void)exchangePlayerSourceWithModel:(nonnull NSURL *)url{
    
    self.model.videoUrl = url;

    [self toolRelease];
    [self creatPlayer:self.model];
}

- (void)nextPlayer:(NSURL *)url {
    self.model.videoUrl = url;
    [self exchangePlayerSourceWithModel:url];
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
