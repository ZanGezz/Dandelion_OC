//
//  LLJBrightView.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/12.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJBrightView.h"

#define COUNT 16

@interface LLJBrightView ()

@property (nonatomic) NSInteger baseTag;
@property (strong, nonatomic) UIImageView *backView;
@property (strong, nonatomic) UIImageView *oneView;

@end

@implementation LLJBrightView

- (instancetype)initWithBaseTag:(NSInteger)baseTag {
    
    UIImage *backImage = [UIImage imageNamed:self.backImageName.length > 0 ? self.backImageName : @"brightness"];
    self = [super initWithFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    if (self) {
        self.baseTag = 0;
        [self build];
    }
    return self;
}

- (void)build {
    
    self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backView.tag = self.baseTag;
    UIImage *backImage = nil;
    backImage = [UIImage imageNamed:self.backImageName.length > 0 ? self.backImageName : @"brightness"];
    
    self.backView.image = backImage;
    self.backView.frame = CGRectMake(0, 0, 155, 155);
    [self addSubview:self.backView];
    
    CGFloat delta = 1.f;
    CGFloat width = 7.f;
    CGFloat height = 5.f;
    CGFloat begain = 14.f;
    
    for (int i = 0; i < COUNT; i++) {
        CGRect frame = CGRectMake(i*(width + delta)+begain, 133.5f, width, height);
        [self build:frame tag:(i+self.baseTag + 1)];
    }
}

- (void)build:(CGRect)frame tag:(NSInteger)tag {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    UIImage *image = nil;
    image = [UIImage imageNamed:@"bright_point"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2.f topCapHeight:image.size.height/2.f];
    imageView.image = image;
    imageView.tag = tag;
    [self addSubview:imageView];
}

- (void)setValue:(CGFloat)value {
    
    if (_value != value) {
        _value = value;
        NSLog(@"COUNT = %f",COUNT*_value);
        for (int i = 0; i < COUNT; i++) {
            UIView *view = [self viewWithTag:(i+self.baseTag+1)];
            if (i < _value*COUNT) {
                view.hidden = NO;
            }else{
                view.hidden = YES;
            }
        }
        self.backView.hidden = NO;
    }
}
- (void)dealloc
{
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
