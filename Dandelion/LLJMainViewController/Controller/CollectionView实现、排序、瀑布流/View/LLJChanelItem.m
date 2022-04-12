//
//  LLJChanelItem.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/12.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJChanelItem.h"

@interface LLJChanelItem ()
{
    //删除按钮
    UIButton *removeBtn;
    //图片index
    NSInteger _imageIndex;
}
@end

@implementation LLJChanelItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.userInteractionEnabled = true;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [self backgroundColor];
    //图片视图
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.bounds.size.width);
        make.height.mas_equalTo(self.contentView.bounds.size.height);
        
    }];
    //删除按钮
    removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeBtn setImage:[UIImage imageNamed:@"delete_pic"] forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:removeBtn];
    [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.width.mas_equalTo(LLJD_X(20));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
}

- (void)removePhotoAction{
    !self.deletIamgeBlock ?: self.deletIamgeBlock(_imageIndex);
}

#pragma mark - 设置数据
- (void)setIamgeName:(id)imageName index:(NSInteger)imageIndex deletHidden:(BOOL)hidden{
    
    if (hidden) {
        removeBtn.hidden = YES;
    }else{
        removeBtn.hidden = NO;
    }
    
    _imageIndex = imageIndex;
    
    if ([imageName isKindOfClass:[UIImage class]]) {
        _imageView.image = imageName;
    }else{
        [_imageView sd_setImageWithURL:(NSURL *)imageName];
    }
}

#pragma mark - 配置方法
-(UIColor*)backgroundColor{
    return [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
}

#pragma mark Setter
-(void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = [self backgroundColor];
    }
}
-(void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
}

@end
