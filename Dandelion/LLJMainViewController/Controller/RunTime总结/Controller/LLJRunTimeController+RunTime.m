//
//  LLJRunTimeController+RunTime.m
//  Dandelion
//
//  Created by 刘帅 on 2020/2/24.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJRunTimeController+RunTime.h"

@implementation LLJRunTimeController (RunTime)

#pragma mark - 动态添加属性 -
//给分类动态添加属性    属性 修饰v符
- (void)setAge:(NSString *)age{
    objc_setAssociatedObject([self class], @"a", age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)age{
    
    return objc_getAssociatedObject([self class], @"a");
}

@end
