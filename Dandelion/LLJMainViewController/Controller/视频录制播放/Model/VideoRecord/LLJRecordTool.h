//
//  LLJRecordTool.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/15.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLJRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLJRecordTool : NSObject

@property (nonatomic, strong) LLJRecordModel             *model;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;      //捕获到的视频呈现的layer
@property (strong, nonatomic) AVCaptureSession           *session;           //捕获视频的会话
@property (strong, nonatomic) AVCaptureDeviceInput       *backCameraInput;   //后置摄像头输入
@property (strong, nonatomic) AVCaptureDeviceInput       *frontCameraInput;  //前置摄像头输入
@property (strong, nonatomic) AVCaptureDeviceInput       *audioMicInput;     //麦克风输入
@property (strong, nonatomic) AVCaptureConnection        *audioConnection;   //音频录制连接
@property (strong, nonatomic) AVCaptureConnection        *videoConnection;   //视频录制连接
@property (strong, nonatomic) AVCaptureVideoDataOutput   *videoOutput;       //视频输出
@property (strong, nonatomic) AVCaptureAudioDataOutput   *audioOutput;       //音频输出
@property (copy  , nonatomic) dispatch_queue_t           captureQueue;       //录制的队列
@property (nonatomic, strong) AVAssetWriter              *writer;            //媒体写入对象
@property (nonatomic, strong) AVAssetWriterInput         *videoInput;        //视频写入
@property (nonatomic, strong) AVAssetWriterInput         *audioInput;        //音频写入

@property (nonatomic)         BOOL               sampleBufferCanBeWrited;    //可以开始写入数据


- (instancetype)initWithRecordModel:(LLJRecordModel *)model outPutDelegate:(nullable id<AVCaptureVideoDataOutputSampleBufferDelegate>)sampleBufferDelegate;

/**
 *  初始化设备输出
 */
- (void)setUpWriterInput:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo;

/**
 *  添加设备输入
 */
- (void)addCameraInput;
/**
 *  开启闪光灯
 */
- (void)openFlashLight;
/**
 *  重新录制数据重置
 */
- (void)reset;
/**
 *  录制结束释放内存
 */
- (void)toolRelease;

NS_ASSUME_NONNULL_END

@end
