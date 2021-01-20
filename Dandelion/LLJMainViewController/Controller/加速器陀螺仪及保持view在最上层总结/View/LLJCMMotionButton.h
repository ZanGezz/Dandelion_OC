//
//  LLJCMMotionButton.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/29.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJCMMotionButton : UIButton

@property (nonatomic) CGFloat topBackSpeed;
@property (nonatomic) CGFloat leftBackSpeed;
@property (nonatomic) CGFloat bottomBackSpeed;
@property (nonatomic) CGFloat rightBackSpeed;

/**
 *  开始加速
 */
- (void)addCMMotion;
/**
 *  结束加速
 */
- (void)stopCMMotion;

@end

NS_ASSUME_NONNULL_END
