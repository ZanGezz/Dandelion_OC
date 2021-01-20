//
//  LLJSilderView.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/6.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJSilderView.h"

@interface LLJSilderView ()

@property (nonatomic) CGFloat width;
@property (nonatomic, strong) UIImageView *maxSlierView;
@property (nonatomic, strong) UIImageView *progressView;

@end

@implementation LLJSilderView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self addMySubview];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _progressBackGroundColor = backgroundColor;
    _progressView.backgroundColor = backgroundColor;
}
- (void)setProgressBackGroundImage:(NSString *)progressBackGroundImage {
    _progressBackGroundImage = progressBackGroundImage;
    [_progressView setImage:[UIImage imageNamed:@"progressBackGroundImage"]];
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    [self layoutSubviews];
}

- (void)addMySubview {
    
    [self.superview layoutIfNeeded];
    [self layoutSubviews];

    UIView *subView = [self.subviews firstObject];
    self.maxSlierView = [subView.subviews firstObject];

    [self.maxSlierView addSubview:self.progressView];
    [self layoutProgressView];
}

- (void)layoutProgressView {
    
    if (self.maxSlierView) {
        CGRect bounds;
        CGRect frame = self.maxSlierView.frame;
        bounds.origin.x = 0.0;
        bounds.origin.y = 0.0;
        bounds.size.width = self.frame.size.width*self.progressValue;
        bounds.size.height = frame.size.height;
        self.progressView.frame = bounds;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutProgressView];
}

- (UIImageView *)progressView {
    if (!_progressView) {
        _progressView = [[UIImageView alloc]init];
        _progressView.backgroundColor = [UIColor lightGrayColor];
    }
    return _progressView;
}
@end
