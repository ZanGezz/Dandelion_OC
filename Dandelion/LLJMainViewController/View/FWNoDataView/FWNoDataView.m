//
//  FWNoDataView.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/18.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWNoDataView.h"

@interface FWNoDataView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iamgeView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIButton *reLoadButton;

@end

@implementation FWNoDataView

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LLJColor(243, 243, 243, 1);
        
        [self addSubview:self.bgView];
        [self addSubview:self.alertLabel];
        [self addSubview:self.iamgeView];
        [self addSubview:self.reLoadButton];
        
        [self layoutSubview];
    }
    return self;
}

- (void)buttonClick{
    !self.reloadData ?: self.reloadData();
}

- (void)setType:(FWNoDataType)type{
    
    if (type == FWNoDataTypeInteract) {
        
        self.bgView.layer.cornerRadius = 10.0f;
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(LLJD_X(14));
            make.top.mas_equalTo(self.mas_top).offset(LLJD_Y(15));
            make.right.mas_equalTo(self.mas_right).offset(LLJD_X(-14));
            make.bottom.mas_equalTo(self.mas_bottom).offset(LLJD_Y(-14));
        }];
    }else{
        self.bgView.layer.cornerRadius = 0.0f;
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    self.reLoadButton.hidden = YES;
    switch (type) {
        case FWNoDataTypeNoData:
        {
            [self.iamgeView setImage:[UIImage imageNamed:@"noData"]];
            self.alertLabel.text = Language(@"Key_noData_alert");
        }
            break;
        case FWNoDataTypeLoadFail:
        {
            self.reLoadButton.hidden = NO;
            [self.iamgeView setImage:[UIImage imageNamed:@"loadFail"]];
            self.alertLabel.text = Language(@"Key_loadFaill_alert");
            [self.reLoadButton setTitle:Language(@"Key_reload_title") forState:UIControlStateNormal];
        }
            break;
        case FWNoDataTypeNoNetWork:
        {
            self.reLoadButton.hidden = NO;
            [self.iamgeView setImage:[UIImage imageNamed:@"noNet"]];
            self.alertLabel.text = Language(@"Key_noNetwork_alert");
            [self.reLoadButton setTitle:Language(@"Key_reload_title") forState:UIControlStateNormal];
        }
            break;
        case FWNoDataTypeInteract:
        {
            [self.iamgeView setImage:[UIImage imageNamed:@"noInteract"]];
            self.alertLabel.text = Language(@"Key_noQa_alert");
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubview{
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.iamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(LLJD_Y(230) - LLJTopHeight);
        make.width.mas_equalTo(LLJD_X(163));
        make.height.mas_equalTo(LLJD_Y(117));
    }];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.iamgeView.mas_bottom).offset(LLJD_Y(20));
        make.height.mas_equalTo(LLJD_Y(15));
    }];
    
    [self.reLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(LLJD_Y(61));
        make.height.mas_equalTo(LLJD_Y(40));
        make.width.mas_equalTo(LLJD_X(165));
    }];
}

- (UIImageView *)iamgeView{
    if (!_iamgeView) {
        _iamgeView= [[UIImageView alloc]init];
    }
    return _iamgeView;
}
- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.textColor = LLJBlackColor;
        _alertLabel.font = LLJMediumFont;
        _alertLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alertLabel;
}
- (UIButton *)reLoadButton{
    if (!_reLoadButton) {
        _reLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reLoadButton.titleLabel.font = LLJMediumFont;
        _reLoadButton.layer.masksToBounds = YES;
        _reLoadButton.layer.borderWidth = 1.0f;
        _reLoadButton.layer.borderColor = LLJColor(105, 97, 127, 0.2).CGColor;
        _reLoadButton.layer.cornerRadius = 5.0f;
        [_reLoadButton setTitleColor:LLJBlackColor forState:UIControlStateNormal];
        [_reLoadButton setTitle:Language(@"Key_reload_title") forState:UIControlStateNormal];
        [_reLoadButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reLoadButton;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
@end
