//
//  FWSelectView.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/13.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWSelectCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWSelectView : UIView

@property (nonatomic, copy) void (^didSelectRow)(NSInteger index, NSString *title);

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)item type:(FWSelectType)type defaultSelect:(NSInteger)defaultRow;

- (void)viewShow:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
