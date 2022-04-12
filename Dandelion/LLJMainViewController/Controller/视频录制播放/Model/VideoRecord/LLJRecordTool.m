//
//  LLJRecordTool.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/15.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJRecordTool.h"
#import <AVFoundation/AVFoundation.h>

#define DefaultQueue "com.dandelion.LLJ.cn"

@interface LLJRecordTool ()<CAAnimationDelegate>
{
    CGFloat _cx;             //视频分辨率x
    CGFloat _cy;             //视频分辨率y
    CGFloat _channels;       //音频通道
    CGFloat _samplerate;     //音频采样率
}

@property (nonatomic, weak)   id                          delegate;

@end

@implementation LLJRecordTool

#pragma mark - 初始化 -
- (instancetype)initWithRecordModel:(LLJRecordModel *)model outPutDelegate:(nullable id<AVCaptureVideoDataOutputSampleBufferDelegate>)sampleBufferDelegate{
    
    self = [super init];
    if (self) {
        _model = model;
        _delegate = sampleBufferDelegate;
        
        [self reset];
    }
    return self;
}

- (void)setModel:(LLJRecordModel *)model {
    _model = model;
}

- (void)toolRelease{

    if (self.writer.status == AVAssetWriterStatusWriting) {
        [self.writer finishWritingWithCompletionHandler:^{}];
    }
    if (_session.running) {
        [_session stopRunning];
    }

    _writer              = nil;
    _videoInput          = nil;
    _audioInput          = nil;
    _session             = nil;
    _backCameraInput     = nil;
    _frontCameraInput    = nil;
    _audioMicInput       = nil;
    _audioConnection     = nil;
    _videoConnection     = nil;
    _videoOutput         = nil;
    _audioOutput         = nil;
    _captureQueue        = nil;
    _previewLayer        = nil;
}

- (void)reset{
    
    if (self.writer.status == AVAssetWriterStatusWriting) {
        [self.writer finishWritingWithCompletionHandler:^{}];
    }
    _writer = nil;
    _videoInput = nil;
    _audioInput = nil;
    _sampleBufferCanBeWrited = NO;
    //删除路径下的文件
    [[NSFileManager defaultManager] removeItemAtPath:self.model.filePath error:nil];
}

- (void)setUpWriterInput:(CMSampleBufferRef)sampleBuffer isVideo:(BOOL)isVideo{
    
    CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);

    if (isVideo && !_videoInput) {
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(fmt);
        if (dimensions.width && dimensions.height) {
            _cx = dimensions.width;
            _cy = dimensions.height;
        }
        if ([self.writer canAddInput:self.videoInput]) {
            [self.writer addInput:self.videoInput];
        }
    }else if (!_audioInput && !isVideo) {
        const AudioStreamBasicDescription *description = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
        if (description->mChannelsPerFrame && description->mSampleRate) {
            _channels = description->mChannelsPerFrame;
            _samplerate = description->mSampleRate;
        }
        if ([self.writer canAddInput:self.audioInput]) {
            [self.writer addInput:self.audioInput];
        }
    }
    
    if (_videoInput && _audioInput) {
        self.sampleBufferCanBeWrited = YES;
    }else{
        self.sampleBufferCanBeWrited = NO;
    }
}

- (NSDictionary *)videoOutPutSetting:(CGFloat)width height:(CGFloat)height{
    //录制视频的一些配置，分辨率，编码方式等等
    return [NSDictionary dictionaryWithObjectsAndKeys:
                              AVVideoCodecH264, AVVideoCodecKey,
                              [NSNumber numberWithInteger: width], AVVideoWidthKey,
                              [NSNumber numberWithInteger: height], AVVideoHeightKey,
                              nil];
}
- (NSDictionary *)audioOutPutSetting:(CGFloat)channels sampleRate:(CGFloat)sampleRate{
    //音频的一些配置包括音频各种这里为AAC,音频通道、采样率和音频的比特率
    return [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                              [NSNumber numberWithInt: channels], AVNumberOfChannelsKey,
                              [NSNumber numberWithFloat: sampleRate], AVSampleRateKey,
                              [NSNumber numberWithInt: 128000], AVEncoderBitRateKey,
                              nil];
}

//切换动画
- (void)changeCameraAnimation {
    CATransition *changeAnimation = [CATransition animation];
    changeAnimation.delegate = self;
    changeAnimation.duration = 0.35;
    changeAnimation.type = @"oglFlip";
    changeAnimation.subtype = kCATransitionFromRight;
    changeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.previewLayer addAnimation:changeAnimation forKey:@"changeAnimation"];
}
- (void)animationDidStart:(CAAnimation *)anim{
    
    [self.session startRunning];
    //重新开启闪光灯  如果有[self.session startRunning]方法调用，开启闪光灯必须放在startRunning后，
    //否则闪光灯开启后又因startRunning的调用而关闭，导致闪烁的问题；
    [self openFlashLight];
}
#pragma mark - 添加切换摄像头 -
- (void)addCameraInput{
    
    if (self.session.running) {
        [self.session stopRunning];
    }
    //[self.session beginConfiguration]; //改方法之间不能使用[self.session stopRunning];
    if (self.model.inputType == LLJDeviceInputTypeFront) {
        //添加前置摄像头的输入
        [_session removeInput:self.backCameraInput];
        if ([_session canAddInput:self.frontCameraInput]) {
            [self changeCameraAnimation];
            [_session addInput:self.frontCameraInput];
        }
    }else{
        //添加后置摄像头的输入
        [_session removeInput:self.frontCameraInput];
        if ([_session canAddInput:self.backCameraInput]) {
            [self changeCameraAnimation];
            [_session addInput:self.backCameraInput];
        }
    }
    //[self.session commitConfiguration];
    //视频输出方向
    self.videoConnection.videoOrientation = self.model.videoOrientation;
}

- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        if ([_session canSetSessionPreset:self.model.sessionPreset]) {
            [_session setSessionPreset:self.model.sessionPreset];
        }
        //添加视频输出
        if ([_session canAddOutput:self.videoOutput]) {
            [_session addOutput:self.videoOutput];
        }
        //添加音频输出
        if ([_session canAddOutput:self.audioOutput]) {
            [_session addOutput:self.audioOutput];
        }
        //添加麦克风的输入
        if ([_session canAddInput:self.audioMicInput]) {
            [_session addInput:self.audioMicInput];
        }
        //添加视频输入
        [self addCameraInput];
    }
    return _session;
}
//后置摄像头输入
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        if (error) {
            NSLog(@"获取后置摄像头失败~");
        }
    }
    return _backCameraInput;
}

//前置摄像头输入
- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        if (error) {
            NSLog(@"获取前置摄像头失败~");
        }
    }
    return _frontCameraInput;
}

//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

//麦克风输入
- (AVCaptureDeviceInput *)audioMicInput {
    if (_audioMicInput == nil) {
        AVCaptureDevice *mic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        _audioMicInput = [AVCaptureDeviceInput deviceInputWithDevice:mic error:&error];
        if (error) {
            NSLog(@"获取麦克风失败~");
        }
    }
    return _audioMicInput;
}

//视频输出
- (AVCaptureVideoDataOutput *)videoOutput {
    if (_videoOutput == nil) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setSampleBufferDelegate:_delegate queue:self.captureQueue];
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        _videoOutput.videoSettings = setcapSettings;
    }
    return _videoOutput;
}

//音频输出
- (AVCaptureAudioDataOutput *)audioOutput {
    if (_audioOutput == nil) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:_delegate queue:self.captureQueue];
    }
    return _audioOutput;
}

//视频连接
- (AVCaptureConnection *)videoConnection {
    _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    return _videoConnection;
}

//音频连接
- (AVCaptureConnection *)audioConnection {
    if (_audioConnection == nil) {
        _audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];
    }
    return _audioConnection;
}

//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer == nil) {
        //通过AVCaptureSession初始化
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        //设置比例为铺满全屏
        _previewLayer.videoGravity = self.model.videoGravity;
    }
    return _previewLayer;
}

//录制的队列
- (dispatch_queue_t)captureQueue {
    if (_captureQueue == nil) {
        _captureQueue = dispatch_queue_create(DefaultQueue, DISPATCH_QUEUE_SERIAL);
    }
    return _captureQueue;
}

- (AVAssetWriter *)writer{
    if (!_writer) {
        NSError *error;
        _writer = [[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:self.model.filePath] fileType:self.model.fileType error:&error];
        //使其更适合在网络上播放
        _writer.shouldOptimizeForNetworkUse = YES;
    }
    return _writer;
}

- (AVAssetWriterInput *)videoInput{
    if (!_videoInput) {
        
        _videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self videoOutPutSetting:_cx height:_cy]];
        //表明输入是否应该调整其处理为实时数据源的数据
        _videoInput.expectsMediaDataInRealTime = YES;
    }
    return _videoInput;
}

- (AVAssetWriterInput *)audioInput{
    if (!_audioInput) {
        _audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self audioOutPutSetting:_channels sampleRate:_samplerate]];
        //表明输入是否应该调整其处理为实时数据源的数据
        _audioInput.expectsMediaDataInRealTime = YES;
    }
    return _audioInput;
}

//开启闪光灯
- (void)openFlashLight {
    
    if (self.model.inputType == LLJDeviceInputTypeBack) {
        AVCaptureDevice *backCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        //[_session beginConfiguration];
        [backCamera lockForConfiguration:nil];
        if (backCamera.torchMode == AVCaptureTorchModeOff && self.model.flashLightOn) {
            backCamera.torchMode = AVCaptureTorchModeOn;
            backCamera.flashMode = AVCaptureFlashModeOn;
        }else if (backCamera.torchMode == AVCaptureTorchModeOn && !self.model.flashLightOn) {
            backCamera.torchMode = AVCaptureTorchModeOff;
            backCamera.flashMode = AVCaptureTorchModeOff;
        }
        [backCamera unlockForConfiguration];
        //[_session beginConfiguration];
    }
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}
@end
