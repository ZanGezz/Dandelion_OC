//
//  LLJImagePickerCell.m
//  
//
//  Created by 刘帅 on 2021/1/5.
//

#import "LLJImagePickerCell.h"

@interface LLJImagePickerCell ()

@property (nonatomic, strong) UIImageView *pickerImageView;

@end

@implementation LLJImagePickerCell

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = LLJColor(65, 65, 65, 1);
        [self addSubview:self.pickerImageView];
    }
    return self;
}

#pragma mark - 设置图片 -
- (void)setUpImage:(UIImage *)image isAddImage:(BOOL)isAdd{
    
    if (isAdd) {
        self.pickerImageView.frame = CGRectMake((self.contentView.frame.size.width - image.size.width)/2, (self.contentView.frame.size.width - image.size.width)/2, image.size.width, image.size.width);
    } else {
        self.pickerImageView.frame = self.contentView.bounds;
    }
    if (image) {
        [self.pickerImageView setImage:image];
    }
}

#pragma mark - 懒加载 -
- (UIImageView *)pickerImageView {
    if (!_pickerImageView) {
        _pickerImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _pickerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pickerImageView.backgroundColor = [UIColor clearColor];
        _pickerImageView.layer.masksToBounds = YES;
    }
    return _pickerImageView;
}
@end
