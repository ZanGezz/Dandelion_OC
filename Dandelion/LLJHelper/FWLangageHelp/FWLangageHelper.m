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

+ ( NSBundle * )bundle{
   return bundle;
}
+ (NSString *)currentLangage{
    
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:@"appLanguage"];
    if (!IS_VALID_STRING(language)) {
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        if ([languageName containsString:@"en"]) {
            language = @"en";
        }else{
            language = @"zh-Hans";
        }
        [self setNewLangage:language];
    }
    return language;
}

+ (NSString *)systemLangage{
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    return [appLanguages objectAtIndex:0];
}

+ (void)setNewLangage:(NSString *)langage{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:@"appLanguage"];
    if (![currLanguage isEqualToString:langage]) {
        [userDefaults setValue:langage forKey:@"appLanguage"];
        [userDefaults synchronize];
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:langage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+ (NSString *)getLanguage:(NSString *)key{
    
    return [FWLangageHelper.bundle localizedStringForKey:key value:nil table:@"Language"];
}

+ (NSString *)getParamLangage{
    NSString *language = [self currentLangage];
    if ([language isEqualToString:@"en"]) {
        language = @"en_US";
    }else{
        language = @"zh_CN";
    }
    return language;
}

+ (void)setParamLangage:(NSString *)langage{
    if ([langage isEqualToString:@"en_US"]) {
        [self setNewLangage:@"en"];
    }else{
        [self setNewLangage:@"zh-Hans"];
    }
}

@end
