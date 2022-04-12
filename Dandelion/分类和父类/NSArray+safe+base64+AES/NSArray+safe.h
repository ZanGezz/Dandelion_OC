//
//  NSArray+safe.h
//  bfclass
//
//  Created by 马腾 on 16/1/12.
//  Copyright © 2016年 fltrp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (safe)

- (id) safeObjectAtIndex:(NSInteger)index;

@end
