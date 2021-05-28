//
//  LLJVideoPlayModel.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJVideoPlayModel : NSObject

/**
 *  播放视频地址集合
 */
@property (nonatomic, strong) NSArray *videoUrlArray;
/**
 *  播放视频地址
 */
@property (nonatomic, copy, nonnull) NSURL *videoUrl;
/**
 *  是否开启自动播放 （默认YES自动播放）
 */
@property (nonatomic) BOOL isAutoPlay;

/**
 *  播放资源是否是本地m3u8格式 (如果是则此属性必须设置为YES,默认NO)
 */
@property (nonatomic) BOOL isLocalM3U8;

/**
 *  播放器bounds 用于设置控制层view的frame
 */
@property (nonatomic, readonly) CGRect playerBounds;

/**
 *  当前是否为全屏
 */
@property (nonatomic, readonly) BOOL isCurrentFullScreen;

/**
 *  进入页面直接全屏
 */
@property (nonatomic) BOOL fullScreenWhenEnterPlayer;

/**
 *  首次进入播放器是否显示控制层
 */
@property (nonatomic) BOOL hiddenControlViewWhenEnterPlayer;

/**
 *  全屏设置时是旋转屏幕还是旋转view ；YES表示旋转屏幕；默认YES
 */
@property (nonatomic) BOOL rotateScreenWhenRotateToFullView;

/**
 *  当前播放器方向
 */
@property (nonatomic, readwrite) CGAffineTransform transform;

/**
 *  竖屏时是否允许调整音量
 */
@property (nonatomic) BOOL isVolumeAdjustmentAllowedSmallScreen;

/**
 *  竖屏时是否允许调整亮度
 */
@property (nonatomic) BOOL isBrightAdjustmentAllowedSmallScreen;

/**
 *  竖屏时是否允许调整进度
 */
@property (nonatomic) BOOL isSliderAdjustmentAllowedSmallScreen;


@end

NS_ASSUME_NONNULL_END
