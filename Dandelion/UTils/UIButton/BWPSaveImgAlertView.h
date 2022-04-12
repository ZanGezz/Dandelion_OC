//
//  BWPSaveImgAlertView.h
//  BWPensionPro
//
//  Created by 刘帅 on 2019/5/27.
//  Copyright © 2019 Beiwaionline. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BWPSaveImgAlertView : UIView

@property (nonatomic, copy) void (^didSelectRow)(NSInteger indexPath);

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)item;

- (void)viewShow:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
