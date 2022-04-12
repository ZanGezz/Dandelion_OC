//
//  FWWebLoadHelper.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/20.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKUserContentController+IMYHookAjax.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWWebLoadHelper : NSURLProtocol

/// 开始监听
/// @param cacheType 缓存的类型
+ (void)startMonitorRequest;

//取消网络监听-在不需要用到webview的时候即使的取消监听
+ (void)cancelMonitorRequest;


//扩展1
+ (void)startMonitorRequest:(WKWebViewConfiguration *)configuration;

+ (void)cancelMonitorRequest:(WKWebViewConfiguration *)configuration;


@end

NS_ASSUME_NONNULL_END
