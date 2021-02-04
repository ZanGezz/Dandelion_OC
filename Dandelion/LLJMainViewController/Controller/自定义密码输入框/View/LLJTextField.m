//
//  LLJTextField.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/13.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJTextField.h"

@interface LLJTextField ()


@end

@implementation LLJTextField

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputText = @"";
        self.type = LLJInputTextTypeCommen;
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)setType:(LLJInputTextType)type {
    
    _type = type;
    
    if (type == LLJInputTextTypeLessSecret) {
        self.secureTextEntry = YES;
    } else if (type == LLJInputTextTypeFullSecret) {
        self.secureTextEntry = NO;
        self.keyboardType = UIKeyboardTypeAlphabet;
    } else {
        self.secureTextEntry = NO;
    }
}
#pragma mark - 输入内容发生改变 -
- (void)valueChanged:(LLJTextField *)textField {
    
    switch (self.type) {
        case LLJInputTextTypeCommen:
        {
            self.inputText = textField.text;
        }
            break;
        case LLJInputTextTypeLessSecret:
        {
            self.inputText = textField.text;
        }
            break;
        case LLJInputTextTypeFullSecret:
        {
            [self retSetInputStringWhenfullSecret:textField];
        }
            break;
            
        default:
            break;
    }
}

- (void)retSetInputStringWhenfullSecret:(LLJTextField *)textField{
    
    NSString *textFieldText = textField.text;
    NSString *inputString = self.inputText;
    
    UITextPosition* beginning = self.beginningOfDocument;
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSMutableString *ms = [[NSMutableString alloc] initWithFormat:@"%@",textFieldText];
    NSMutableString *input = [[NSMutableString alloc] initWithFormat:@"%@",inputString];
    if (textFieldText.length > inputString.length) {
        NSInteger length = textFieldText.length - inputString.length;
        if (textFieldText.length >= location + length - 1) {
            NSString *addChar = [textFieldText substringWithRange:NSMakeRange(location - 1, length)];
            [ms replaceCharactersInRange:NSMakeRange(location - 1, length) withString:@"•"];//@"●"@"•"@"·"
            [input insertString:addChar atIndex:location - length];
        }
    }else if(textFieldText.length < inputString.length){
        NSInteger length = inputString.length - textFieldText.length;
        if (textFieldText.length >= location + length - 1) {
            [input deleteCharactersInRange:NSMakeRange(location, length)];
        }
    }
    self.inputText = input;
    
    //发送代理
    textField.text = self.inputText;
    if (self.llj_delegate && [self.llj_delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.llj_delegate valueChanged:textField];
    }
    textField.text = ms;
}

@end
