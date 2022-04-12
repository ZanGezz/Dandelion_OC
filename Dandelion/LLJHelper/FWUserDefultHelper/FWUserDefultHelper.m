//
//  FWUserDefultHelper.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/6/5.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWUserDefultHelper.h"

@implementation FWUserDefultHelper


//手势密码是否启用
+ (void)gesCanBeUsed:(BOOL)gesCanBeUsed{
    
    NSString *key = [NSString stringWithFormat:@"gesCanBeUsed-%@",@"liushuai"];
    [[NSUserDefaults standardUserDefaults] setBool:gesCanBeUsed forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取手势密码是否启用
+ (BOOL)gesCanBeUsed{
    NSString *key = [NSString stringWithFormat:@"gesCanBeUsed-%@",@"liushuai"];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

//是否设置过手势密码
+ (void)setPassWord:(BOOL)setges
{
    NSString *key = [NSString stringWithFormat:@"%@-%@",@"GESTUREPASSWORD",@"liushuai"];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setBool:setges forKey:key];
    [userdefault synchronize];
}
//是否设置过手势密码
+ (BOOL)getPassword
{
    NSString *key = [NSString stringWithFormat:@"%@-%@",@"GESTUREPASSWORD",@"liushuai"];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

//指纹面容是否启用
+ (void)authIDCanBeUsed:(BOOL)authIDCanBeUsed{
    
    NSString *key = [NSString stringWithFormat:@"authIDCanBeUsed-%@",@"liushuai"];
    [[NSUserDefaults standardUserDefaults] setBool:authIDCanBeUsed forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取指纹面容是否启用
+ (BOOL)authIDCanBeUsed{
    NSString *key = [NSString stringWithFormat:@"authIDCanBeUsed-%@",@"liushuai"];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

//是否支持横屏
+ (void)supportLandscape:(BOOL)support{
    [[NSUserDefaults standardUserDefaults] setBool:support forKey:@"supportLandscape"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//是否支持横屏
+ (BOOL)supportLandscape{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"supportLandscape"];
}


//是否获取了authID权限
+ (void)authIDCanEvaluate:(BOOL)canEvaluate{
    NSString *key = [NSString stringWithFormat:@"canEvaluate-%@",@"liushuai"];
    [[NSUserDefaults standardUserDefaults] setBool:canEvaluate forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//是否获取了authID权限
+ (BOOL)authIDCanEvaluate{
    NSString *key = [NSString stringWithFormat:@"canEvaluate-%@",@"liushuai"];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
