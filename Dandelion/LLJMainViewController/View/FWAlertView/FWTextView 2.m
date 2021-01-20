//
//  FWTextView.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/31.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWTextView.h"

@interface FWTextView ()<UITextViewDelegate>

@end

@implementation FWTextView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.delegate = self;
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = LLJLightGreyColor;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = LLJMediumFont;
        [self addSubview:_placeholderLabel];
        [self layoutSubview];
    }
    return self;
}

- (void)layoutSubview{
    
    [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top).offset(LLJD_Y(7));
        make.width.mas_equalTo(LLJD_X(260));
    }];
}

#pragma mark - UITextViewDelegate -
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(![textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
    {
        self.placeholderLabel.hidden = NO;
        
    }else{
        self.placeholderLabel.hidden = YES;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (_maxInputCount != 0) {
        if (textView.text.length <= _maxInputCount) {
            !self.viewTextLenth ?: self.viewTextLenth(textView.text);
        }else{
            [MBProgressHUD showMessag:[NSString stringWithFormat:@"输入字符不能超过%ld个",(long)_maxInputCount] toView:kRootView hudModel:MBProgressHUDModeText hide:YES];
            textView.text = [textView.text substringToIndex:_maxInputCount];
            [self endEditing:YES];
        }
    }else{
        !self.viewTextLenth ?: self.viewTextLenth(textView.text);
    }
}
@end
