//
//  LLJAlertView.h
//  Dandelion
//
//  Created by 刘帅 on 2019/12/13.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJAlertView : UIView

@property (nonatomic, strong) NSString *cancelTitle;                       //取消按钮文字
@property (nonatomic, strong) UIColor *cancelColor;                        //取消字体颜色
@property (nonatomic, strong) UIColor *commenColor;                        //选项字体颜色
@property (nonatomic) CGFloat rowHeight;                                   //选项高度
@property (nonatomic, copy) void (^didSelectRow)(NSString *rowTitle);      //点击选项

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)item;

- (void)viewShow:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
