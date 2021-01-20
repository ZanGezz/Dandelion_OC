//
//  LLJRecordManage.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/20.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLJRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LLJRecordManageDelegate <NSObject>

- (void)recordTime:(NSTimeInterval)time;

@end

@interface LLJRecordManage : NSObject

@property (nonatomic, strong) LLJRecordModel *model;

@property (nonatomic, weak) id<LLJRecordManageDelegate> delegate;
/**
 *  初始化方法
 *
 *  @param preview   视频捕获view
 *
 *  @return LLJRecordTool的实体
 */
- (instancetype)initWithPreview:(UIView *)preview recordModel:(LLJRecordModel *)model;

/**
 *  开始录制
 */
- (void)start;
/**
 *  结束录制
 */
- (void)finish;
/**
 *  暂停录制
 */
- (void)pause;
/**
 *  继续录制
 */
- (void)resume;
/**
 *  切换摄像头
 */
- (void)changeCameraInput;
/**
 *  开启闪光灯yes开启
 */
- (void)openFlashLight;

@end

NS_ASSUME_NONNULL_END
