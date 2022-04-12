//
//  LLJPlayManage.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/3.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LLJVideoPlayModel.h"

typedef NS_ENUM(NSUInteger, LLJPlayerStatus) {
    LLJPlayerStatusUnknown,
    LLJPlayerStatusReadyToPlay,
    LLJPlayerStatusFailed,
    LLJPlayerStatusPlaying,
    LLJPlayerStatusPause,
    LLJPlayerStatusLoading,
    LLJPlayerStatusEnd
};

NS_ASSUME_NONNULL_BEGIN

@interface LLJPlayManage : NSObject

@property (nonatomic, copy) void (^currentPlayTime)(NSInteger currentTime,NSInteger totalTime, CGFloat value);
@property (nonatomic, copy) void (^loadedTime)(CGFloat value);

@property (nonatomic, copy) void (^playStatus)(LLJPlayerStatus status);
@property (nonatomic) LLJPlayerStatus status;
@property (nonatomic) NSInteger currentTime;
@property (nonatomic) NSInteger totalTime;
@property (nonatomic) float rate;
@property (nonatomic, readonly) BOOL isPlaying;

- (instancetype)initWithPlayModel:(nonnull LLJVideoPlayModel *)model player:(AVPlayer *)player;

- (void)llj_seekToTime:(NSInteger)time andPlay:(BOOL)isPlay completionHandler:(void (^)(BOOL finished))completionHandler;

- (void)llj_seekTime:(NSInteger)time completionHandler:(void (^)(BOOL finished))completionHandler;

- (void)addObserVers;

@end

NS_ASSUME_NONNULL_END
