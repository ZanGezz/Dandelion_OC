//
//  LLJPlayManage.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/3.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJPlayManage.h"

@interface LLJPlayManage ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) LLJVideoPlayModel *model;

@end

@implementation LLJPlayManage

- (instancetype)initWithPlayModel:(LLJVideoPlayModel *)model player:(AVPlayer *)player {
    self = [super init];
    if (self) {
        
        self.model = model;
        self.player = player;
        [self addObserVers];
    }
    return self;
}

- (void)llj_seekTime:(NSInteger)time completionHandler:(void (^)(BOOL))completionHandler {
    LLJWeakSelf(self);
    time = time + self.currentTime;
    int32_t timeScale = self.player.currentItem.asset.duration.timescale;
    CMTime seekTime = CMTimeMakeWithSeconds(time, timeScale);
    [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
        if (finished) {
            [weakSelf.player play];
            !completionHandler ?: completionHandler(finished);
        }
    }];
}

- (void)llj_seekToTime:(NSInteger)time andPlay:(BOOL)isPlay completionHandler:(void (^)(BOOL finished))completionHandler {
    LLJWeakSelf(self);
    int32_t timeScale = self.player.currentItem.asset.duration.timescale;
    CMTime seekTime = CMTimeMakeWithSeconds(time, timeScale);
    [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
        if (finished && isPlay) {
            [weakSelf.player play];
            !completionHandler ?: completionHandler(finished);
        }
    }];
}

- (void)setRate:(float)rate {
    self.player.rate = rate;
}

- (float)rate {
    return self.player.rate;
}

- (BOOL)isPlaying {
    if (self.player.rate == 0.0) {
        return NO;
    }else{
        return YES;
    }
}

- (void)addObserVers {
    
    LLJWeakSelf(self);
    //播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //缓存时间
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //缓存不够视频无法加载
    [self.player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //缓冲完成可以继续播放
    [self.player.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    //缓冲完成可以继续播放
    [self.player.currentItem addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishToPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];


    
    //播放时长
    __block NSInteger firstTime = 0;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        
        AVPlayerItem *item = weakSelf.player.currentItem;
        if (weakSelf.player.rate > 0) {
            weakSelf.status = LLJPlayerStatusPlaying;
            !weakSelf.playStatus ?: weakSelf.playStatus(weakSelf.status);
        }else{
            weakSelf.status = LLJPlayerStatusPause;
            !weakSelf.playStatus ?: weakSelf.playStatus(weakSelf.status);
        }
        
        //计算当前播放时间
        CGFloat currentTime = floor(item.currentTime.value/item.currentTime.timescale);
        weakSelf.currentTime = currentTime;
        //总时间
        weakSelf.totalTime = floor(CMTimeGetSeconds(item.duration));
        //当前进度条进度
        CGFloat value = currentTime/weakSelf.totalTime;
        
        if (weakSelf.currentTime > firstTime) {
            //回调
            !weakSelf.currentPlayTime ?: weakSelf.currentPlayTime(weakSelf.currentTime,weakSelf.totalTime,value);
        }
        firstTime = weakSelf.currentTime;

    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //播放状态
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.currentItem.status) {
            case AVPlayerItemStatusUnknown:
                self.status = LLJPlayerStatusUnknown;
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                self.status = LLJPlayerStatusReadyToPlay;
            }
                break;
            case AVPlayerItemStatusFailed:
                self.status = LLJPlayerStatusFailed;
                break;
            default:
                break;
        }
    }
    
    //缓冲时长
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = self.player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        if (self.totalTime > 0 && totalBuffer >= 0) {
            !self.loadedTime ?: self.loadedTime(totalBuffer/self.totalTime);
        }
    }
    
    //没有缓冲 加载中
    if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (self.player.currentItem.playbackBufferEmpty) {
            self.status = LLJPlayerStatusLoading;
        }
    }
    
    //继续播放
    if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        //由于AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
        [self.player play];
    }
    
    !self.playStatus ?: self.playStatus(self.status);
    
    //自动播放
    if (self.model.isAutoPlay && self.status == LLJPlayerStatusReadyToPlay) {
        [self.player play];
    }
}

- (void)removeServer {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player.currentItem removeObserver:self forKeyPath:@"timeControlStatus"];
}

- (void)finishToPlay:(NSNotification *)noti {
    //播放结束
    self.status = LLJPlayerStatusEnd;
    !self.playStatus ?: self.playStatus(self.status);
}

- (void)dealloc {
    [self removeServer];
    NSLog(@"class = %@",NSStringFromClass([self class]));
}


@end
