//
//  LLJRecordModel.m
//  Dandelion
//
//  Created by 刘帅 on 2020/6/9.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJRecordModel.h"

@interface LLJRecordModel ()

@end

@implementation LLJRecordModel

#pragma mark - 初始化 -
- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _recordType          = LLJRecordTypeVideo;
        _inputType           = LLJDeviceInputTypeBack;
        _videoOrientation    = AVCaptureVideoOrientationPortrait;
        _videoGravity        = AVLayerVideoGravityResizeAspectFill;
        _fileType            = AVFileTypeMPEG4;
        _sessionPreset       = AVCaptureSessionPresetHigh;
        _writeToPhotoLibrary = NO;
        _flashLightOn        = NO;
    }
    return self;
}

- (void)setFilePath:(NSString *)filePath{
    
    _filePath = filePath;
    [self createSourcePath:filePath];
    if (_fileName) {
        _filePath = [_filePath stringByAppendingPathComponent:_fileName];
    }
}
- (void)setFileName:(NSString *)fileName{
    
    _fileName = fileName;
    if (_filePath) {
        _filePath = [_filePath stringByAppendingPathComponent:_fileName];
    }
}

//创建文件路径
- (BOOL)createSourcePath:(NSString *)sourcePath {
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:sourcePath isDirectory:&isDir];
    if (!existed) {
        existed = [fileManager createDirectoryAtPath:sourcePath withIntermediateDirectories:YES attributes:nil error:nil];
    };
    return existed;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}
@end
