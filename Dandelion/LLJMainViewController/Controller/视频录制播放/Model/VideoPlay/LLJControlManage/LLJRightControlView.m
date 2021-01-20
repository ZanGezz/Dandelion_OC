//
//  LLJRightControlView.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJRightControlView.h"

@interface LLJRightControlView ()

@property (nonatomic, strong) UIView *lastLeftOrTopView;
@property (nonatomic, strong) UIView *lastRightOrBottomView;

@end

@implementation LLJRightControlView

- (instancetype)initWithPlayerModel:(LLJVideoPlayModel *)model {
    self = [super initWithPlayerModel:model type:LLJControlViewTypeRight];
    if (self) {
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
                        
                        subViewFrame.origin.y = model.subViewLeftOrTopSpace;
                        subViewFrame.origin.x = (superViewFrame.size.width - model.subViewSize.width)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;

                    }else {
                        
                        subViewFrame.origin.y = self.lastLeftOrTopView.frame.origin.y + self.lastLeftOrTopView.frame.size.height + model.subViewLeftOrTopSpace;
                        subViewFrame.origin.x = (superViewFrame.size.height - model.subViewSize.height)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;
                    }
                    model.subView.frame = subViewFrame;
                    self.lastLeftOrTopView = model.subView;
                    [self setUpanimateHiddenSmallScreenFrame:model type:LLJControlViewTypeRight];
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
                    subViewFrame.origin.y = (superViewFrame.size.height - model.subViewSize.height)/2.0;
                    subViewFrame.origin.x = (superViewFrame.size.width - model.subViewSize.width)/2 - model.centerOffset;
                    subViewFrame.size = model.subViewSize;
                    model.subView.frame = subViewFrame;
                    [self setUpanimateHiddenSmallScreenFrame:model type:LLJControlViewTypeRight];
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
                        subViewFrame.origin.y = superViewFrame.size.height - model.subViewSize.height - model.subViewRightOrBottomSpace;
                        subViewFrame.origin.x = (superViewFrame.size.width - model.subViewSize.width)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;
                    }else {
                        
                        subViewFrame.origin.y = self.lastRightOrBottomView.frame.origin.y - model.subViewSize.height - model.subViewRightOrBottomSpace;
                        subViewFrame.origin.x = (superViewFrame.size.width - model.subViewSize.width)/2 - model.centerOffset;
                        subViewFrame.size = model.subViewSize;
                    }
                    model.subView.frame = subViewFrame;
                    self.lastRightOrBottomView = model.subView;
                    [self setUpanimateHiddenSmallScreenFrame:model type:LLJControlViewTypeRight];

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
                subViewFrame.origin.y = self.lastLeftOrTopView.frame.origin.y + self.lastLeftOrTopView.frame.size.height + model.subViewLeftOrTopSpace;
                subViewFrame.origin.x = (superViewFrame.size.width - model.subViewSize.width)/2 - model.centerOffset;
                subViewFrame.size.height = superViewFrame.size.height - subViewFrame.origin.y - (superViewFrame.size.height - self.lastRightOrBottomView.frame.origin.y + model.subViewRightOrBottomSpace);
                subViewFrame.size.width = model.subViewSize.width;
                model.subView.frame = subViewFrame;
                [self setUpanimateHiddenSmallScreenFrame:model type:LLJControlViewTypeRight];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}
@end
