//
//  FWWebLoadHelper.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/20.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWWebLoadHelper.h"
#import "LLJWebCacheModel+CoreDataClass.h"


static NSString * const hasInitKey = @"LLMarkerProtocolKey";

@interface FWWebLoadHelper ()<NSURLSessionDataDelegate>

@property (readwrite, nonatomic, strong) NSURLSession *session;

@end

@implementation FWWebLoadHelper

+ (void)startMonitorRequest:(WKWebViewConfiguration *)configuration{
    [configuration.userContentController imy_installHookAjax];
    [self startMonitorRequest];
}

+ (void)cancelMonitorRequest:(WKWebViewConfiguration *)configuration{
    [configuration.userContentController imy_uninstallHookAjax];
    [self cancelMonitorRequest];
}

+ (void)startMonitorRequest{

    [NSURLProtocol registerClass:[FWWebLoadHelper class]];
    // 实现WKWebView拦截功能
    Class cls = NSClassFromString(@"WKBrowsingContextController");
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:@"http"];
        [(id)cls performSelector:sel withObject:@"https"];
        
#pragma clang diagnostic pop
    }
}

+ (void)cancelMonitorRequest{
    
    [NSURLProtocol unregisterClass:[FWWebLoadHelper class]];
    Class cls = NSClassFromString(@"WKBrowsingContextController");
        SEL sel = NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
        if ([(id)cls respondsToSelector:sel]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [(id)cls performSelector:sel withObject:@"http"];
            [(id)cls performSelector:sel withObject:@"https"];
    #pragma clang diagnostic pop
        }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    if ([NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
        return NO;
    }
    
    if ([self hasLocalStaticSource:request.URL.absoluteString]) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    
    return request;
}
//开始加载数据
- (void)startLoading{
    
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];

    __block NSString *filePath = @"";

    //如果缓存存在，并是支持的mimeType，则返回缓存数据，否则使用系统默认处理
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.request URL] MIMEType:nil expectedContentLength:[fileData length] textEncodingName:@"UTF-8"];
        NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:fileData];
        
        if (cachedResponse) {
            [self.client URLProtocol:self didReceiveResponse:cachedResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [self.client URLProtocol:self didLoadData:cachedResponse.data];
            [self.client URLProtocolDidFinishLoading:self];
        }
    }else{
        
        [self netRequestWithRequest:mutableReqeust];
    }
}

//判断是否是本地文件需要处理请求
+ (BOOL)hasLocalStaticSource:(NSString *)urlString{
    
    return NO;
}

//从HTTPBodyStream解析HTTPBody
+ (NSURLRequest *)getNewRequest:(NSURLRequest *)req{
    
    NSMutableURLRequest *request = [req mutableCopy];
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        if (!request.HTTPBody) {
            NSInteger maxLength = 1024;
            uint8_t d[maxLength];
            NSInputStream *stream = request.HTTPBodyStream;
            NSMutableData *data = [[NSMutableData alloc]init];
            [stream open];
            BOOL endOfStream = NO;
            while (!endOfStream) {
                NSInteger bytesRead = [stream read:d maxLength:maxLength];
                if (bytesRead == 0) {
                    endOfStream = YES;
                }else if (bytesRead == -1){
                    endOfStream = YES;
                }else if (stream.streamError == nil){
                    [data appendBytes:(void *)d length:bytesRead];
                }
            }
            request.HTTPBody = [data copy];
            [stream close];
        }
    }
    return request;
}

- (void)stopLoading{
    [self.session invalidateAndCancel];
    self.session = nil;
}
- (void)netRequestWithRequest:(NSURLRequest *)request{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *forgeroundNetQueue = [[NSOperationQueue alloc] init];
    forgeroundNetQueue.maxConcurrentOperationCount = 10;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:forgeroundNetQueue];
    NSURLSessionDataTask *sessionTask = [self.session dataTaskWithRequest:request];
    [sessionTask resume];
}
#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}
- (void)dealloc{
    NSLog(@"FWWebLoadHelper ..");
}

@end
