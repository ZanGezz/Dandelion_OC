//
//  FWSelectCell.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/13.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWSelectCell.h"

@interface FWSelectCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *directImage;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic) FWSelectType type;

@end

@implementation FWSelectCell

#pragma mark - 初始化 -
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(FWSelectType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _type = type;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.directImage];
        [self.contentView addSubview:self.lineView];
        //布局
        [self layoutSubview];
    }
    return self;
}

#pragma mark - 设置数据 -
- (void)setTitle:(NSString *)title font:(nonnull NSString *)fontString{
    
    self.titleLabel.text = Language(title);
    self.titleLabel.font = LLJFontName(@"PingFangSC-Regular", fontString.integerValue);
    [self.directImage setImage:[UIImage imageNamed:@"duiHao"]];
}

- (void)setIsSelected:(BOOL)isSelected{
    
    _isSelected = isSelected;
    
    if (isSelected) {
        _titleLabel.textColor = LLJPurpleColor;
        self.directImage.hidden = NO;
    }else{
        _titleLabel.textColor = LLJBlackColor;
        self.directImage.hidden = YES;
    }
}

#pragma mark - 布局 -
- (void)layoutSubview{
    
    if (_type == FWSelectTypeNameLeft) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(LLJSideOffSet);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }else{
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    [self.directImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-LLJSideOffSet);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LLJSideOffSet);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - 懒加载 -
- (UIImageView *)directImage{
    if (!_directImage) {
        _directImage = [[UIImageView alloc]init];
    }
    return _directImage;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = LLJBlackColor;
        _titleLabel.font = LLJMediumFont;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LLJColor(238, 238, 238, 1);
    }
    return _lineView;
}

@end
