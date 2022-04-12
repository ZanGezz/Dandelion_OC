//
//  FWCountDownHelper.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/21.
//  Copyright © 2020 SinoBridge. All rights reserved.
//  com.springscapital.csp

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FWCountDownType) {
    FWCountDownTypeShortToken,
    FWCountDownTypeLongToken
};

@interface FWCountDownHelper : NSObject

+ (void)getTelCodeWithTime:(int)time timer:(void(^)(dispatch_source_t t))timer timeUpdate:(void(^)(NSString *timeString))timeUpdate timeOut:(void(^)(void))timeOut;

+ (void)countDownWithTime:(NSTimeInterval)time type:(FWCountDownType)type;

+ (void)removeTimer:(FWCountDownType)type;

@end

NS_ASSUME_NONNULL_END
