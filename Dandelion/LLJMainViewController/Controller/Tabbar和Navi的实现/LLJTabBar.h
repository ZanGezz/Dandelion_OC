//
//  LLJTabBar.h
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJTabBar : UITabBar

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,strong)UIButton *plusItem;  //凸起录制按钮

@end

NS_ASSUME_NONNULL_END
