//
//  LLJRecordManage.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/20.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJRecordManage.h"
#import <AVFoundation/AVFoundation.h>
#import "LLJRecordTool.h"
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, LLJRecordStatus) {
    LLJRecordStatusPrepare,             //准备写入
    LLJRecordStatusStart,               //开始写入
    LLJRecordStatusFinish,              //停止写入
    LLJRecordStatusReset,               //重新开始写入
    LLJRecordStatusPause,               //暂停写入
    LLJRecordStatusResume               //继续写入
};

@interface LLJRecordManage ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    CMTime _lastVideo;
    CMTime _lastAudio;
    BOOL   _videoTimeOffSetUpdate;
    BOOL   _audioTimeOffSetUpdate;
}

@property (nonatomic, assign) float                       recordTime;
@property (nonatomic, assign) CMTime                      videotimeOffSet;
@property (nonatomic, assign) CMTime                      audiotimeOffSet;
@property (nonatomic, assign) CMTime                      startTime;
@property (nonatomic, strong) LLJRecordTool              *tool;              //录制工具
@property (nonatomic, assign) LLJRecordStatus             status;

@end

@implementation LLJRecordManage


#pragma mark - 开始录制 -
- (void)start{
    
    if (self.status == LLJRecordStatusPrepare) {
        
        self.status = LLJRecordStatusStart;
    }else if (self.status == LLJRecordStatusFinish){
        
        self.status = LLJRecordStatusReset;
    }
}

#pragma mark - 暂停录制 -
- (void)pause{
    
    if (self.status == LLJRecordStatusStart) {
        self.status = LLJRecordStatusPause;
    }
}

#pragma mark - 结束录制 -
- (void)finish{
    
    if (self.status == LLJRecordStatusStart || self.status == LLJRecordStatusPause) {
        
        LLJWeakSelf(self);
        self.status = LLJRecordStatusFinish;
        [self finishWritingSourceWithCompletionHandler:^{
            
            //重置录制时间
            [weakSelf timeReset];
            
            //写入相册
            if(weakSelf.model.writeToPhotoLibrary) {
                //写入相册
                PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
                [photoLibrary performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL
                fileURLWithPath:weakSelf.model.filePath]];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"已将视频保存至相册");
                    } else {
                        NSLog(@"未能保存视频到相册");
                    }
                }];
            }
        }];
    }
}

#pragma mark - 继续录制 -
- (void)resume {
    
    if (self.status == LLJRecordStatusPause) {
        self.status = LLJRecordStatusResume;
    }
}

#pragma mark - 切换摄像头 -
- (void)changeCameraInput {
    
    if (self.model.recordType == LLJRecordTypeVideo) {
        
        if (self.model.inputType == LLJDeviceInputTypeFront) {
            self.model.inputType = LLJDeviceInputTypeBack;
        }else{
            self.model.inputType = LLJDeviceInputTypeFront;
        }
        [self.tool addCameraInput];
    }
}

#pragma mark - 开启或关闭闪光灯 -
- (void)openFlashLight {
    
    self.model.flashLightOn = !self.model.flashLightOn;
    [self.tool openFlashLight];

}

#pragma mark - 视频流输出 -
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    BOOL isVideo = captureOutput == self.tool.videoOutput ? YES : NO;
    //流媒体数据处理及写入
    if (self.status == LLJRecordStatusPrepare || self.status == LLJRecordStatusPause || self.status == LLJRecordStatusFinish) {
        return;
    }
    
    //重新录制
    if (self.status == LLJRecordStatusReset) {
        //重置写入工具
        [self.tool reset];
        self.recordTime = 0.0;
        self.status = LLJRecordStatusStart;
    }
    
    
    //创建视频写入
    if (!self.tool.sampleBufferCanBeWrited) {

        [self.tool setUpWriterInput:sampleBuffer isVideo:isVideo];
        return;
    }else{
        //获取初试时间
        if (_startTime.value == 0) {
            _startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        }
    }
    
    
    //记录暂停上一次录制的时间
    if (self.status == LLJRecordStatusResume) {
        self.status = LLJRecordStatusStart;
    }
    
    //处理暂停流媒体时间
    if (!_videoTimeOffSetUpdate && isVideo) {
        [self resetDiscuntTime:sampleBuffer isVideo:isVideo];
    }
    if (!_audioTimeOffSetUpdate && !isVideo) {
        [self resetDiscuntTime:sampleBuffer isVideo:isVideo];
    }
    
    
    //增加sampleBuffer的引用计时,这样我们可以释放这个或修改这个数据，防止在修改时被释放
    CFRetain(sampleBuffer);
    if (_videotimeOffSet.value > 0 && isVideo) {
        CFRelease(sampleBuffer);
        //根据得到的timeOffset调整
        sampleBuffer = [self adjustTime:sampleBuffer by:_videotimeOffSet];
    }
    if (_audiotimeOffSet.value > 0 && !isVideo) {
        CFRelease(sampleBuffer);
        //根据得到的timeOffset调整
        sampleBuffer = [self adjustTime:sampleBuffer by:_audiotimeOffSet];
    }
    
    
    //记录最后buffer时间和录制时间
    [self setLastSampleBufferTime:sampleBuffer isVideo:isVideo];
    
    
    //发送录制时长代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordTime:)]) {
        
        [self.delegate recordTime:self.recordTime];
    }
    NSLog(@"recordTime = %f",self.recordTime);
    
    //写入流媒体
    [self writeSampleBuffer:sampleBuffer isVideo:isVideo];
    
    
    CFRelease(sampleBuffer);
}

- (void)writeSampleBuffer:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo {
    //数据是否准备写入
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        //写入状态为未知,保证视频先写入
        if (self.tool.writer.status == AVAssetWriterStatusUnknown) {
            //获取开始写入的CMTime
            CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            //开始写入
            [self.tool.writer startWriting];
            [self.tool.writer startSessionAtSourceTime:startTime];
        }else if(self.tool.writer.status == AVAssetWriterStatusWriting){
            
            //判断是否是视频
            if (isVideo) {
                //视频输入是否准备接受更多的媒体数据
                if (self.tool.videoInput.readyForMoreMediaData && self.model.recordType == LLJRecordTypeVideo) {
                    //拼接数据
                    [self.tool.videoInput appendSampleBuffer:sampleBuffer];
                }
            }else {
                //音频输入是否准备接受更多的媒体数据
                if (self.tool.audioInput.readyForMoreMediaData) {
                    //拼接数据
                    [self.tool.audioInput appendSampleBuffer:sampleBuffer];
                }
            }
        }else if (self.tool.writer.status == AVAssetWriterStatusFailed) {
            
            NSLog(@"writer error %@", self.tool.writer.error.localizedDescription);
        }
    }
}

//计算录制中断时间
- (void)resetDiscuntTime:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo{
    
    //计算暂停的时间
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    CMTime last = isVideo ? _lastVideo : _lastAudio;
    if (last.flags & kCMTimeFlags_Valid) {
        CMTime offset = CMTimeSubtract(pts, last);
        if (isVideo) {
            _videotimeOffSet = offset;
            _videoTimeOffSetUpdate = YES;
        }else{
            _audiotimeOffSet = offset;
            _audioTimeOffSetUpdate = YES;
        }
    }
}

//记录最后sampleBuffer的时间
- (void)setLastSampleBufferTime:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo{
    
    //记录暂停上一次录制的时间
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
    if (dur.value > 0) {
        pts = CMTimeAdd(pts, dur);
    }
    if (isVideo) {
        _lastVideo = pts;
    }else{
        _lastAudio = pts;
    }
    
    //计算录制时间
    float time = CMTimeGetSeconds(CMTimeSubtract(pts, _startTime));
    if (self.recordTime *1000 < time *1000) {
        self.recordTime = time;
    }
    
    //超出最大时长结束录制
    if (self.model.maxRecordTime && (self.model.maxRecordTime *1000 < time *1000)) {
        [self finish];
    }
}

//调整媒体数据的时间
- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset {
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++) {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}

- (void)finishWritingSourceWithCompletionHandler:(void (^)(void))handler{
    if (self.tool.writer.status) {
        [self.tool.writer finishWritingWithCompletionHandler:handler];
    }
}


#pragma mark - 初始化 -
- (instancetype)initWithPreview:(UIView *)preview recordModel:(LLJRecordModel *)model{
    self = [super init];
    if (self) {
        
        _model = model;
        [self timeReset];
        //初始化录制工具
        self.tool = [[LLJRecordTool alloc]initWithRecordModel:model outPutDelegate:self];
        
        [preview layoutIfNeeded];
        self.tool.previewLayer.frame = preview.bounds;
        //[preview.layer insertSublayer:self.tool.previewLayer atIndex:0];
        [preview.layer addSublayer:self.tool.previewLayer];
        [self.tool.session startRunning];
    }
    return self;
}
- (void)setModel:(LLJRecordModel *)model {
    _model = model;
    _tool.model = model;
}
- (void)timeReset{
    
    _startTime   = CMTimeMake(0, 0);
    _videotimeOffSet = CMTimeMake(0, 0);
    _audiotimeOffSet = CMTimeMake(0, 0);
    _videoTimeOffSetUpdate = YES;
    _audioTimeOffSetUpdate = YES;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
