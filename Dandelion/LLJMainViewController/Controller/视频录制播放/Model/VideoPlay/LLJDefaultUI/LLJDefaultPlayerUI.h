//
//  LLJDefaultPlayerUI.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/3.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLJControlViewManage.h"
#import "LLJVideoPlayModel.h"
#import "LLJBrightView.h"

NS_ASSUME_NONNULL_BEGIN

//按钮事件回调
typedef void (^ButtonClick) (UIButton *sender);
typedef void (^SlierClick) (UISlider *sender);

@interface LLJDefaultPlayerUI : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) ButtonClick backClick;
@property (nonatomic, copy) ButtonClick definiteClick;
@property (nonatomic, copy) ButtonClick rateClick;
@property (nonatomic, copy) ButtonClick playClick;
@property (nonatomic, copy) ButtonClick pauseClick;
@property (nonatomic, copy) ButtonClick fullScreenClick;
@property (nonatomic, copy) ButtonClick lockClick;
@property (nonatomic, copy) ButtonClick unLockClick;
@property (nonatomic, copy) ButtonClick rotationClick;

@property (nonatomic, copy) SlierClick sliderBegin;
@property (nonatomic, copy) SlierClick sliderMoving;
@property (nonatomic, copy) SlierClick sliderEnd;

@property (nonatomic, copy) NSString *currentTimeLabelText;
@property (nonatomic, copy) NSString *totalTimeLabelText;
//进度
@property (nonatomic) CGFloat sliderValue;
//缓冲
@property (nonatomic) CGFloat loadValue;
//声音
@property (nonatomic) CGFloat volumeValue;
//亮度
@property (nonatomic) CGFloat brightValue;

- (instancetype)initWithSuperView:(UIView *)superView model:(LLJVideoPlayModel *)model controlManage:(LLJControlViewManage *)manage;

- (void)upDatePlayButtonStatus:(BOOL)videoPlaySucess;

- (void)updateVolumeViewTransForm;

@end

NS_ASSUME_NONNULL_END
