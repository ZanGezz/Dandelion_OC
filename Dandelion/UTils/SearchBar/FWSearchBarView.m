//
//  FWSearchBarView.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/11.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWSearchBarView.h"

@interface FWSearchBarView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UILabel *pHolder;

@property (nonatomic) CGFloat searchIconFrameX;

@end

@implementation FWSearchBarView

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = LLJColor(238, 238, 238, 1);
        [self addSubview:self.bgView];
        [self addSubview:self.rightButton];
        [self.bgView addSubview:self.textField];
        [self.textField addSubview:self.searchImage];
        [self.textField addSubview:self.pHolder];
                
        [self layoutSubview];
    }
    return self;
}
#pragma mark - 按钮事件 -
- (void)buttonClick:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"取消"] || [sender.titleLabel.text isEqualToString:@"Cancel"]) {
        self.textField.text = nil;
        [self placeHolderHidden:self.textField];
        [self.textField resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            [self iconPlaceCenter];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.textField.tintColor = [UIColor clearColor];
        }];
    }else{
        [self.textField endEditing:YES];
    }
    //发送代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClick)]) {
        [self.delegate cancelButtonClick];
    }
}

#pragma mark - 代理 -
- (void)textFieldDidBeginEditing:(UITextField *)textField{
        
    //设置动画
    if (textField.text.length == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [self iconPlaceLeft];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            textField.tintColor = LLJCommenColor;
        }];
    }
    
    //发送代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarBeginEditing:)]) {
        [self.delegate searchBarBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    //设置动画
    if (textField.text.length == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            [self iconPlaceCenter];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            textField.tintColor = [UIColor clearColor];
        }];
    }
    
    //发送代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarEndEditing:)]) {
        [self.delegate searchBarEndEditing:textField];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        [textField resignFirstResponder];
    }else{
        [textField endEditing:YES];
    }
    
    //发送代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneButtonClcik:)]) {
        [self.delegate doneButtonClcik:textField];
    }
    return YES;
}
- (void)valueChange:(UITextField *)textField{
    
    //placeHolder设置
    [self placeHolderHidden:textField];
    
    //发送代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarValueChange:)]) {
        [self.delegate searchBarValueChange:textField];
    }
}
- (void)placeHolderHidden:(UITextField *)textField{
    //placeHolder设置
    if (textField.text.length == 0) {
        self.pHolder.hidden = NO;
    }else{
        self.pHolder.hidden = YES;
    }
}
#pragma mark - set方法 -
- (void)setPlaceHolder:(NSString *)placeHolder{
    
    [self layoutIfNeeded];
    self.pHolder.text = placeHolder;
        
    CGSize size = [LLJHelper sizeWithString:placeHolder withFont:_pHolder.font];
    self.searchIconFrameX = (CGRectGetWidth(self.textField.frame) - self.searchImage.frame.size.width - size.width - 2)/2;

    [self layoutSubview];
}

- (BOOL)becomeFirstResponder{
    
    [self.textField becomeFirstResponder];
    return YES;
}
#pragma mark - 布局 -
- (void)layoutSubview{
    
    [super layoutSubviews];
    
    [self iconPlaceCenter];
}
- (void)iconPlaceCenter{
    
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LLJD_X(16));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.width.mas_equalTo(0.01);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LLJD_X(15));
        make.top.mas_equalTo(self.mas_top).offset(LLJD_Y(10));
        make.right.mas_equalTo(self.rightButton.mas_left).offset(-LLJD_X(10));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-LLJD_Y(10));
    }];
            
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(1);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-1);
        make.height.mas_equalTo(LLJD_Y(16));
    }];
    
    [self.searchImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.left.mas_equalTo(self.textField.mas_left).offset(self.searchIconFrameX);
        make.width.mas_equalTo(LLJD_X(15));
        make.height.mas_equalTo(LLJD_Y(15));
    }];
    
    [self.pHolder mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchImage.mas_centerY);
        make.left.mas_equalTo(self.searchImage.mas_right).offset(LLJD_X(5));
    }];
}
- (void)iconPlaceLeft{
    
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LLJD_X(16));
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(LLJD_X(-14));
    }];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LLJD_X(15));
        make.top.mas_equalTo(self.mas_top).offset(LLJD_Y(10));
        make.right.mas_equalTo(self.rightButton.mas_left).offset(-LLJD_X(10));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-LLJD_Y(10));
    }];
    
    [self.searchImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.left.mas_equalTo(self.bgView.mas_left).offset(LLJD_X(6));
        make.width.mas_equalTo(LLJD_X(15));
        make.height.mas_equalTo(LLJD_Y(15));
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchImage.mas_right).offset(3);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-1);
        make.height.mas_equalTo(LLJD_Y(16));
    }];
    
    [self.pHolder mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.left.mas_equalTo(self.textField.mas_left);
    }];
}

#pragma mark - 懒加载 -
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = LLJColor(66, 68, 70, 1);
        _textField.font = LLJFont(15);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.tintColor = [UIColor clearColor];
        [_textField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:LLJColor(114, 71, 167, 1) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = LLJFont(15);
        [_rightButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UIImageView *)searchImage{
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    }
    return _searchImage;
}
- (UILabel *)pHolder{
    if (!_pHolder) {
        _pHolder = [[UILabel alloc]init];
        _pHolder.textColor = LLJColor(204, 204, 204, 1);
        _pHolder.font = LLJFontName(@"PingFangSC-Medium", 14);
        _pHolder.numberOfLines = 2;
        _pHolder.textAlignment = NSTextAlignmentLeft;
    }
    return _pHolder;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 3.0f;
    }
    return _bgView;
}
@end
