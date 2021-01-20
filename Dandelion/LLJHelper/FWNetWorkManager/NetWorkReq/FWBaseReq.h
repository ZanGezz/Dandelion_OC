//
//  FWBaseReq.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/21.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseReq : NSObject

@property (nonatomic, strong) NSURL *url;

- (NSMutableDictionary *)getRequestParametersDictionary;

@end

NS_ASSUME_NONNULL_END
