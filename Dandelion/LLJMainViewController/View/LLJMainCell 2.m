//
//  LLJMainCell.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/18.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJMainCell.h"

@interface LLJMainCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *dicImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LLJMainCell

#pragma mark - 初始化 -
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.dicImageView];
        [self.contentView addSubview:self.lineView];
        [self layoutSubview];
    }
    return self;
}
#pragma mark - 赋值 -
- (void)setTitleName:(NSString *)name{
    self.titleLabel.text = name;
}
#pragma mark - 布局 -
- (void)layoutSubview{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LLJD_X(15));
        make.right.mas_equalTo(self.mas_right).offset(-LLJD_X(40));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    UIImage *image = [UIImage imageNamed:@"wode_next"];
    [self.dicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(LLJD_X(-20));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark - 懒加载属性 -
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = LLJCommenFont;
        _titleLabel.textColor = LLJCommenColor;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
- (UIImageView *)dicImageView{
    if (!_dicImageView) {
        _dicImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wode_next"]];
    }
    return _dicImageView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = LLJColor(238, 238, 238, 1);
    }
    return _lineView;
}
@end
