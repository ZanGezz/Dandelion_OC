//
//  FWGpwView.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/22.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWGpwModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GesturePasswordButtonState) {
    GesturePasswordButtonStateNormal = 0,
    GesturePasswordButtonStateSelected,
    GesturePasswordButtonStateIncorrect,
};

typedef NS_ENUM(NSInteger, GesturePasswordStatus) {
    GesturePasswordStatusSet           = 0,  //设置手势密码
    GesturePasswordStatusReset         = 1,  //重置手势密码
    GesturePasswordStatusLogin         = 2,  //手势密码登录
};

@interface FWGpwView : UIView

@property (nonatomic, strong)NSMutableArray *selectorAry;      //存储已经选择的按钮
@property (nonatomic, strong)UIColor *strokeColor;             //圆弧的填充颜色
@property (nonatomic, strong)UIColor *fillColor;               //除中心圆点外 其他部分的填充色
@property (nonatomic, strong)UIColor *centerPointColor;        //中心圆点的颜色
@property (nonatomic, strong)UIColor *lineColor;               //线条填充颜色

@property (nonatomic, copy) void(^verificationPassword)(void); //验证旧密码正确
@property (nonatomic, copy) void(^verificationError)(void);    //验证旧密码错误
@property (nonatomic, copy) void(^onPasswordSet)(void);        //第一次输入密码
@property (nonatomic, copy) void(^onGetCorrectPswd)(NSString *password);     //第二次输入密码且和第一次一样
@property (nonatomic, copy) void(^onGetIncorrectPswd)(NSString *errorCount);   //第二次输入密码且和第一次不一样
@property (nonatomic, copy) void(^errorInput)(void);           //手势密码小于四位数


- (void)reset;
- (void)setNeedsDisplayWithArray:(NSArray *)buttonArray;

+(instancetype)model:(FWGpwModel *)model status:(GesturePasswordStatus)status frame:(CGRect)frame onGetCorrectPswd:(void (^)(NSString *password))GetCorrectPswd onGetIncorrectPswd:(void (^)(NSString *errorCount))GetIncorrectPswd errorInput:(void (^)(void))errorInput;

+(instancetype)model:(FWGpwModel *)model status:(GesturePasswordStatus)status frame:(CGRect)frame  onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(NSString *password))GetCorrectPswd onGetIncorrectPswd:(void (^)(NSString *errorCount))GetIncorrectPswd errorInput:(void (^)(void))errorInput;

+(instancetype)model:(FWGpwModel *)model status:(GesturePasswordStatus)status frame:(CGRect)frame verificationPassword:(void (^)(void))verificationPassword verificationError:(void (^)(void))verificationError onPasswordSet:(void (^)(void))onPasswordSet onGetCorrectPswd:(void (^)(NSString *password))GetCorrectPswd onGetIncorrectPswd:(void (^)(NSString *errorCount))GetIncorrectPswd errorInput:(void (^)(void))errorInput;

@end

NS_ASSUME_NONNULL_END
