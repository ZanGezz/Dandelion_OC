//
//  FWAuthIDHelper.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/7/22.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  TouchID/FaceID 状态
 */
typedef NS_ENUM(NSUInteger, LLJAuthIDState){
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    LLJAuthIDStateNotSupport = 0,
    /**
     *  TouchID/FaceID 验证成功
     */
    LLJAuthIDStateSuccess = 1,
    
    /**
     *  TouchID/FaceID 验证失败
     */
    LLJAuthIDStateFail = 2,
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    LLJAuthIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID/FaceID,选择手动输入密码
     */
    LLJAuthIDStateInputPassword = 4,
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    LLJAuthIDStateSystemCancel = 5,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置密码
     */
    LLJAuthIDStatePasswordNotSet = 6,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置TouchID/FaceID
     */
    LLJAuthIDStateTouchIDNotSet = 7,
    /**
     *  TouchID/FaceID 无效
     */
    LLJAuthIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
     */
    LLJAuthIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    LLJAuthIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    LLJAuthIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    LLJAuthIDStateVersionNotSupport = 12,
    /**
     *  TouchID/FaceID 输入密码验证成功
     */
    LLJAuthIDStatePassWordSuccess = 13
};

@interface FWAuthIDHelper : NSObject

/**
 *  是否有权限使用指纹面容ID
 */
+ (BOOL)authIDCanEvaluatePolicy:(BOOL)evaluate;

/**
 * 指纹人脸识别部分
 */
+ (void)llj_showAuthIDWithDescribe:(NSString *)describe policy:(LAPolicy)policy block:(void(^)(LLJAuthIDState state, NSError *error))block;

+ (void)context:(LAContext *)context policy:(LAPolicy)policy block:(void(^)(LLJAuthIDState state, NSError *error))block;

@end

