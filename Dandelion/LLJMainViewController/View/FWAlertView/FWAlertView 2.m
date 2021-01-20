//
//  FWAlertView.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/13.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWAlertView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FWTextView.h"

@interface FWAlertView ()

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *myScrollView; //自适应键盘
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) FWTextView *password;
@property (nonatomic, strong) UITextField *checkPassWord;

@property (nonatomic, strong) NSString *rightName;


@property (nonatomic) FWAlertType type;

@property (nonatomic) CGFloat bgViewHeight;
@property (nonatomic) CGFloat textViewHeight;
@property (nonatomic) CGFloat textViewTopOffSet;
@property (nonatomic) CGFloat rightWidth;

@property (nonatomic, copy) sureAction rightBlock;
@property (nonatomic, copy) cancelAction cancelBlock;
@property  BOOL canBeRemoved;


@end

@implementation FWAlertView

#pragma mark - 初始化 -
- (instancetype)initWithType:(FWAlertType)type title:(nonnull NSString *)title content:(nonnull NSString *)content{
    
    self = [super init];
    if (self) {
        
        self.frame = kRootView.bounds;
        self.backgroundColor = LLJColor(0, 0, 0, 0.5);
        
        _type = type;
        _bgViewHeight = LLJD_Y(145);
        
        if (_type == FWAlertTypeRelog) {
            _rightWidth = LLJD_X(285);
        }else{
            _rightWidth = LLJD_X(130);
        }
         
        [self addSubview:self.myScrollView];
        [self.myScrollView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.textBgView];
        [self.textBgView addSubview:self.password];
        [self.textBgView addSubview:self.checkPassWord];
        [self.textBgView addSubview:self.infoLabel];
        [self.bgView addSubview:self.leftButton];
        [self.bgView addSubview:self.rightButton];

        switch (_type) {
            case FWAlertTypeNomal:
                {
                    _textViewHeight = 0.01;
                    _textViewTopOffSet = LLJD_Y(0.01);
                }
                break;
            case FWAlertTypeLogOut:
                {
                    _password.placeholderLabel.text = Language(@"Key_logOffInfo_placeHolder");
                    _textViewHeight = LLJD_Y(100);
                    _textViewTopOffSet = LLJD_Y(20);
                }
                break;
            case FWAlertTypeRelog:
                {
                    _textViewHeight = 0.01;
                    _textViewTopOffSet = LLJD_Y(0.01);
                }
                break;
            case FWAlertTypeCheckPw:
                {
                    _checkPassWord.placeholder = Language(@"Key_pwInput_title");
                    _textViewHeight = LLJD_Y(40);
                    _textViewTopOffSet = LLJD_Y(0.01);
                }
                break;
                
            default:
                break;
        }
        
        self.titleLabel.text = title;
        self.infoLabel.text = content;
        //布局
        [self layoutSubview];
        //设置数据
        [self setButtonTitle];
    }
    return self;
}

#pragma mark - 类方法初始化 -
+ (FWAlertView *)alertViewShowType:(FWAlertType)type sureButtonName:(nonnull NSString *)rightName title:(nonnull NSString *)title content:(nonnull NSString *)content sureAction:(nonnull sureAction)sureActionBlock cancelAction:(nonnull cancelAction)cancelActionBlock{
    FWAlertView *alert = [[FWAlertView alloc]initWithType:type title:title content:content];
    alert.rightBlock = sureActionBlock;
    alert.cancelBlock = cancelActionBlock;
    alert.rightName = rightName;
    alert.canBeRemoved = YES;
    [alert alertViewShow];
    return alert;
}

+ (FWAlertView *)alertViewShowType:(FWAlertType)type sureButtonName:(nonnull NSString *)rightName title:(nonnull NSString *)title content:(nonnull NSString *)content canBeRemoved:(BOOL)remove sureAction:(nonnull sureAction)sureActionBlock cancelAction:(nonnull cancelAction)cancelActionBlock{
    FWAlertView *alert = [[FWAlertView alloc]initWithType:type title:title content:content];
    alert.rightBlock = sureActionBlock;
    alert.cancelBlock = cancelActionBlock;
    alert.rightName = rightName;
    alert.canBeRemoved = remove;
    [alert alertViewShow];
    return alert;
}

#pragma mark - 按钮事件 -
- (void)buttonClick:(UIButton *)sender{
    
    if (self.type == FWAlertTypeLogOut) {
        if (sender.tag == 6666) {
            //左边
            !self.rightBlock ?: self.rightBlock(self.password.text);
        }else{
            !self.cancelBlock ?: self.cancelBlock();
        }
    }else{
        if (sender.tag == 6667) {
            //左边
            !self.rightBlock ?: self.rightBlock(self.checkPassWord.text);
        }else{
            !self.cancelBlock ?: self.cancelBlock();
        }
    }
    [self alertViewRemove];
}

#pragma mark - view隐藏和显示 -
- (void)alertViewShow{
    
    [kRootView addSubview:self];
}
- (void)alertViewRemove{
    
    if (self.canBeRemoved) {
        [self removeFromSuperview];
    }
}

- (void)setRightName:(NSString *)rightName{
    _rightName = rightName;
    if (rightName.length) {
        [self.rightButton setTitle:self.rightName forState:UIControlStateNormal];
    }
}

#pragma mark - 设置数据 -
- (void)setButtonTitle{
    
    if (_type == FWAlertTypeRelog) {
        
        [self.rightButton setTitle:Language(@"Key_reLogin_title") forState:UIControlStateNormal];
        
    }else if(_type == FWAlertTypeLogOut){
        
        [self.rightButton setTitle:Language(@"Key_cancel_title") forState:UIControlStateNormal];
        [self.leftButton setTitle:Language(@"Key_sure_title") forState:UIControlStateNormal];
    }else{
        [self.leftButton setTitle:Language(@"Key_cancel_title") forState:UIControlStateNormal];
        [self.rightButton setTitle:Language(@"Key_sure_title") forState:UIControlStateNormal];
    }
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:LLJPurpleColor forState:UIControlStateNormal];
}
#pragma mark - 布局 -
- (void)layoutSubview{
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myScrollView.mas_left).offset(LLJD_X(15));
        make.centerY.mas_equalTo(self.myScrollView.mas_centerY);
        make.width.mas_equalTo(LLJD_X(345));
        make.height.mas_equalTo(self.bgViewHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(LLJD_X(30));
        make.top.mas_equalTo(self.bgView.mas_top).offset(LLJD_Y(25));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(LLJD_X(30));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(LLJD_Y(15));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-LLJD_X(30));
    }];
    
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(LLJD_X(30));
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(self.textViewTopOffSet);
        make.width.mas_equalTo(LLJD_X(280));
        make.height.mas_equalTo(self.textViewHeight);
    }];
    
    if (_type == FWAlertTypeRelog) {
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.top.mas_equalTo(self.textBgView.mas_bottom).offset(LLJD_Y(30));
            make.width.mas_equalTo(self.rightWidth);
            make.height.mas_equalTo(LLJD_Y(40));
        }];
    }else if(_type == FWAlertTypeLogOut){
        
        [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textBgView.mas_left).offset(LLJD_X(10));
            make.top.mas_equalTo(self.textBgView.mas_top).offset(LLJD_Y(5));
            make.right.mas_equalTo(self.textBgView.mas_right).offset(-LLJD_X(10));
            make.bottom.mas_equalTo(self.textBgView.mas_bottom).offset(-LLJD_X(5));
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(LLJD_X(30));
            make.top.mas_equalTo(self.textBgView.mas_bottom).offset(LLJD_Y(30));
            make.width.mas_equalTo(self.rightWidth);
            make.height.mas_equalTo(LLJD_Y(40));
        }];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rightButton.mas_right).offset(LLJD_X(30));
            make.top.mas_equalTo(self.rightButton.mas_top);
            make.width.mas_equalTo(LLJD_X(130));
            make.height.mas_equalTo(LLJD_Y(40));
        }];
    }else{
        
        if (_type == FWAlertTypeCheckPw) {
            [self.checkPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.textBgView.mas_left).offset(LLJD_X(10));
                make.top.mas_equalTo(self.textBgView.mas_top).offset(LLJD_Y(5));
                make.right.mas_equalTo(self.textBgView.mas_right).offset(-LLJD_X(10));
                make.bottom.mas_equalTo(self.textBgView.mas_bottom).offset(-LLJD_X(5));
            }];
        }
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(LLJD_X(30));
            make.top.mas_equalTo(self.textBgView.mas_bottom).offset(LLJD_Y(30));
            make.width.mas_equalTo(LLJD_X(130));
            make.height.mas_equalTo(LLJD_Y(40));
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftButton.mas_right).offset(LLJD_X(30));
            make.top.mas_equalTo(self.leftButton.mas_top);
            make.width.mas_equalTo(self.rightWidth);
            make.height.mas_equalTo(LLJD_Y(40));
        }];
    }
    
    [self layoutIfNeeded];
    
    self.bgViewHeight = self.rightButton.frame.origin.y + self.rightButton.frame.size.height + LLJD_Y(20);
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.myScrollView.mas_left).offset(LLJD_X(15));
        make.centerY.mas_equalTo(self.myScrollView.mas_centerY);
        make.width.mas_equalTo(LLJD_X(345));
        make.height.mas_equalTo(self.bgViewHeight);
    }];
}

#pragma mark - 懒加载 -
- (TPKeyboardAvoidingScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[TPKeyboardAvoidingScrollView alloc]init];
        _myScrollView.backgroundColor = [UIColor clearColor];
    }
    return _myScrollView;
}
- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.tag = 6666;
        _leftButton.titleLabel.font = LLJMediumFont;
        _leftButton.layer.borderWidth = 1.0f;
        _leftButton.layer.borderColor = LLJColor(105, 97, 127, 0.2).CGColor;
        _leftButton.layer.cornerRadius = 5.0f;
        [_leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.tag = 6667;
        [_rightButton setTitleColor:LLJWhiteColor forState:UIControlStateNormal];
        _rightButton.titleLabel.font = LLJMediumFont;
        //_rightButton.titleLabel.numberOfLines = 2;
        //_rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _rightButton.layer.masksToBounds = NO;
        _rightButton.backgroundColor = LLJPurpleColor;
        //阴影
        _rightButton.layer.shadowColor = LLJColor(109, 92, 121, 0.1).CGColor;
        _rightButton.layer.shadowOpacity = 1.0f;
        _rightButton.layer.shadowOffset = CGSizeMake(0.0f, 8.0f);
        _rightButton.layer.shadowRadius = 16.0f;
        _rightButton.layer.cornerRadius = 6.0;
        [_rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = LLJBlackColor;
        _titleLabel.font = LLJLargeFont;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = LLJBlackColor;
        _infoLabel.font = LLJStandardFont;
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = LLJWhiteColor;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5.0;
    }
    return _bgView;
}

- (UIView *)textBgView{
    if (!_textBgView) {
        _textBgView = [[UIView alloc]init];
        _textBgView.backgroundColor = [UIColor whiteColor];
        _textBgView.layer.borderColor = LLJColor(105, 97, 127, 0.2).CGColor;
        _textBgView.layer.borderWidth = 0.5;
        _textBgView.layer.cornerRadius = 4.0;
    }
    return _textBgView;
}
- (FWTextView *)password{
    if (!_password) {
        _password = [[FWTextView alloc]init];
        _password.textColor = LLJBlackColor;
        _password.font = LLJMediumFont;
    }
    return _password;
}

- (UITextField *)checkPassWord{
    if (!_checkPassWord) {
        _checkPassWord = [[UITextField alloc]init];
        _checkPassWord.textColor = LLJBlackColor;
        _checkPassWord.font = LLJMediumFont;
        _checkPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        _checkPassWord.keyboardType = UIKeyboardTypeDefault;
        _checkPassWord.secureTextEntry = YES;
    }
    return _checkPassWord;
}

- (void)dealloc{
    NSLog(@"FWAlertView ..");
}

@end
