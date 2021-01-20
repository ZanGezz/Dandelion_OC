//
//  BWPSourceSelectView.h
//  BWPensionPro
//
//  Created by 刘帅 on 2019/4/26.
//  Copyright © 2019 Beiwaionline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWPSourceSelectView;

@protocol BWPSourceSelectViewDelegate <NSObject>

- (void)easyCustomShareViewButtonAction:(BWPSourceSelectView *)shareView title:(NSString *)title;

@end

@interface BWPSourceSelectView : UIView

@property (nonatomic,assign) id<BWPSourceSelectViewDelegate> delegate;
@property (nonatomic,strong) UIView *backView;//背景View
@property (nonatomic,strong) UIView *headerView;//头部分享标题
@property (nonatomic,strong) UIView *boderView;//中间View,主要放分享
@property (nonatomic,strong) UILabel *middleLineLabel;//中间线
@property (nonatomic,assign) NSInteger firstCount;//第一行分享媒介数量,分享媒介最多显示2行,如果第一行显示了全部则不显示第二行
@property (nonatomic,strong) UIView *footerView;//尾部其他自定义View
@property (nonatomic,strong) UIButton *cancleButton;//取消
@property (nonatomic,assign) BOOL showsHorizontalScrollIndicator;//是否显示滚动条

- (void)setShareAry:(NSArray *)shareAry delegate:(id)delegate;
- (float)getBoderViewHeight:(NSArray *)shareAry firstCount:(NSInteger)count;

@end

