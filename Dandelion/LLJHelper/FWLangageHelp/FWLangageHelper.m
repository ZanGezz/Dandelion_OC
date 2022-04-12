//
//  FWLangageHelper.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/20.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWLangageHelper.h"

@implementation FWLangageHelper

static NSBundle *bundle = nil;

+ ( NSBundle * )bundle {
   return bundle;
}

+ (NSString *)currentLangage{
    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return [appLanguages objectAtIndex:0];
}

+ (void)setNewLangage:(NSString *)langage{
    
    if (langage.length == 0) {
        langage = @"zh-Hans";
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@[langage] forKey:@"AppleLanguages"];
    [userDefaults synchronize];
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:langage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+ (NSString *)getLanguage:(NSString *)key{
    
    return [FWLangageHelper.bundle localizedStringForKey:key value:nil table:@"Language"];
}

@end
