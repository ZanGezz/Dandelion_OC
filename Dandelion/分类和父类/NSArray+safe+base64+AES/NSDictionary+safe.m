//
//  NSDictionary+safe.m
//  bfclass
//
//  Created by 马腾 on 16/1/12.
//  Copyright © 2016年 fltrp. All rights reserved.
//

#import "NSDictionary+safe.h"

@implementation NSDictionary (safe)
- (id)safeObjectForKey:(NSString *) key
{
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNull class]]){
        return nil;
    }else if ([object isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",object];
    }else{
        return object;
    }
}

@end
