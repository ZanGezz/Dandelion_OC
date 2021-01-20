//
//  FWBaseResp.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/21.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWBaseResp.h"

@implementation FWBaseResp

- (id)initWithJSONDictionary:(NSDictionary*)jsonDic
{
    if (self = [super init])
    {
        NSString *code = [jsonDic safeObjectForKey:@"code"];
        self.errorMessage = [jsonDic safeObjectForKey:@"msg"];
        self.netWorkCode = code.integerValue;
        //身份类型已改变跳转登录页2017  3010token无效  3009token为空
        if (code.integerValue == 2017 || code.integerValue == 3010 || code.intValue == 3009) {
            //去登录
            self.errorMessage = @"";
        }
        if (code.integerValue == 1000) {
            self.respType = NetWorkRespTypeSucess;
        }else{
            self.respType = NetWorkRespTypeFail;
        }
    }
    return self;
}
@end
