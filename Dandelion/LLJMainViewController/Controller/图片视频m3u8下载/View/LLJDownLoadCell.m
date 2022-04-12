//
//  LLJDownLoadCell.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/19.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJDownLoadCell.h"
#import "LLJDownLoadManage.h"

@interface LLJDownLoadCell ()

@property (nonatomic, strong) LLJDownLoadModel *model;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *downLoadButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *lineView;

@end

@implementation LLJDownLoadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.downLoadButton];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.lineView];
        
        
        [self layoutSubview];
    }
    return self;
}

#pragma mark - 赋值 -
- (void)setupContentWithModel:(LLJDownLoadModel *)model {
    
    self.model = model;

    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.fileName];
    
    [self updateProgress];
    [self setButtonTitle:self.model.type];
    
}

- (void)updateProgress {
    
    self.progressView.progress = self.model.currentProgress;
    if (self.model.type != LLJDownLoadTypeFinish) {
        [self performSelector:@selector(updateProgress) withObject:nil afterDelay:0.1];
    }
}

- (void)downTypeUpdate:(UIButton *)button {
    
    switch (self.model.type) {
        case LLJDownLoadTypePrePared:
        case LLJDownLoadTypeWait:
        case LLJDownLoadTypePause:
        case LLJDownLoadTypeError:
        {
            [LLJDownLoad startDownLoadWithModel:self.model];
        }
            break;
        case LLJDownLoadTypeDownLoading:
        {
            [self.model suspend];
        }
            break;
            
        default:
            break;
    }
}

- (void)setButtonTitle:(LLJDownLoadType)type {
    switch (type) {
        case LLJDownLoadTypePrePared:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.downLoadButton setTitle:@"未开始" forState:UIControlStateNormal];
            });
        }
            break;
        case LLJDownLoadTypeWait:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.downLoadButton setTitle:@"等待中" forState:UIControlStateNormal];
            });
        }
            break;
        case LLJDownLoadTypeDownLoading:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.downLoadButton setTitle:@"下载中" forState:UIControlStateNormal];
            });
        }
            break;
        case LLJDownLoadTypePause:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.downLoadButton setTitle:@"暂停" forState:UIControlStateNormal];
            });
        }
            break;
        case LLJDownLoadTypeFinish:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.downLoadButton setTitle:@"完成" forState:UIControlStateNormal];
            });
        }
            break;
        case LLJDownLoadTypeError:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.downLoadButton setTitle:@"出错啦" forState:UIControlStateNormal];
            });
        }
            break;
            
        default:
            break;
    }
    
    self.model.updateDownLoadType = ^(LLJDownLoadType type) {
        [self setButtonTitle:type];
    };
}

#pragma mark - 布局 -
- (void)layoutSubview
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(LLJD_X(16));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    
    [self.downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-LLJD_X(10));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(LLJD_X(10));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.downLoadButton.mas_left).offset(-LLJD_X(10));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(LLJD_Y(1));
    }];
}

#pragma mark - 懒加载 -
- (UIButton *)downLoadButton {
    if (!_downLoadButton) {
        _downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadButton setTitle:@"- -" forState:UIControlStateNormal];
        [_downLoadButton setTitleColor:LLJPurpleColor forState:UIControlStateNormal];
        [_downLoadButton addTarget:self action:@selector(downTypeUpdate:) forControlEvents:UIControlEventTouchUpInside];
        _downLoadButton.layer.masksToBounds = YES;
        _downLoadButton.layer.borderColor = LLJWhiteColor.CGColor;
        _downLoadButton.layer.borderWidth = 2.0f;
        _downLoadButton.layer.cornerRadius = 3.0f;
    }
    return _downLoadButton;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progressTintColor = LLJPurpleColor;
        _progressView.trackTintColor = LLJLightGreyColor;
    }
    return _progressView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:iPhone5?12:14];
        _titleLabel.textColor = LLJCommenColor;
    }
    return _titleLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LLJColor(238, 238, 238, 1);
    }
    return _lineView;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}
@end
