//
//  LLJNaviController.h
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJNaviController : UINavigationController

//修改字体颜色
- (void)setUpTitleColor:(UIColor *)titleColor font:(UIFont *)titleFont;
//修改背景颜色
- (void)setUpBackGroundColor:(UIColor *)color;
//修改背景图片
- (void)setUpBackGroundImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
