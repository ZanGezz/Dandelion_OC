//
//  NSURLSessionTask+Helper.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/19.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "NSURLSessionTask+Helper.h"

#define dataTaskTimeTag  @"dataTaskTimeTag"

@implementation NSURLSessionTask (Helper)

- (void)setTimeTag:(NSString *)timeTag {
    objc_setAssociatedObject(self, dataTaskTimeTag, timeTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)timeTag {
    return objc_getAssociatedObject(self, dataTaskTimeTag);
}

@end
