//
//  LLJControlViewManage.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/27.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLJVideoPlayModel.h"
//控制view
#import "LLJTopControlView.h"
#import "LLJLeftControlView.h"
#import "LLJBottomControlView.h"
#import "LLJRightControlView.h"
#import "LLJCenterControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLJControlViewManage : NSObject

@property (nonatomic, strong) LLJTopControlView    *topView;
@property (nonatomic, strong) LLJLeftControlView   *leftView;
@property (nonatomic, strong) LLJBottomControlView *bottomView;
@property (nonatomic, strong) LLJRightControlView  *rightView;
@property (nonatomic, strong) LLJCenterControlView *centerView;

@property (nonatomic) BOOL topViewAlwaysHidden;
@property (nonatomic) BOOL leftViewAlwaysHidden;
@property (nonatomic) BOOL bottomViewAlwaysHidden;
@property (nonatomic) BOOL rightViewAlwaysHidden;

@property (nonatomic, readonly) BOOL isCurrentControlViewAllHidden;

- (instancetype)initWithPlayerModel:(LLJVideoPlayModel *)model;

- (void)controlViewHidden:(BOOL)hidden;
/**
 *  旋转屏幕
 */
- (void)rotateScreen:(BOOL)toFull;

/**
 *  从父视图移除
 */
- (void)subViewRemoveFormSuperView;

@end

NS_ASSUME_NONNULL_END
