//
//  LLJCenterControlView.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/5.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJCenterControlView.h"

@interface LLJCenterControlView ()

@property (nonatomic, strong) UIView *lastLeftOrTopView;
@property (nonatomic, strong) UIView *lastRightOrBottomView;

@end

@implementation LLJCenterControlView

- (instancetype)initWithPlayerModel:(LLJVideoPlayModel *)model {
    self = [super initWithPlayerModel:model type:LLJControlViewTypeCenter];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)insertSubview:(UIView *)subView addType:(LLJAddsubViewType)type atIndex:(NSInteger)index subViewSize:(CGSize)size subViewLeftOrTopSpace:(CGFloat)leftSpace subViewRightOrBottomSpace:(CGFloat)rightSpace centerOffset:(CGFloat)offset {
    
    [super insertSubview:subView addType:type atIndex:index subViewSize:size subViewLeftOrTopSpace:leftSpace subViewRightOrBottomSpace:rightSpace centerOffset:offset];
    
    [self layoutSubview:type];
}

- (void)layoutSubview:(LLJAddsubViewType)type {
    
    CGRect superViewFrame;
    if (self.model.isCurrentFullScreen) {
        if (self.model.rotateScreenWhenRotateToFullView) {
            superViewFrame = self.animateCommenFullScreenFrame;
        }else{
            superViewFrame = self.animateCommenRotateViewFullScreenFrame;
        }
    }else{
        superViewFrame = self.animateCommenSmallScreenFrame;
    }
    
    switch (type) {
        case LLJAddsubViewTypeLeftOrTop:
        {
            //先移除子视图
            for (LLJControlViewSubViewModel *model in self.leftOrTopSubViewArray) {
                [model.subView removeFromSuperview];
            }
            //重新添加新视图
            for (int i = 0; i < self.leftOrTopSubViewArray.count; i ++) {
                
                LLJControlViewSubViewModel *model = self.leftOrTopSubViewArray[i];
                
                if (model.subView) {
                    [self addSubview:model.subView];
                    CGRect subViewFrame;
                    if (i == 0) {
                        
                        subViewFrame.origin.x = model.subViewLeftOrTopSpace;
                        subViewFrame.origin.y = (superViewFrame.size.height - model.subViewSize.height)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;

                    }else {
                        
                        subViewFrame.origin.x = self.lastLeftOrTopView.frame.origin.x + self.lastLeftOrTopView.frame.size.width + model.subViewLeftOrTopSpace;
                        subViewFrame.origin.y = (superViewFrame.size.height - model.subViewSize.height)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;
                    }
                    model.subView.frame = subViewFrame;
                    self.lastLeftOrTopView = model.subView;
                }
            }
        }
            break;
        case LLJAddsubViewTypeCenter:
        {
            //先移除子视图
            for (LLJControlViewSubViewModel *model in self.centerSubViewArray) {
                [model.subView removeFromSuperview];
            }
            //重新添加新视图
            for (int i = 0; i < self.centerSubViewArray.count; i ++) {
                
                LLJControlViewSubViewModel *model = self.centerSubViewArray[i];
                if (model.subView) {
                    [self addSubview:model.subView];
                    CGRect subViewFrame;
                    subViewFrame.origin.x = (superViewFrame.size.width - model.subViewSize.width)/2.0;
                    subViewFrame.origin.y = (superViewFrame.size.height - model.subViewSize.height)/2 - model.centerOffset;
                    subViewFrame.size = model.subViewSize;
                    model.subView.frame = subViewFrame;
                }
            }
        }
            break;
        case LLJAddsubViewTypeRightOrBottom:
        {
            //先移除子视图
            for (LLJControlViewSubViewModel *model in self.rightOrBottomSubViewArray) {
                [model.subView removeFromSuperview];
            }
            //重新添加新视图
            for (int i = 0; i < self.rightOrBottomSubViewArray.count; i ++) {
                
                LLJControlViewSubViewModel *model = self.rightOrBottomSubViewArray[i];
                
                if (model.subView) {
                    [self addSubview:model.subView];
                    CGRect subViewFrame;
                    if (i == 0) {
                        subViewFrame.origin.x = superViewFrame.size.width - model.subViewSize.width - model.subViewRightOrBottomSpace;
                        subViewFrame.origin.y = (superViewFrame.size.height - model.subViewSize.height)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;
                    }else {
                        
                        subViewFrame.origin.x = self.lastRightOrBottomView.frame.origin.x - model.subViewSize.width - model.subViewRightOrBottomSpace;
                        subViewFrame.origin.y = (superViewFrame.size.height - model.subViewSize.height)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;
                    }
                    model.subView.frame = subViewFrame;
                    self.lastRightOrBottomView = model.subView;
                }
            }
        }
            break;
        case LLJAddsubViewTypeLeftAndRight:
        {
            //先移除子视图
            for (LLJControlViewSubViewModel *model in self.leftAndRightSubViewArray) {
                [model.subView removeFromSuperview];
            }
            //重新添加新视图
            LLJControlViewSubViewModel *model = self.leftAndRightSubViewArray.firstObject;
            
            if (model.subView) {
                [self addSubview:model.subView];
                CGRect subViewFrame;
                subViewFrame.origin.x = self.lastLeftOrTopView.frame.origin.x + self.lastLeftOrTopView.frame.size.width + model.subViewLeftOrTopSpace;
                subViewFrame.origin.y = (superViewFrame.size.height - model.subViewSize.height)/2 - model.centerOffset;
                subViewFrame.size.width = superViewFrame.size.width - subViewFrame.origin.x - (superViewFrame.size.width - self.lastRightOrBottomView.frame.origin.x + model.subViewRightOrBottomSpace);
                subViewFrame.size.height = model.subViewSize.height;
                model.subView.frame = subViewFrame;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)viewHidden:(BOOL)isHidden {
    
    if (isHidden) {
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
    }
    self.hidden = isHidden;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
