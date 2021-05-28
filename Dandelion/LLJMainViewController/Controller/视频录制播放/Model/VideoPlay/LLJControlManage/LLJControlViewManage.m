//
//  LLJControlViewManage.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/27.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJControlViewManage.h"

@interface LLJControlViewManage ()

@property (nonatomic) BOOL hasRotatedViewFullScreen;
@property (nonatomic) BOOL hasRotatedScreenFullScreen;
@property (nonatomic, strong) LLJVideoPlayModel *model;

@end

@implementation LLJControlViewManage


- (instancetype)initWithPlayerModel:(LLJVideoPlayModel *)model{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - set 和 get 方法实现 -
- (void)setTopViewAlwaysHidden:(BOOL)topViewAlwaysHidden {
    
    _topViewAlwaysHidden = topViewAlwaysHidden;
    _topView.allwaysHidden = topViewAlwaysHidden;
}

- (void)setLeftViewAlwaysHidden:(BOOL)leftViewAlwaysHidden {
    _leftViewAlwaysHidden = leftViewAlwaysHidden;
    _leftView.allwaysHidden = leftViewAlwaysHidden;
}
- (void)setBottomViewAlwaysHidden:(BOOL)bottomViewAlwaysHidden {
    _bottomViewAlwaysHidden = bottomViewAlwaysHidden;
    _bottomView.allwaysHidden = bottomViewAlwaysHidden;
}
- (void)setRightViewAlwaysHidden:(BOOL)rightViewAlwaysHidden {
    _rightViewAlwaysHidden = rightViewAlwaysHidden;
    _rightView.allwaysHidden = rightViewAlwaysHidden;
}

- (BOOL)isCurrentControlViewAllHidden {
    
    if (self.topView.viewHidden && self.bottomView.viewHidden && self.leftView.viewHidden && self.rightView.viewHidden) {
        return YES;
    }else {
        return NO;
    }
}

- (void)subViewRemoveFormSuperView {
    
    [self.topView removeFromSuperview];
    [self.leftView removeFromSuperview];
    [self.rightView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    [self.centerView removeFromSuperview];
}

- (void)controlViewHidden:(BOOL)hidden{
    
    [self.topView viewHidden:hidden];
    [self.leftView viewHidden:hidden];
    [self.bottomView viewHidden:hidden];
    [self.rightView viewHidden:hidden];
    
    if (!self.centerView.isHidden) {
        [self.centerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark - 旋转屏幕 -
- (void)rotateScreen:(BOOL)toFull {
    
    //更新控制层frame
    self.topView.frame = [self getFrameWithWiew:self.topView isHidden:self.topView.viewHidden isFullScreen:toFull];
    self.bottomView.frame = [self getFrameWithWiew:self.bottomView isHidden:self.bottomView.viewHidden isFullScreen:toFull];
    self.leftView.frame = [self getFrameWithWiew:self.leftView isHidden:self.leftView.viewHidden isFullScreen:toFull];
    self.rightView.frame = [self getFrameWithWiew:self.rightView isHidden:self.rightView.viewHidden isFullScreen:toFull];
    self.centerView.frame = [self getFrameWithWiew:self.centerView isHidden:self.centerView.viewHidden isFullScreen:toFull];
    
    //更新layer frame
    self.topView.gradientLayer.frame = self.topView.bounds;
    self.bottomView.gradientLayer.frame = self.bottomView.bounds;
    self.leftView.gradientLayer.frame = self.leftView.bounds;
    self.rightView.gradientLayer.frame = self.rightView.bounds;
    self.centerView.gradientLayer.frame = self.centerView.bounds;
    
    //更新控制层子视图frame
    [self layoutSubview:self.topView toFull:toFull];
    [self layoutSubview:self.bottomView toFull:toFull];
    [self layoutSubview:self.leftView toFull:toFull];
    [self layoutSubview:self.rightView toFull:toFull];
    [self layoutSubview:self.centerView toFull:toFull];
    
    //是否全屏过，全屏过表示全屏的frame已经被计算出，下次可以直接设置frame
    if (toFull && self.model.rotateScreenWhenRotateToFullView) {
        self.hasRotatedScreenFullScreen = YES;
    }
    if (toFull && !self.model.rotateScreenWhenRotateToFullView) {
        self.hasRotatedViewFullScreen = YES;
    }
}
- (void)layoutSubview:(UIView *)superView toFull:(BOOL)toFull {
    
    LLJControlView *view = (LLJControlView *)superView;
    view.rotateToFullScreen = toFull;
    if (toFull) {
        if (self.hasRotatedScreenFullScreen && self.model.rotateScreenWhenRotateToFullView) {
            view.frame = view.animateCommenFullScreenFrame;
            for (UIView *subview in view.subviews) {
                subview.frame = subview.animateCommenFullScreenFrame;
            }
        }else if (self.hasRotatedViewFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
            view.frame = view.animateCommenRotateViewFullScreenFrame;
            for (UIView *subview in view.subviews) {
                subview.frame = subview.animateCommenRotateViewFullScreenFrame;
            }
        }else{
            [view layoutSubview:LLJAddsubViewTypeLeftOrTop];
            [view layoutSubview:LLJAddsubViewTypeCenter];
            [view layoutSubview:LLJAddsubViewTypeRightOrBottom];
            [view layoutSubview:LLJAddsubViewTypeLeftAndRight];
        }
    }else{
        view.frame = view.animateCommenSmallScreenFrame;
        for (UIView *subview in view.subviews) {
            subview.frame = subview.animateCommenSmallScreenFrame;
        }
    }
}
    
- (CGRect)getFrameWithWiew:(UIView *)view isHidden:(BOOL)isHidden isFullScreen:(BOOL)isFullScreen{
    
    if (isHidden) {
        if (isFullScreen) {
            return view.animateHiddenFullScreenFrame;
        }else{
            return view.animateHiddenSmallScreenFrame;
        }
    }else{
        if (isFullScreen) {

            return view.animateCommenFullScreenFrame;
        }else{

            return view.animateCommenSmallScreenFrame;
        }
    }
}

#pragma mark - 懒加载 -
- (LLJTopControlView *)topView{
    if (!_topView) {
        _topView = [[LLJTopControlView alloc]initWithPlayerModel:self.model];
    }
    return _topView;
}
- (LLJLeftControlView *)leftView{
    if (!_leftView) {
        _leftView = [[LLJLeftControlView alloc]initWithPlayerModel:self.model];
    }
    return _leftView;
}
- (LLJBottomControlView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[LLJBottomControlView alloc]initWithPlayerModel:self.model];
    }
    return _bottomView;
}
- (LLJRightControlView *)rightView{
    if (!_rightView) {
        _rightView = [[LLJRightControlView alloc]initWithPlayerModel:self.model];
    }
    return _rightView;
}
- (LLJCenterControlView *)centerView{
    if (!_centerView) {
        _centerView = [[LLJCenterControlView alloc]initWithPlayerModel:self.model];
    }
    return _centerView;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
