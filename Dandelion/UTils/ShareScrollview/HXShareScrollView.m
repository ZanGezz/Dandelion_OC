//
//  HXShareScrollView.m
//  IT小子
//
//  Created by 黄轩 on 16/1/13.
//  Copyright © 2015年 IT小子. All rights reserved.

#import "HXShareScrollView.h"

#define HXOriginX LLJD_X(20) //ico起点X坐标
#define HXOriginY LLJD_Y(30) //ico起点Y坐标
#define HXIcoWidth LLJD_X(60) //正方形图标宽度
#define HXIcoAndTitleSpace LLJD_Y(10) //图标和标题间的间隔
#define HXTitleSize 15.0 //标签字体大小
#define HXTitleColor [UIColor colorWithRed:52/255.0 green:52/255.0 blue:50/255.0 alpha:1.0] //标签字体颜色
#define HXLastlySpace LLJD_Y(8) //尾部间隔
#define HXHorizontalSpace LLJD_X(32) //横向间距

@implementation HXShareScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _originX = HXOriginX;
        _originY = HXOriginY;
        _icoWidth = HXIcoWidth;
        _icoAndTitleSpace = HXIcoAndTitleSpace;
        _titleSize = iPhone5?12:HXTitleSize;
        _titleColor = HXTitleColor;
        _lastlySpace = HXLastlySpace;
        _horizontalSpace = HXHorizontalSpace;

        //设置当前scrollView的高度
        if (self.frame.size.height <= 0) {
            self.frame = CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), _originY+_icoWidth+_icoAndTitleSpace+_titleSize+_lastlySpace);
        } else {
            self.frame = frame;
        }
    }
    return self;
}

- (void)setShareAry:(NSArray *)shareAry delegate:(id)delegate {
    
    //先移除之前的View
    if (self.subviews.count > 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //代理
    _myDelegate = delegate;

    //设置当前scrollView的contentSize
    if (shareAry.count > 0) {
        //单行
        self.contentSize = CGSizeMake(_originX+shareAry.count*(_icoWidth+_horizontalSpace),self.frame.size.height);
    }
    
    //遍历标签数组,将标签显示在界面上,并给每个标签打上tag加以区分
    for (NSDictionary *shareDic in shareAry) {
        
        NSUInteger i = [shareAry indexOfObject:shareDic];
        
        CGRect frame = CGRectMake(_originX+i*(_icoWidth+_horizontalSpace), _originY, _icoWidth, _icoWidth+_icoAndTitleSpace+_titleSize);
        UIView *view = [self ittemShareViewWithFrame:frame dic:shareDic];
        [self addSubview:view];
    }
}

- (UIView *)ittemShareViewWithFrame:(CGRect)frame dic:(NSDictionary *)dic {

    NSString *image = dic[@"image"];
    NSString *highlightedImage = dic[@"highlightedImage"];
    NSString *title = [dic[@"title"] length] > 0 ? dic[@"title"] : @"";
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
    button.titleLabel.font = [UIFont systemFontOfSize:_titleSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    if (image.length > 0) {
        [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (highlightedImage.length > 0) {
        [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y +button.frame.size.height+ _lastlySpace, view.frame.size.width, _titleSize)];
    label.textColor = _titleColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:_titleSize];
    label.text = title;
    [view addSubview:label];
    
    return view;
}

+ (float)getShareScrollViewHeight {
    float height = HXOriginY+HXIcoWidth+HXIcoAndTitleSpace+HXTitleSize;
    return height;
}

- (void)buttonAction:(UIButton *)sender {
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(shareScrollViewButtonAction:title:)]) {
        [_myDelegate shareScrollViewButtonAction:self title:sender.titleLabel.text];
    }
}

@end
