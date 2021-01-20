//
//  LLJUIKitHelper.h
//  Dandelion
//
//  Created by 刘帅 on 2020/12/11.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLJUIKitHelper : NSObject

/**
 *  获取view
 */
+ (UIView *)manageWithView:(UIView *)managedView backGroundColor:(UIColor *)color maskToBounds:(BOOL)maskToBounds cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor;
/**
 *  创建label
 */
+ (UILabel *)getLabelWithLabel:(UILabel *)managedLabel titleitle:(NSString *)title titleColor:(UIColor *)titleColor textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment backGroundColor:(UIColor *)backGroundColor numberOfLines:(NSInteger)lines;

@end
