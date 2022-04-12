//
//  FWGuideView.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/31.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWGuideView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FWGpwView.h"
#import "FWAlertView.h"
#import "FWAuthIDHelper.h"

typedef void(^Action)(void);

@interface FWGuideView ()

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *myScrollView; //自适应键盘
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *pwButton;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *orLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) Action action;

@end

@implementation FWGuideView

+ (FWGuideView *)guideViewShow:(UIView *)superView action:(Action)action{
    CGFloat H;
    if (superView == kRootView) {
        H = SCREEN_HEIGHT;
    }else{
        H = SCREEN_HEIGHT - LLJTabBarHeight;
    }
    FWGuideView *guide = [[FWGuideView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, H)];
    guide.action = action;
    [superView addSubview:guide];
    return guide;
}

- (void)guideViewHidden{
    
    for (UIView *subView in kRootView.subviews) {
        if ([subView isKindOfClass:[FWAlertView class]]) {
            [subView removeFromSuperview];
        }
    }
    [self removeFromSuperview];
}

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = LLJColor(243, 243, 243, 1);
        [self addSubviews];
    }
    return self;
}

- (void)checkPwSucess{
    [self guideViewHidden];
}

- (void)addSubviews{
    
    if ([FWUserDefultHelper authIDCanBeUsed] && [FWUserDefultHelper gesCanBeUsed]) {
        [self addSubview:self.imageView];
        [self addSubview:self.infoLabel];
        [self addSubview:self.startButton];
        [self addSubview:self.orLabel];
        [self addSubview:self.pwButton];
        [self addSubview:self.lineView];
        self.infoLabel.text = Language(@"Key_guide_alert");
        [self layOutSubView];
    }else{
        [self authIDShow:LAPolicyDeviceOwnerAuthentication];
    }
}

- (void)authIDShow:(LAPolicy)policy{
    
    if (![FWUserDefultHelper authIDCanBeUsed]) {
        
        [FWAuthIDHelper llj_showAuthIDWithDescribe:nil policy:policy block:^(LLJAuthIDState state, NSError *error) {
            
            if (state == LLJAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            } else if(state == LLJAuthIDStateFail) { // 认证失败
            } else if(state == LLJAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            } else if (state == LLJAuthIDStateSuccess) { // TouchID/FaceID验证成功
                [self checkPwSucess];
            } else if (state == LLJAuthIDStatePassWordSuccess){
            } else if (state == LLJAuthIDStateUserCancel) { // 用户取消！
                if (![FWUserDefultHelper gesCanBeUsed]) {
                    [self gpsViewShow];
                }else{
                    [self checkPwViewShow];
                }
            }else if (state == LLJAuthIDStatePasswordNotSet){
            }else if (state == LLJAuthIDStateTouchIDNotSet){
            }
        }];
    }else{
        if ([FWUserDefultHelper gesCanBeUsed]) {
            [self gpsViewShow];
        }else{
            [self checkPwViewShow];
        }
    }
}

- (void)checkPwViewShow{
    
    [FWAlertView alertViewShowType:FWAlertTypeCheckPw sureButtonName:@"" title:Language(@"Key_checkPw_title") content:@"" sureAction:^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"zangezzz"]) {
            [self guideViewHidden];
        }
    } cancelAction:^{
        if (![FWUserDefultHelper gesCanBeUsed] && [FWUserDefultHelper authIDCanBeUsed]) {
            
        }
    }];
}

- (void)gpsViewShow{
        
    LLJWeakSelf(self);
    [self addSubview:self.alertLabel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.pwButton];
    [self addSubview:self.orLabel];
    [self addSubview:self.lineView];
    
    self.alertLabel.text = Language(@"Key_gesUnlocked_alert");
    self.alertLabel.textColor = LLJBlackColor;

    FWGpwView *gpwView = [FWGpwView model:[[FWGpwModel alloc]init] status:GesturePasswordStatusLogin frame:CGRectMake(0, LLJD_OffSetY(130) + LLJTopHeight, SCREEN_WIDTH, LLJD_Y(282)) verificationPassword:^{
        
    } verificationError:^{
        
    } onPasswordSet:^{
        //第一次输入
    } onGetCorrectPswd:^(NSString * _Nonnull password) {
        //密码验证通过
        [weakSelf checkPwViewShow];
        //[weakSelf checkPwSucess];
        
    } onGetIncorrectPswd:^(NSString * _Nonnull errorCount) {
        //密码验证失败
        if (errorCount.integerValue == 0) {
            
        }
        weakSelf.alertLabel.text = Language(@"Key_gesInputWrongTimes_alert");
        weakSelf.alertLabel.textColor = LLJColor(214, 30, 30, 1);
    } errorInput:^{
        //不能少于4个点
        weakSelf.alertLabel.textColor = LLJColor(214, 30, 30, 1);
        weakSelf.alertLabel.text = Language(@"Key_gesLeastPoint_title");
    }];

    [self addSubview:gpwView];
    
    [self.alertLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(LLJD_OffSetY(40) + LLJTopHeight);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(LLJD_Y(16));
    }];

    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(LLJD_Y(17));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(LLJD_Y(14));
    }];

    [self.pwButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-LLJD_OffSetY(60));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(LLJD_Y(16));
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwButton.mas_bottom);
        make.left.mas_equalTo(self.pwButton.mas_left);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.pwButton.mas_right);
    }];
    
    [self.orLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.pwButton.mas_top).offset(LLJD_S(-10));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (void)layOutSubView{
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(LLJD_OffSetY(67) + LLJTopHeight);
        make.width.mas_equalTo(LLJD_X(239));
        make.height.mas_equalTo(LLJD_Y(168));
    }];
    
    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(LLJD_Y(31));
        make.width.mas_equalTo(LLJD_X(239));
    }];
    
    [self.startButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(LLJD_Y(40));
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(LLJD_Y(40));
    }];
    
    [self.orLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.startButton.mas_bottom).offset(LLJD_S(15));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.pwButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.orLabel.mas_bottom).offset(LLJD_S(5));
        make.height.mas_equalTo(LLJD_Y(16));
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwButton.mas_bottom);
        make.left.mas_equalTo(self.pwButton.mas_left);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.pwButton.mas_right);
    }];
}

#pragma mark - 按钮事件 -
- (void)buttonClick:(UIButton *)sender{
    
    if (sender.tag == 11111) {
        //去开启
        !self.action ?: self.action();
    }else{
        //使用密码
        [self checkPwViewShow];
    }
}


#pragma mark - 懒加载 -
- (TPKeyboardAvoidingScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[TPKeyboardAvoidingScrollView alloc]init];
        _myScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _myScrollView;
}

- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.tag = 11111;
        [_startButton setTitleColor:LLJPurpleColor forState:UIControlStateNormal];
        _startButton.titleLabel.font = LLJStandardFont;
        _startButton.backgroundColor = LLJWhiteColor;
        [_startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage  *image = [UIImage imageNamed:@"purpleNext"];
        NSString *titleString = Language(@"Key_kaiqi_alert");
        CGFloat  titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:LLJStandardFont}].width;
        CGFloat  imageWidth = image.size.width;
        CGFloat  space = 8;// 图片和文字的间距
        
        [_startButton setTitle:titleString forState:UIControlStateNormal];
        [_startButton setImage:image forState:UIControlStateNormal];
        [_startButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5))];
        [_startButton setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
    }
    return _startButton;
}

- (UIButton *)pwButton{
    if (!_pwButton) {
        _pwButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pwButton.tag = 11112;
        [_pwButton setTitleColor:LLJBlackColor forState:UIControlStateNormal];
        _pwButton.titleLabel.font = LLJMediumFont;
        [_pwButton setTitle:Language(@"Key_checkPw_button") forState:UIControlStateNormal];
        [_pwButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwButton;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        if ([[FWLangageHelper currentLangage] isEqualToString:@"en"]) {
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guideEn"]];
        }else{
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guideCh"]];
        }
    }
    return _imageView;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = LLJLightGreyColor;
        _infoLabel.font = LLJMediumFont;
        _infoLabel.numberOfLines = 0;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}
- (UILabel *)orLabel{
    if (!_orLabel) {
        _orLabel = [[UILabel alloc]init];
        _orLabel.textColor = LLJLightGreyColor;
        _orLabel.font = LLJMediumFont;
        _orLabel.text = Language(@"Key_or_title");
        _orLabel.numberOfLines = 0;
        _orLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _orLabel;
}
- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.textColor = LLJBlackColor;
        _alertLabel.font = LLJBoldFont(16);
        _alertLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alertLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LLJBlackColor;
    }
    return _lineView;
}

- (void)dealloc{
    NSLog(@"FWGuideView ..");
}

@end
