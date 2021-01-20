//
//  LLJSingleInstence.h
//  Dandelion
//
//  Created by 刘帅 on 2019/7/24.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

//NS_ASSUME_NONNULL_BEGIN

#define LLJSg [LLJSingleInstence shareInstance]

@interface LLJSingleInstence : NSObject

/**
 * 初始化单利
 */
+ (LLJSingleInstence *)shareInstance;

/**
 * 系统音量
 */
@property (nonatomic) CGFloat volumeValue;

@end

//NS_ASSUME_NONNULL_END
