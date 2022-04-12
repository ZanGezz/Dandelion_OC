//
//  FWBaseResp.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/21.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetWorkRespType) {
    NetWorkRespTypeSucess,
    NetWorkRespTypeFail
};

NS_ASSUME_NONNULL_BEGIN

@interface FWBaseResp : NSObject

@property (nonatomic, copy) NSString * errorMessage;
@property (nonatomic) NSInteger netWorkCode;
@property (nonatomic) NetWorkRespType respType;

- (id)initWithJSONDictionary:(NSDictionary*)jsonDic;

@end

NS_ASSUME_NONNULL_END
