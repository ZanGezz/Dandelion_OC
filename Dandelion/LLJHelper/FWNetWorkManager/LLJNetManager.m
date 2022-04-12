//
//  LLJNetManager.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/21.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "LLJNetManager.h"
#import <AFNetworking.h>
#import "AFNetworkReachabilityManager.h"
#import "FWStaticSourceDownLoad.h"
#import "AppDelegate.h"

@interface LLJNetManager()

@end

@implementation LLJNetManager

#pragma mark - 初始化单例 -
+ (LLJNetManager *)shareInstance
{
    static LLJNetManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[LLJNetManager alloc] init];
    });
    return manger;
}

/**
 *  检测网络
 */
- (void)monitorNetworking
{
    LLJWeakSelf(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case -1:
                //未知网络
                weakSelf.networkState = @"-1";
                break;
            case 0:
                //未知网络
                weakSelf.networkState = @"-1";
                break;
            case 1:
            {
                //4g
                self.networkState = @"1";
            }
                break;
            case 2:
            {
                //wifi
                self.networkState = @"2";
            }
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
/**
 *  普通网络请求
 */
- (void)startWithMethod:(NSString *)method
                    url:(NSString *)urlString
                baseURL:(NSURL *)baseURL
                headers:(NSDictionary *)headers
                   body:(id)body
         completedBlock:(void (^)(NSInteger, NSDictionary * _Nullable, NSString * _Nullable))completedBlock{
    
    
    
    // 2、  创建请求对象
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setHTTPMethod:method.uppercaseString];
    
    //headers里出现CFNumber类型，出现crash，放弃使用下方法
    //[urlRequest setAllHTTPHeaderFields:headers];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:[FWLangageHelper currentLangage] forHTTPHeaderField:@"Accept-Language"];
    [urlRequest setValue:@"ios" forHTTPHeaderField:@"Accept-Side"];
    [urlRequest setValue:@"app" forHTTPHeaderField:@"Accept-SystemSide"];
    

    if ([body isKindOfClass:[NSString class]]) {
        urlRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([body isKindOfClass:[NSData class]]) {
        urlRequest.HTTPBody = body;
    } else if ([NSJSONSerialization isValidJSONObject:body]) {
        NSError *err = nil;
        urlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:&err];
    }

    // 4.1、  创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.2、 创建数据请求任务
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });

        NSHTTPURLResponse *httpResponse = nil;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            httpResponse = (id)response;
        }
        NSDictionary *allHeaderFields = httpResponse.allHeaderFields;
        NSString *responseString = nil;
        if (data.length > 0) {
            responseString = [self responseStringWithData:data charset:allHeaderFields[@"Content-Type"]];
        }
        if (completedBlock) {
            completedBlock(httpResponse.statusCode, allHeaderFields, responseString);
        }
    }];
    [task resume];
    
}
- (NSString *)responseStringWithData:(NSData *)data charset:(NSString *)charset
{
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    /// 对一些国内常见编码进行支持
    charset = charset.lowercaseString;
    if ([charset containsString:@"gb2312"]) {
        stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
    return responseString;
}

/**
 *  AFNW发送网络请求post
 */
- (void)postAFNWRequest:(FWBaseReq*)request
       withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
                failure:(void (^)(FWBaseReq *req, NSError *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@",request.url];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    [manager.requestSerializer setValue:[FWLangageHelper currentLangage] forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Accept-Side"];
    [manager.requestSerializer setValue:@"app" forHTTPHeaderField:@"Accept-SystemSide"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    [manager POST:urlString parameters:[request getRequestParametersDictionary] headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        FWBaseResp *response = [[NSClassFromString([self replaceClassName:request]) alloc] initWithJSONDictionary:json];

        NSLog(@"\nRequestURL : %@\nResponseCode : %lu\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,(unsigned long)response.respType,response.errorMessage,json);

        if (response.respType == NetWorkRespTypeSucess) {
            //成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(request,response);
                }
            });
        }else{

            NSError *error;
            if (response.errorMessage != nil) {

                error = [NSError errorWithDomain:response.errorMessage code:response.respType userInfo:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败回调
                if (failure) {
                    failure(request,error);
                }
            });
        }
          
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        
        if (error.domain.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败回调
                if (failure) {
                    failure(request,error);
                }
            });
        }else{
            if ([LLJNetWork.networkState isEqualToString:@"-1"]) {
                //无网络
                NSError *error = [NSError errorWithDomain:Language(@"Key_netUnavailable_alert") code:-1 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败回调
                    if (failure) {
                        failure(request,error);
                    }
                });
            }else{
                NSError *error = [NSError errorWithDomain:@"未知原因" code:-1 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败回调
                    if (failure) {
                        failure(request,error);
                    }
                });
            }
        }
    }];
}

/**
 *  AFNW post请求 传入tableview
 */
- (void)postAFNWRequest:(FWBaseReq *)request
          tableView:(UITableView *)tableView
         noDataType:(void (^)(FWNoDataType))noDataType
       withSucessed:(void (^)(FWBaseReq * _Nonnull, FWBaseResp * _Nonnull))success
                failure:(void (^)(FWBaseReq * _Nonnull, NSError * _Nonnull))failure {
    
    [MBProgressHUD showHUDAddedTo:kRootView animated:YES];
    __block FWNoDataType type;
    [self postAFNWRequest:request withSucessed:^(FWBaseReq * _Nonnull req, FWBaseResp * _Nonnull resp) {
        
        [MBProgressHUD hideHUDForView:kRootView animated:YES];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        if (success) {
            success(req,resp);
        }
        type = FWNoDataTypeNoData;
        
    } failure:^(FWBaseReq * _Nonnull req, NSError * _Nonnull error) {
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:kRootView animated:YES];
        if (error.domain.length) {
            [MBProgressHUD showMessag:error.domain toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
        }
        if ([LLJNetWork.networkState isEqualToString:@"-1"]){
            type = FWNoDataTypeNoNetWork;
        }else{
            type = FWNoDataTypeLoadFail;
        }
        //失败回调
        if (failure) {
            failure(req,error);
        }
    }];
    
    if (noDataType) {
        noDataType(type);
    }
}

/**
 *  发送网络请求get 传入tabview设置无数据图
 */
- (void)postRequest:(FWBaseReq *)request tableView:(UITableView *)tableView noDataType:(void (^)(FWNoDataType))noDataType withSucessed:(void (^)(FWBaseReq * _Nonnull, FWBaseResp * _Nonnull))success failure:(void (^)(FWBaseReq * _Nonnull, NSError * _Nonnull))failure
{
    [MBProgressHUD showHUDAddedTo:kRootView animated:YES];
    __block FWNoDataType type;
    [self postRequest:request withSucessed:^(FWBaseReq * _Nonnull req, FWBaseResp * _Nonnull resp) {
        
        [MBProgressHUD hideHUDForView:kRootView animated:YES];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        if (success) {
            success(req,resp);
        }
        type = FWNoDataTypeNoData;
        
    } failure:^(FWBaseReq * _Nonnull req, NSError * _Nonnull error) {
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:kRootView animated:YES];
        if (error.domain.length) {
            [MBProgressHUD showMessag:error.domain toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
        }
        if ([LLJNetWork.networkState isEqualToString:@"-1"]){
            type = FWNoDataTypeNoNetWork;
        }else{
            type = FWNoDataTypeLoadFail;
        }
        //失败回调
        if (failure) {
            failure(req,error);
        }
    }];
    
    if (noDataType) {
        noDataType(type);
    }
}

/**
 *  发送网络请求post
 */
- (void)postRequest:(FWBaseReq *)request
       withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
            failure:(void (^)(FWBaseReq *req, NSError *error))failure
{
    
    // 2、  创建请求对象
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:request.url];
    [urlRequest setHTTPMethod:@"POST"];
    urlRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    NSData *bodyData = [[LLJHelper dictionaryToJson:[request getRequestParametersDictionary]] dataUsingEncoding:NSUTF8StringEncoding];

    [urlRequest setHTTPBody:bodyData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:[FWLangageHelper currentLangage] forHTTPHeaderField:@"Accept-Language"];
    [urlRequest setValue:@"ios" forHTTPHeaderField:@"Accept-Side"];
    [urlRequest setValue:@"app" forHTTPHeaderField:@"Accept-SystemSide"];

    NSLog(@"\nRequest url : %@\nRequest body : %@",[request.url absoluteString],request.getRequestParametersDictionary);
    NSLog(@"allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);

    // 4.1、  创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 4.2、 创建数据请求任务
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });

        if (error) {
            //失败回调
            if ([self.networkState isEqualToString:@"-1"]) {
                error = [NSError errorWithDomain:Language(@"Key_netUnavailable_alert") code:-1 userInfo:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(request,error);
                }
            });
        }else{
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            FWBaseResp *response = [[NSClassFromString([self replaceClassName:request]) alloc] initWithJSONDictionary:json];
            if (response.respType == NetWorkRespTypeSucess) {
                //成功回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        success(request,response);
                    }
                });

            }else{
                NSError *error;
                if (response.errorMessage != nil) {
                    error = [NSError errorWithDomain:response.errorMessage code:response.netWorkCode userInfo:nil];
                }else{
                   error = [NSError errorWithDomain:Language(@"Key_fail_alert") code:-1 userInfo:nil];
                }
                //失败回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure(request,error);
                    }
                });
            }
            NSLog(@"\nRequestURL : %@\nResponseCode : %lu\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,(unsigned long)response.respType,response.errorMessage,json);
        }
    }];
    [task resume];
}


/**
 *  发送网络请求get 传入tableview设置无数据图
 */
- (void)getRequest:(FWBaseReq *)request tableView:(UITableView *)tableView noDataType:(void (^)(FWNoDataType))noDataType withSucessed:(void (^)(FWBaseReq * _Nonnull, FWBaseResp * _Nonnull))success failure:(void (^)(FWBaseReq * _Nonnull, NSError * _Nonnull))failure
{
    [MBProgressHUD showHUDAddedTo:tableView animated:YES];
    __block FWNoDataType type;
    [self getRequest:request withSucessed:^(FWBaseReq * _Nonnull req, FWBaseResp * _Nonnull resp) {
        
        [MBProgressHUD hideHUDForView:tableView animated:YES];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        if (success) {
            success(req,resp);
        }
        type = FWNoDataTypeNoData;
        
    } failure:^(FWBaseReq * _Nonnull req, NSError * _Nonnull error) {
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:tableView animated:YES];
        [MBProgressHUD showMessag:error.domain toView:tableView hudModel:MBProgressHUDModeText hide:YES];
        if ([LLJNetWork.networkState isEqualToString:@"-1"]){
            type = FWNoDataTypeNoNetWork;
        }else{
            type = FWNoDataTypeLoadFail;
        }
        //失败回调
        if (failure) {
            failure(req,error);
        }
    }];
    
    if (noDataType) {
        noDataType(type);
    }
}

/**
 *  发送网络请求get
 */
- (void)getRequest:(FWBaseReq *)request
       withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
            failure:(void (^)(FWBaseReq *req, NSError *error))failure
{
    
    NSLog(@"\nRequest url : %@\nRequest body : %@",[request.url absoluteString],request.getRequestParametersDictionary);
    
    NSString *urlString = [NSString stringWithFormat:@"%@",request.url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    [manager.requestSerializer setValue:[FWLangageHelper currentLangage] forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Accept-Side"];
    [manager.requestSerializer setValue:@"app" forHTTPHeaderField:@"Accept-SystemSide"];


    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    [manager GET:urlString parameters:[request getRequestParametersDictionary] headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableLeaves error:nil];
        FWBaseResp *response = [[NSClassFromString([self replaceClassName:request]) alloc] initWithJSONDictionary:json];

        NSLog(@"\nRequestURL : %@\nResponseCode : %lu\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,(unsigned long)response.respType,response.errorMessage,json);

        if (response.respType == NetWorkRespTypeSucess) {
            //成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(request,response);
                }
            });
        }else{

            NSError *error;
            if (response.errorMessage != nil) {

                error = [NSError errorWithDomain:response.errorMessage code:response.respType userInfo:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败回调
                if (failure) {
                    failure(request,error);
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        
        if (error.domain.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败回调
                if (failure) {
                    failure(request,error);
                }
            });
        }else{
            if ([LLJNetWork.networkState isEqualToString:@"-1"]) {
                //无网络
                NSError *error = [NSError errorWithDomain:Language(@"Key_netUnavailable_alert") code:-1 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败回调
                    if (failure) {
                        failure(request,error);
                    }
                });
            }else{
                NSError *error = [NSError errorWithDomain:@"未知原因" code:-1 userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败回调
                    if (failure) {
                        failure(request,error);
                    }
                });
            }
        }
    }];
}

/**
 *  发送网络请求put
 */
- (void)putRequest:(FWBaseReq *)request
       withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
            failure:(void (^)(FWBaseReq *req, NSError *error))failure
{
    
    NSLog(@"\nRequest url : %@\nRequest body : %@",[request.url absoluteString],request.getRequestParametersDictionary);
    
    NSString *urlString = [NSString stringWithFormat:@"%@",request.url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [manager.requestSerializer setValue:[FWLangageHelper currentLangage] forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Accept-Side"];
    [manager.requestSerializer setValue:@"app" forHTTPHeaderField:@"Accept-SystemSide"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    [manager PUT:urlString parameters:[request getRequestParametersDictionary] headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableLeaves error:nil];
        FWBaseResp *response = [[NSClassFromString([self replaceClassName:request]) alloc] initWithJSONDictionary:json];

        NSLog(@"\nRequestURL : %@\nResponseCode : %lu\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,(unsigned long)response.respType,response.errorMessage,json);

        if (response.respType == NetWorkRespTypeSucess) {
            //成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(request,response);
                }
            });
        }else{

            NSError *error;
            if (response.errorMessage != nil) {

                error = [NSError errorWithDomain:response.errorMessage code:response.respType userInfo:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败回调
                if (failure) {
                    failure(request,error);
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        if ([LLJNetWork.networkState isEqualToString:@"-1"]) {
            NSError *error = [NSError errorWithDomain:Language(@"Key_netUnavailable_alert") code:-1 userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                //失败回调
                if (failure) {
                    failure(request,error);
                }
            });
        }else{
            NSError *error = [NSError errorWithDomain:Language(@"Key_netUnavailable_alert") code:-1 userInfo:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                //失败回调
                if (failure) {
                    failure(request,error);
                }
            });
        }
    }];
}
#pragma mark - 替换类名 -
- (NSString *)replaceClassName:(id)reqClass
{
    NSString *reqStr = NSStringFromClass([reqClass class]);
    NSString *string1 = reqStr;
    NSString *string2 = @"Req";
    NSRange range = [string1 rangeOfString:string2];
    NSString *respStr = nil;
    if (range.location != NSNotFound) {
        NSString *str = [string1 substringToIndex:range.location];
        respStr = [NSString stringWithFormat:@"%@Resp",str];
    }
    return respStr;
}



#pragma mark - 下载相关api -
- (NSURLSessionTask *)downLoadAFNWWithUrlString:(NSString *)urlString
                                   progress:(void (^)(NSProgress * _Nonnull progress))downLoadProgress
                                destination:(NSString * (^)(NSURL * sourcePath, NSURLResponse * _Nonnull response))destination
                          completionHandler:(void (^)(NSURLResponse * _Nonnull response,NSURL * _Nullable        filePath,NSError * _Nullable error))completionHandler
                               autoDownLoad:(BOOL)autoDownLoad
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    /* 开始请求下载 */
    NSURLSessionTask *downloadTask = [manager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
        !downLoadProgress ?: downLoadProgress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:!destination?@"":destination(targetPath,response)];
                
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
        !completionHandler?:completionHandler(response,filePath,error);
    }];
    if (autoDownLoad) {
        [downloadTask resume];
    }
    return downloadTask;
}

@end
