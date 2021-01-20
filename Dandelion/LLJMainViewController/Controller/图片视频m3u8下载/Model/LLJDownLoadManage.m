//
//  LLJDownLoadManage.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/16.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJDownLoadManage.h"

static LLJDownLoadManage *_defaultManage = nil;

@interface LLJDownLoadManage ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableArray *downLoadArray;
@property (nonatomic) NSInteger currentDownLoadingNum;

@end

@implementation LLJDownLoadManage

+ (LLJDownLoadManage *)defaultManage {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManage = [[LLJDownLoadManage alloc]init];
        _defaultManage.maxDownloadNum = 5;
    });
    return _defaultManage;
}

- (void)addDownLoadSourceWithUrl:(LLJDownLoadModel *)model {
    
    if (model.urlString.length > 0) {
        model.type = LLJDownLoadTypePrePared;
        [self getDataTaskWithModel:model];
        [self.downLoadArray addObject:model];
        //开启下载
        [self startDownLoadWithModel:model];
    }
}
- (void)getDataTaskWithModel:(LLJDownLoadModel*)model {
    
    [model.task cancel];
    model.task = nil;
    NSURLSessionDataTask *task = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:model.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180];
    //指定要下载的位置，断点续下
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", (long)model.totlalReceivedSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    task = [self.session dataTaskWithRequest:request];
    task.timeTag = [LLJHelper getTimeInterval:[NSDate date]];
    model.task = task;
}

- (void)startDownLoadWithModel:(LLJDownLoadModel *)model {
    
    if (self.currentDownLoadingNum == self.maxDownloadNum) {
    
        if (model.type == LLJDownLoadTypeError) {
            //如果出错处理
            [self getDataTaskWithModel:model];
            model.type = LLJDownLoadTypeWait;
        }else{
            model.type = LLJDownLoadTypeWait;
        }
    }else {

        if (model.type == LLJDownLoadTypeError) {
            //如果出错处理
            [self getDataTaskWithModel:model];
        }
        [model resume];

    }
}

- (void)startAll {
    
    NSArray *downLoad = self.downLoadArray;
    for (LLJDownLoadModel *model in downLoad) {
        if (model.type == LLJDownLoadTypeDownLoading) {
            [model.task suspend];
            model.type = LLJDownLoadTypePause;
        }
    }
}

- (void)suspendAll {
    
    NSArray *downLoad = self.downLoadArray;
    for (LLJDownLoadModel *model in downLoad) {
        if (model.type == LLJDownLoadTypeDownLoading) {
            [model.task suspend];
            model.type = LLJDownLoadTypePause;
        }
    }
}

- (void)resetDownLoadTypeWhenNetChange {
    if (!self.allowDownLoadWhenCurrentGPRS) {
        [self suspendAll];
    }
}

- (void)downLoadFirstWaitSource {
    LLJDownLoadModel *model = [[self getDestinationModelWithType:LLJDownLoadTypeWait] firstObject];
    [model resume];
}

- (NSArray *)getDestinationModelWithType:(LLJDownLoadType)type {
    NSArray *downLoad = self.downLoadArray;
    NSMutableArray *array = [NSMutableArray array];
    [downLoad enumerateObjectsUsingBlock:^(LLJDownLoadModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == type) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (NSArray *)getDestinationModelWithTimeTag:(NSString *)TimeTag {
    NSArray *downLoad = self.downLoadArray;
    NSMutableArray *array = [NSMutableArray array];
    [downLoad enumerateObjectsUsingBlock:^(LLJDownLoadModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.task.timeTag isEqualToString:TimeTag]) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (NSArray *)getAllowDownLoadSourceExceptFinish {
    
    NSArray *downLoad = self.downLoadArray;
    NSMutableArray *array = [NSMutableArray array];
    [downLoad enumerateObjectsUsingBlock:^(LLJDownLoadModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != LLJDownLoadTypeFinish) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (NSArray *)removeModelWithTimeTag:(NSString *)timeTag {
    
    LLJDownLoadModel *model = [[self getDestinationModelWithTimeTag:timeTag] firstObject];
    if (model) {
        [self.downLoadArray removeObject:model];
    }
    return self.downLoadArray;
}

#pragma mark - NSURLSessionDataDelegate -
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    LLJDownLoadModel *model = [[self getDestinationModelWithTimeTag:dataTask.timeTag] firstObject];
    if (model) {
        [model didReceiveResponse:response];
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    LLJDownLoadModel *model = [[self getDestinationModelWithTimeTag:dataTask.timeTag] firstObject];
    [model didReceiveData:data];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    LLJDownLoadModel *model = [[self getDestinationModelWithTimeTag:task.timeTag] firstObject];
    
    if (error.code == -1001 && model.type == LLJDownLoadTypePause) {
        [self getDataTaskWithModel:model];
    }else{
        // 处理结束
        [model didCompleteWithError:error];
    }
    
    //下载完成一个开启一个新的
    [self downLoadFirstWaitSource];
}

#pragma mark - 观察网络变化 -
- (void)addObserverForNetWork {
    [LLJNetWork addObserver:self forKeyPath:@"networkState" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"networkState"]) {
        //网络发生变化
        [self resetDownLoadTypeWhenNetChange];
    }
}

#pragma mark - set 和 get 方法 -
- (BOOL)isCurrentGPRS {
    return [LLJNetWork.networkState isEqualToString:@"1"];
}

- (NSInteger)currentDownLoadingNum {
    NSArray *downLoad = self.downLoadArray;
    _currentDownLoadingNum = 0;
    for (LLJDownLoadModel *model in downLoad) {
        if (model.type == LLJDownLoadTypeDownLoading) {
            _currentDownLoadingNum ++;
        }
    }
    return _currentDownLoadingNum;
}

#pragma mark - 懒加载属性 -
- (NSMutableArray *)downLoadArray {
    if (!_downLoadArray) {
        _downLoadArray = [NSMutableArray array];
    }
    return _downLoadArray;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        //******此属性控制最大并发task数，不设置默认4，也就是最多开启4个任务********
        cfg.HTTPMaximumConnectionsPerHost = self.maxDownloadNum;
        _session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    }
    return _session;
}


- (void)dealloc {
    [LLJNetWork removeObserver:self forKeyPath:@"networkState"];

    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
