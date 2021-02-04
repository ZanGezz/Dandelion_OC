//
//  LLJTextField.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/13.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LLJTextFieldDelegate;

typedef NS_ENUM(NSUInteger, LLJInputTextType) {
    LLJInputTextTypeCommen,         //明文模式
    LLJInputTextTypeLessSecret,     //密码模式最后一位显示一秒明文
    LLJInputTextTypeFullSecret      //纯密码模式不显示明文
};

@interface LLJTextField : UITextField

@property (nonatomic) LLJInputTextType type;      //输入模式 默认明文
@property (nonatomic, weak) id<LLJTextFieldDelegate>llj_delegate;
@property (nonatomic, copy) NSString *inputText;

@end

@protocol LLJTextFieldDelegate <NSObject>

- (void)valueChanged:(LLJTextField *)textField;

@end

NS_ASSUME_NONNULL_END
