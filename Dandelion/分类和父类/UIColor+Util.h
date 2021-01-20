//
//  UIColor+Util.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)colorWithRGBString:(NSString *)colorString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithRGBString:(NSString *)colorString;

//获取序号随机色
+ (UIColor *)getRandenColorWithNumBer:(NSInteger)num;

//获取随机颜色
+ (UIColor *)arc4randomColor:(CGFloat)alpha;

@end
