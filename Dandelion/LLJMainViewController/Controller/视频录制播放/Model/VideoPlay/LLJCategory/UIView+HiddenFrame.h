//
//  UIView+HiddenFrame.h
//  
//
//  Created by 刘帅 on 2020/11/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HiddenFrame)

@property (nonatomic) CGRect animateHiddenSmallScreenFrame;
@property (nonatomic) CGRect animateCommenSmallScreenFrame;
@property (nonatomic) CGRect animateHiddenFullScreenFrame;
@property (nonatomic) CGRect animateCommenFullScreenFrame;
@property (nonatomic) CGRect animateCommenRotateViewFullScreenFrame;
@property (nonatomic) CGRect animateHiddenRotateViewFullScreenFrame;

@end

NS_ASSUME_NONNULL_END
