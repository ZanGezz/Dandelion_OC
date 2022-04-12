//
//  LLJDownLoadModel.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/18.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJDownLoadModel.h"
#import "NSString+AES128.h"

@interface LLJDownLoadModel ()

@property (nonatomic) BOOL writeDataWithStream;
@property (nonatomic, strong) NSOutputStream *stream;
@property (nonatomic, strong) NSFileHandle *handle;


@end

@implementation LLJDownLoadModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.writeDataWithStream = YES;  //使用输出流方式写入 NO使用文件句柄写入 两者都可
        [self addObserver];
    }
    return self;
}
- (void)resume {
    [self.task resume];
    self.type = LLJDownLoadTypeDownLoading;
}

- (void)suspend {
    [self.task suspend];
    self.type = LLJDownLoadTypePause;
}

- (void)didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *rep = (NSHTTPURLResponse *)response;
    self.totalExpectedSize = [rep.allHeaderFields[@"Content-Length"] floatValue] + self.totlalReceivedSize;

    if (self.writeDataWithStream) {
        //输出流
        [self.stream open];
    }else{
        //文件句柄
        [self.handle seekToEndOfFile];
    }
    self.error = nil;
}
- (void)didReceiveData:(NSData *)data {
    
    if (self.writeDataWithStream) {
        NSInteger result = [self.stream write:data.bytes  maxLength:data.length];
        if (result == -1) {
            self.error = self.stream.streamError;
            [self.task cancel]; // 取消请求
        }else{
            [self updateDownLoadProgress];
        }
    }else{
        //将节点跳到文件的末尾
        [self.handle writeData:data];
        [self.handle seekToEndOfFile];
        [self updateDownLoadProgress];
    }
}

- (void)didCompleteWithError:(NSError *)error {
    
    if (self.writeDataWithStream) {
        //输出流
        [self.stream close];
        self.stream = nil;
    }else {
        //文件句柄
        [self.handle closeFile];
        self.handle = nil;
    }
    if (error) {
        self.type = LLJDownLoadTypeError;
    }else {
        self.type = LLJDownLoadTypeFinish;
    }
}

- (void)addObserver {
    
    [self addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObserver {

    [self removeObserver:self forKeyPath:@"type"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"type"]) {
        !self.updateDownLoadType ?: self.updateDownLoadType(self.type);
    }
}


- (void)updateDownLoadProgress {
    LLJWeakSelf(self);
    self.currentProgress = self.totlalReceivedSize/self.totalExpectedSize;
    dispatch_async(dispatch_get_main_queue(), ^{
        !weakSelf.updateProgress ?: weakSelf.updateProgress(weakSelf.currentProgress);
    });
}

- (CGFloat)totlalReceivedSize {

    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        NSDictionary<NSFileAttributeKey, id> *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:nil];
        _totlalReceivedSize = [dic[NSFileSize] integerValue];
        return _totlalReceivedSize;
    }
    return 0.0;
}

- (NSOutputStream *)stream {
    if (!_stream) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    }
    return _stream;
}

- (NSFileHandle *)handle {
    if (!_handle) {
        _handle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    }
    return _handle;
}

- (void)setUrlString:(NSString *)urlString {
    
    _urlString = urlString;
    if (urlString.length > 0 && _fileName.length == 0) {
        _fileName = [NSString stringWithFormat:@"%@_%@.%@",[urlString md5String],[LLJHelper getTimeInterval:[NSDate date]],urlString.pathExtension];
        if (_filePath.length == 0) {
            
            if([LLJHelper createFilePath:[LLJ_videoDownLoad_Path stringByAppendingPathComponent:_fileName]]) {
                _filePath = [LLJ_videoDownLoad_Path stringByAppendingPathComponent:_fileName];
            }
        }
    }
}

- (void)setFileName:(NSString *)fileName {
    
    _fileName = fileName;

    if (_filePath == 0) {
        if([LLJHelper createSourcePath:LLJ_videoDownLoad_Path]) {
            _filePath = [LLJ_videoDownLoad_Path stringByAppendingPathComponent:_fileName];
        }
    }
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
}
- (void)dealloc {
    [self removeObserver];
    NSLog(@"class = %@",NSStringFromClass([self class]));
}
@end
