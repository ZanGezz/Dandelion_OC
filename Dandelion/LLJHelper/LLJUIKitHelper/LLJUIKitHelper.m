//
//  LLJUIKitHelper.m
//  Dandelion
//
//  Created by 刘帅 on 2020/12/11.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJUIKitHelper.h"

@implementation LLJUIKitHelper

/**
 *  获取view
 */
+ (UIView *)manageWithView:(UIView *)managedView backGroundColor:(UIColor *)color maskToBounds:(BOOL)maskToBounds cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor {
    UIView *view = managedView;
    if (!view) {
        view = [[UIView alloc]init];
    }
    if (color) {
        view.backgroundColor = color;
    }
    view.layer.masksToBounds = maskToBounds;
    view.layer.cornerRadius = radius ? radius : 0.0;
    view.layer.borderWidth = width ? width : 0.0;
    if (borderColor) {
        view.layer.borderColor = borderColor.CGColor;
    }
    return view;
}
/**
 *  创建label
 */
+ (UILabel *)getLabelWithLabel:(UILabel *)managedLabel title:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment backGroundColor:(UIColor *)backGroundColor numberOfLines:(NSInteger)lines{
    UILabel *label = managedLabel;
    if (!label) {
        label = [[UILabel alloc]init];
    }
    label.text = title ? title : @"";
    if (titleColor) {
        label.textColor = titleColor;
    }
    if (textFont) {
        label.font = textFont;
    }
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    if (backGroundColor) {
        label.backgroundColor = backGroundColor;
    }
    label.numberOfLines = lines;

    return label;
}

@end
