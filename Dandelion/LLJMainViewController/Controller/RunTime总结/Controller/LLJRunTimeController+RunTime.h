//
//  LLJRunTimeController+RunTime.h
//  Dandelion
//
//  Created by 刘帅 on 2020/2/24.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJRunTimeController.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJRunTimeController (RunTime)

@property (nonatomic, strong) NSString *age;

@end

NS_ASSUME_NONNULL_END
