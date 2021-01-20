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

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputText = @"";
    }
    return self;
}
- (void)resetText:(LLJTextField *)textField{
    
    if (self.secureTextEntry) {
        
        UITextPosition* beginning = self.beginningOfDocument;
        UITextRange* selectedRange = self.selectedTextRange;
        UITextPosition* selectionStart = selectedRange.start;
        const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
        
        NSMutableString *ms = [[NSMutableString alloc] initWithFormat:@"%@",textField.text];
        NSMutableString *input = [[NSMutableString alloc] initWithFormat:@"%@",self.inputText];

        if (textField.text.length > self.inputText.length) {
            NSInteger length = textField.text.length - self.inputText.length;
            NSString *addChar = [textField.text substringWithRange:NSMakeRange(location - 1, length)];
            [ms replaceCharactersInRange:NSMakeRange(location - 1, length) withString:@"●"];
            [input insertString:addChar atIndex:location - length];
        }else if(textField.text.length < self.inputText.length){
            NSInteger length = self.inputText.length - textField.text.length;
            [input deleteCharactersInRange:NSMakeRange(location, length)];
        }
        self.inputText = input;
        textField.text = ms;
    }else{
        self.inputText = textField.text;
    }
}

@end
