//
//  LLJDownLoadManage.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/16.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSessionTask+Helper.h"
#import "LLJDownLoadModel.h"

NS_ASSUME_NONNULL_BEGIN

#define LLJDownLoad [LLJDownLoadManage defaultManage]

@interface LLJDownLoadManage : NSObject

@property (nonatomic, readonly) BOOL isCurrentGPRS;
@property (nonatomic) BOOL allowDownLoadWhenCurrentGPRS;
@property (nonatomic) NSInteger maxDownloadNum;

+ (LLJDownLoadManage *)defaultManage;

- (void)addDownLoadSourceWithUrl:(LLJDownLoadModel *)model;

- (void)startDownLoadWithModel:(LLJDownLoadModel *)model;

- (NSArray *)removeModelWithTimeTag:(NSString *)timeTag;

- (NSArray *)getDestinationModelWithType:(LLJDownLoadType)type;

- (NSArray *)getAllowDownLoadSourceExceptFinish;

@end

NS_ASSUME_NONNULL_END
