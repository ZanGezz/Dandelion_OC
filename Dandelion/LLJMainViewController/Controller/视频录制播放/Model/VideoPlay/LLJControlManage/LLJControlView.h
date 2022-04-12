//
//  LLJControlView.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLJVideoPlayModel.h"
#import "LLJControlViewSubViewModel.h"

typedef NS_ENUM(NSUInteger, LLJControlViewType) {
    LLJControlViewTypeTop,
    LLJControlViewTypeLeft,
    LLJControlViewTypeBottom,
    LLJControlViewTypeRight,
    LLJControlViewTypeCenter
};


typedef NS_ENUM(NSUInteger, LLJAddsubViewType) {
    LLJAddsubViewTypeLeftOrTop,
    LLJAddsubViewTypeCenter,
    LLJAddsubViewTypeRightOrBottom,
    LLJAddsubViewTypeLeftAndRight
};

NS_ASSUME_NONNULL_BEGIN

@interface LLJControlView : UIView

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSArray *leftOrTopSubViewArray;
@property (nonatomic, strong) NSArray *centerSubViewArray;
@property (nonatomic, strong) NSArray *rightOrBottomSubViewArray;
@property (nonatomic, strong) NSArray *leftAndRightSubViewArray;

@property (nonatomic, strong) LLJVideoPlayModel *model;
@property (nonatomic) LLJControlViewType type;
@property (nonatomic) BOOL allwaysHidden;
@property (nonatomic) BOOL rotateToFullScreen;
@property (nonatomic) BOOL viewHidden;


- (instancetype)initWithPlayerModel:(LLJVideoPlayModel *)model type:(LLJControlViewType)type;

- (void)addSubview:(UIView *)subView addType:(LLJAddsubViewType)type subViewSize:(CGSize)size subViewLeftOrTopSpace:(CGFloat)leftSpace subViewRightOrBottomSpace:(CGFloat)rightSpace centerOffset:(CGFloat)offset;

- (void)insertSubview:(UIView *)subView addType:(LLJAddsubViewType)type atIndex:(NSInteger)index subViewSize:(CGSize)size subViewLeftOrTopSpace:(CGFloat)leftSpace subViewRightOrBottomSpace:(CGFloat)rightSpace centerOffset:(CGFloat)offset;

- (void)layoutSubview:(LLJAddsubViewType)type;

- (void)setUpanimateHiddenSmallScreenFrame:(LLJControlViewSubViewModel *)model type:(LLJControlViewType)type;

- (void)removeSubview:(UIView *)subView;

- (void)viewHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
