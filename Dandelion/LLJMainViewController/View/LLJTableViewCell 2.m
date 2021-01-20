//
//  LLJTableViewCell.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/11.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJTableViewCell.h"

@interface LLJTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LLJTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        
        [self layoutSubview];
    }
    return self;
}
#pragma mark - 布局 -
- (void)layoutSubview
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LLJD_X(16));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-LLJD_X(45));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(LLJD_Y(1));
    }];
}


#pragma mark - 设置cell间距 -
//- (void)setFrame:(CGRect)frame{
//    frame.origin.x += 0;       //左间距
//    frame.origin.y += 10;      //上间距
//    frame.size.height -= 10;   //下间距
//    frame.size.width -= 0;     //又间距
//    [super setFrame:frame];
//}
#pragma mark - 赋值 -
- (void)setupContentWithModel:(LLJCommenModel *)model
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.name,model.age];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:iPhone5?12:14];
        _titleLabel.textColor = LLJCommenColor;
    }
    return _titleLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LLJColor(238, 238, 238, 1);
    }
    return _lineView;
}

@end
