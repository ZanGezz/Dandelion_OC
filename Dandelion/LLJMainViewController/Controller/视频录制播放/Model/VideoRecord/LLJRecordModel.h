//
//  LLJRecordModel.h
//  Dandelion
//
//  Created by 刘帅 on 2020/6/9.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LLJRecordType) {
    LLJRecordTypeVideo,             //录制视频
    LLJRecordTypeAudio              //录制音频
};

typedef NS_ENUM(NSUInteger, LLJDeviceInputType) {
    LLJDeviceInputTypeBack,         //后置摄像头
    LLJDeviceInputTypeFront         //前置摄像头（默认）
};

@interface LLJRecordModel : NSObject

/**
 *  最大录制时长设置（单位：秒）
 *  到时长自动结束录制
 */
@property (nonatomic) NSTimeInterval            maxRecordTime;
/**
 *  录制视频存放路径
 */
@property (nonatomic, copy) NSString           *filePath;
/**
 *  录制视频名称   xxx.mp4 或 xxx.m4v 或 xxx.mov 或 xxx.3gp
 *  录制音频名称   xxx.mp4 或 xxx.wav 或 xxx.caf
 */
@property (nonatomic, copy) NSString           *fileName;
/**
 *  录制视频输出格式（ 默认AVFileTypeMPEG4）
 *  例如: AVFileTypeMPEG4
 *      AVFileTypeQuickTimeMovie
 *      AVFileTypeAppleM4V
 *      AVFileType3GPP
 *      等
 */
@property (nonatomic) AVFileType                fileType;
/**
 *  录制类型 录制音频还是视频  (默认录制视频)
 */
@property (nonatomic) LLJRecordType             recordType;
/**
 *  录制使用摄像头 前置还是后置  (默认后置摄像头)
 */
@property (nonatomic) LLJDeviceInputType        inputType;
/**
 *  录制视频输出方向  ( 默认同手机方向)
 */
@property (nonatomic) AVCaptureVideoOrientation videoOrientation;
/**
 *  视频捕获铺满类型 （默认  AVLayerVideoGravityResizeAspectFill）
 */
@property (nonatomic) AVLayerVideoGravity       videoGravity;
/**
 *  视频捕获质量（默认  AVCaptureSessionPresetHigh 最好质量）
 */
@property (nonatomic) AVCaptureSessionPreset    sessionPreset;

/**
 *  录制完成是否同步写入相册默认不写入 NO
 */
@property (nonatomic) BOOL    writeToPhotoLibrary;

/**
 *  是否开启闪光灯(默认不开启)
 */
@property (nonatomic) BOOL    flashLightOn;

@end

NS_ASSUME_NONNULL_END
