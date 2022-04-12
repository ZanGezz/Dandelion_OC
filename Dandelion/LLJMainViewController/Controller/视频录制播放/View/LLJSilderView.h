//
//  LLJSilderView.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/6.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJSilderView : UISlider

@property (nonatomic, strong) UIColor *progressBackGroundColor;
@property (nonatomic, strong) NSString *progressBackGroundImage;
@property (nonatomic) CGFloat progressValue;

@end

NS_ASSUME_NONNULL_END
