//
//  FWAuthIDHelper.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/7/22.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWAuthIDHelper.h"

@implementation FWAuthIDHelper

/**
 *  是否有权限使用指纹面容ID
 */
+ (BOOL)authIDCanEvaluatePolicy:(BOOL)evaluate{
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
    // LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面（本案例使用）
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        if (evaluate) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@" " reply:^(BOOL success, NSError * _Nullable error) {
            }];
        }
        return YES;
    }else{
        return NO;
    }
}

/**
 *  指纹识别相关api
 */
#pragma mark - * 指纹人脸识别* -
+ (void)llj_showAuthIDWithDescribe:(NSString *)describe policy:(LAPolicy)policy block:(void(^)(LLJAuthIDState state, NSError *error))block {
    
    describe = @" ";
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(LLJAuthIDStateVersionNotSupport, nil);
        });
        
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
    //LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面（本案例使用）
    if ([context canEvaluatePolicy:policy error:&error]) {
        
        [self context:context policy:policy block:block];
    }else{

        dispatch_async(dispatch_get_main_queue(), ^{
            block(LLJAuthIDStateNotSupport, error);
        });
    }
}
+ (void)context:(LAContext *)context policy:(LAPolicy)policy block:(void(^)(LLJAuthIDState state, NSError *error))block{
    
    [context evaluatePolicy:policy localizedReason:@" " reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(LLJAuthIDStateSuccess, error);
            });
        }else if(error){
            
            if (@available(iOS 11.0, *)) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateFail, error);
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateUserCancel, error);
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateInputPassword, error);
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateSystemCancel, error);
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStatePasswordNotSet, error);
                        });
                    }
                        break;
                    case LAErrorBiometryNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateTouchIDNotSet, error);
                        });
                    }
                        break;
                    case LAErrorBiometryNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateTouchIDNotAvailable, error);
                        });
                    }
                        break;
                    case LAErrorBiometryLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateTouchIDLockout, error);
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateAppCancel, error);
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateInvalidContext, error);
                        });
                    }
                        break;
                    default:
                        break;
                }
            } else {
                // iOS 11.0以下的版本只有 TouchID 认证
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateFail, error);
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateUserCancel, error);
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateInputPassword, error);
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateSystemCancel, error);
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStatePasswordNotSet, error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateTouchIDNotSet, error);
                        });
                    }
                        break;
                        //case :{
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateTouchIDNotAvailable, error);
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateTouchIDLockout, error);
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateAppCancel, error);
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block(LLJAuthIDStateInvalidContext, error);
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
            
        }
    }];
}

@end
