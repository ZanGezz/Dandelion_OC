//
//  FWCountDownHelper.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/21.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWCountDownHelper.h"

@interface FWCountDownHelper ()

@end

@implementation FWCountDownHelper

#pragma mark -- 获取短信验证码 -
+ (void)getTelCodeWithTime:(int)time timer:(void(^)(dispatch_source_t t))timer timeUpdate:(void(^)(NSString *timeString))timeUpdate timeOut:(void(^)(void))timeOut{
    
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                !timeOut ?: timeOut();
            });
        }else{
            NSString *timeString = [NSString stringWithFormat:@"%ds",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                !timeUpdate ?: timeUpdate(timeString);
            });
            timeout--;
        }
    });
    !timer ?: timer(_timer);
    dispatch_resume(_timer);
}



//倒计时
+ (void)countDownWithTime:(NSTimeInterval)time type:(FWCountDownType)type{
    
    [self removeTimer:type];
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            _timer = nil;
            
        }
        timeout --;
    });
    dispatch_resume(_timer);
}

+ (void)removeTimer:(FWCountDownType)type{
    
    if (type == FWCountDownTypeLongToken) {
        for (int i = 0; i < 5; i ++) {
            dispatch_source_t timer = @[@""][i];
            dispatch_source_cancel(timer);
            timer = nil;
        }
        //[LLJSg.longToken removeAllObjects];
    }else{
        for (int i = 0; i < 5; i ++) {
            dispatch_source_t timer = @[@""][i];
            dispatch_source_cancel(timer);
            timer = nil;
        }
        //[LLJSg.shortToken removeAllObjects];
    }
}
@end
