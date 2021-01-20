//
//  FWAlertView.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/13.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FWAlertType) {
    FWAlertTypeNomal,      //正常样式
    FWAlertTypeLogOut,     //注销样式
    FWAlertTypeRelog,      //重新登录样式
    FWAlertTypeCheckPw,    //验证密码
};

//typedef简化Block的声明 声明一类block
typedef void (^sureAction)(NSString *str);
typedef void (^cancelAction)(void);

@interface FWAlertView : UIView

+ (FWAlertView *)alertViewShowType:(FWAlertType)type sureButtonName:(NSString *)rightName title:(NSString *)title content:(NSString *)content sureAction:(sureAction)sureActionBlock cancelAction:(cancelAction)cancelActionBlock;


+ (FWAlertView *)alertViewShowType:(FWAlertType)type sureButtonName:(NSString *)rightName title:(NSString *)title content:(NSString *)content canBeRemoved:(BOOL)remove sureAction:(sureAction)sureActionBlock cancelAction:(cancelAction)cancelActionBlock;

@end

NS_ASSUME_NONNULL_END
