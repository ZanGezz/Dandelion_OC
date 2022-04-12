//
//  NSArray+safe.m
//  bfclass
//
//  Created by 马腾 on 16/1/12.
//  Copyright © 2016年 fltrp. All rights reserved.
//

#import "NSArray+safe.h"

@implementation NSArray (safe)

- (id) safeObjectAtIndex:(NSInteger) index
{
    if (self.count > index)
    {
        return [self objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

@end
