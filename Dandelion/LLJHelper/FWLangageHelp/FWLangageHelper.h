//
//  FWLangageHelper.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/20.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define Language(key) [FWLangageHelper getLanguage:key]

@interface FWLangageHelper : NSObject

+ (NSBundle *)bundle;

+ (NSString *)currentLangage;

+ (void)setNewLangage:(NSString *)langage;

+ (NSString *)getLanguage:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
