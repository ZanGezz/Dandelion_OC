//
//  FWUserDefultHelper.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/6/5.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWUserDefultHelper : NSObject

//手势密码是否启用
+ (void)gesCanBeUsed:(BOOL)gesCanBeUsed;
//获取手势密码是否启用
+ (BOOL)gesCanBeUsed;

//是否设置过手势密码
+ (void)setPassWord:(BOOL)setges;
//是否设置过手势密码
+ (BOOL)getPassword;

//指纹面容是否启用
+ (void)authIDCanBeUsed:(BOOL)authIDCanBeUsed;
//获取指纹面容是否启用
+ (BOOL)authIDCanBeUsed;

//是否获取了authID权限
+ (void)authIDCanEvaluate:(BOOL)canEvaluate;
//是否获取了authID权限
+ (BOOL)authIDCanEvaluate;

@end
