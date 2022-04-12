//
//  LLJBaseVideoPlayer.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/27.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLJControlViewManage.h"
#import "LLJPlayManage.h"
#import "LLJViewRotateManage.h"
#import "LLJGesManage.h"
#import "LLJVideoPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLJBaseVideoPlayer : UIView

@property (nonatomic, strong, nullable) LLJControlViewManage  *controlManage;
@property (nonatomic, strong, nullable) LLJViewRotateManage   *rotateManage;
@property (nonatomic, strong, nullable) LLJPlayManage         *playManage;
@property (nonatomic, strong, nullable) LLJGesManage          *gesManage;
@property (nonatomic, strong, nullable) LLJVideoPlayModel     *model;

@property (nonatomic,         readonly) BOOL                   isCurrentFullScreen;

/**
 *  初始化方法
 *
 *  @return LLJVideoPlayer的实体
 */
- (instancetype)initWithFrame:(CGRect)frame playModel:(nonnull LLJVideoPlayModel *)model;


/**
 *  初始化方法
 */
- (void)exchangePlayerSourceWithModel:(nonnull NSURL *)url;

/**
 *  开始播放
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)pause;

/**
 *  旋转屏幕toFull = yes 表示旋转到全屏
 */
//- (void)rotateScreen:(BOOL)toFull;

/**
 *  旋转layer
 */
- (void)rotateLayer;

/**
 *  释放播放工具
 */
- (void)toolRelease;

/**
 *  播放下一集
 */
- (void)nextPlayer:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
