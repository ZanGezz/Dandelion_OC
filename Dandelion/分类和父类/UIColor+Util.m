//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

#pragma mark - Hex
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}
#pragma mark - #Color
+ (UIColor *)colorWithRGBString:(NSString *)colorString alpha:(CGFloat)alpha
{
    // 转换成标准16进制数
    NSRange range = [colorString rangeOfString:@"#"];
    NSString *color = [colorString stringByReplacingCharactersInRange:range withString:@"0x"];
    // 十六进制字符串转成整形。
    long colorLong = strtoul([color cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    
    //string转color
    UIColor *newColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
    return newColor;
}
+ (UIColor *)colorWithRGBString:(NSString *)colorString
{
    return [self colorWithRGBString:colorString alpha:1.0];
}
# pragma mark - Three Color Methods
+ (UIColor *)getRandenColorWithNumBer:(NSInteger)num
{
    NSArray *colourArr =@[
                          @"#D88C8C",@"#D8938C",@"#D8998C",@"#D89F8C",@"#D8A68C",
                          @"#D8AC8C",@"#D8B28C",@"#D8B98C",@"#D8BF8C",@"#D8C58C",
                          @"#D8CC8C",@"#D8D28C",@"#D8D88C",@"#D2D88C",@"#CCD88C",
                          @"#C5D88C",@"#BFD88C",@"#B9D88C",@"#B2D88C",@"#ACD88C",
                          @"#A6D88C",@"#9FD88C",@"#99D88C",@"#93D88C",@"#8CD88C",
                          @"#8CD893",@"#8CD899",@"#8CD89F",@"#8CD8A6",@"#8CD8AC",
                          @"#8CD8B2",@"#8CD8B9",@"#8CD8BF",@"#8CD8C5",@"#8CD8CC",
                          @"#8CD8D2",@"#8CD8D8",@"#8CD2D8",@"#8CCCD8",@"#8CC5D8",
                          @"#8CBFD8",@"#8CB9D8",@"#8CB2D8",@"#8CACD8",@"#8CA6D8",
                          @"#8C9FD8",@"#8C99D8",@"#8C93D8",@"#8C8CD8",@"#938CD8",
                          @"#998CD8",@"#9F8CD8",@"#A68CD8",@"#AC8CD8",@"#B28CD8",
                          @"#B98CD8",@"#BF8CD8",@"#C58CD8",@"#CC8CD8",@"#D28CD8",
                          @"#D88CD8",@"#D88CD2",@"#D88CCC",@"#D88CC5",@"#D88CBF",
                          @"#D88CB9",@"#D88CB2",@"#D88CAC",@"#D88CA6",@"#D88C9F",
                          @"#D88C99",@"#D88C93"
                          ];
    NSInteger colorNum = (num%24)*3 + (num/24);
    //防止溢出
    if (colorNum >71) {
        colorNum = colorNum%72;
    }
    NSString * colorStr = [colourArr objectAtIndex:colorNum];
    UIColor *color = [self colorWithRGBString:colorStr];
    return color;
}
//随机生成颜色
+ (UIColor *)arc4randomColor:(CGFloat)alpha{
    
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

@end
