//
//  LLJDownLoadModel.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/18.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LLJDownLoadType) {
    LLJDownLoadTypePrePared,   //准备完毕可以下载
    LLJDownLoadTypeWait,       //等待下载
    LLJDownLoadTypePause,      //暂停
    LLJDownLoadTypeDownLoading,//正在下载
    LLJDownLoadTypeFinish,      //下载完成
    LLJDownLoadTypeError       //下载出错
};

NS_ASSUME_NONNULL_BEGIN

@interface LLJDownLoadModel : NSObject

/**
 * 下载任务
 */
@property (nonatomic, strong, nullable) NSURLSessionDataTask   *task;

/**
 * 当前下载状态
 */
@property (nonatomic) LLJDownLoadType             type;
/**
 * 下载地址
 */
@property (nonatomic, copy)   NSString           *urlString;
/**
 * 文件名 会在赋值时生成默认的文件名和路径
 */
@property (nonatomic, copy)   NSString           *fileName;
/**
 * 下载文件路径  不设置会默认生成
 */
@property (nonatomic, copy)   NSString           *filePath;
/**
 * 下载的错误信息
 */
@property (strong, nonatomic, nullable) NSError            *error;
/**
 * 当前进度
 */
@property (nonatomic)         CGFloat             currentProgress;
/**
 * 刷新进度
 */
@property (nonatomic, copy, nullable)   void (^updateProgress)(CGFloat progress);

/**
 * 刷新下载状态
 */
@property (nonatomic, copy, nullable)   void (^updateDownLoadType)(LLJDownLoadType type);
/**
 * 已下载的数量
 */
@property (assign, nonatomic) CGFloat totlalReceivedSize;
/**
 * 文件的总大小
 */
@property (assign, nonatomic) CGFloat totalExpectedSize;

/**
 * 请求刚接收到处理
 */
- (void)didReceiveResponse:(NSURLResponse *)response;
/**
 * 正在接收数据处理
 */
- (void)didReceiveData:(NSData *)data;
/**
 * 下载完成回调处理
 */
- (void)didCompleteWithError:(NSError *)error;

/**
 * 暂停下载
 */
- (void)suspend;
/**
 * 开始下载
 */
- (void)resume;

@end

NS_ASSUME_NONNULL_END
