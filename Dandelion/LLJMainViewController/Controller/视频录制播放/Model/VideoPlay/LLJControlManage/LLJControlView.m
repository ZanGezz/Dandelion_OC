//
//  LLJControlView.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJControlView.h"
#import "LLJControlViewSubViewModel.h"

#define widthScale 0.12
#define heightScale 0.2

@interface LLJControlView ()<CAAnimationDelegate>

@end

@implementation LLJControlView

- (instancetype)initWithPlayerModel:(LLJVideoPlayModel *)model type:(LLJControlViewType)type{
    
    _model = model;
    _type = type;
    self = [super initWithFrame:[self getNewFrame:model.playerBounds type:type]];
    if (self) {
        self.layer.masksToBounds = YES;
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}

- (CGRect)getNewFrame:(CGRect)frame type:(LLJControlViewType)type{
    
    CGFloat x = 0.0,y = 0.0,w = 0.0,h = 0.0;
    
    switch (type) {
        case LLJControlViewTypeTop:
        {
            x = 0.0;
            y = 0.0;
            w = frame.size.width;
            h = frame.size.height *heightScale;
            self.animateHiddenSmallScreenFrame = CGRectMake(x, y, w, 0);
            self.animateCommenFullScreenFrame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH *heightScale);
            self.animateHiddenFullScreenFrame = CGRectMake(0, 0, SCREEN_HEIGHT, 0);
            self.animateCommenRotateViewFullScreenFrame = self.animateCommenFullScreenFrame;
            self.animateHiddenRotateViewFullScreenFrame = self.animateHiddenFullScreenFrame;

        }
            break;
        case LLJControlViewTypeLeft:
        {
            x = 0.0;
            y = frame.size.height *heightScale;
            w = frame.size.width *widthScale;
            h = frame.size.height *(1 - heightScale*2);
            self.animateHiddenSmallScreenFrame = CGRectMake(x, y, 0, h);
            self.animateCommenFullScreenFrame = CGRectMake(0, SCREEN_WIDTH *heightScale, SCREEN_HEIGHT*widthScale, SCREEN_WIDTH *(1 - heightScale*2));
            self.animateHiddenFullScreenFrame = CGRectMake(0, SCREEN_WIDTH *heightScale, 0, SCREEN_WIDTH *(1 - heightScale*2));
            self.animateCommenRotateViewFullScreenFrame = self.animateCommenFullScreenFrame;
            self.animateHiddenRotateViewFullScreenFrame = self.animateHiddenFullScreenFrame;

        }
            break;
        case LLJControlViewTypeBottom:
        {
            x = 0.0;
            y = frame.size.height * (1 - heightScale);
            w = frame.size.width;
            h = frame.size.height * heightScale;
            self.animateHiddenSmallScreenFrame = CGRectMake(x, y+h, w, 0);
            self.animateCommenFullScreenFrame = CGRectMake(0, SCREEN_WIDTH *(1 - heightScale), SCREEN_HEIGHT, SCREEN_WIDTH *heightScale);
            self.animateHiddenFullScreenFrame = CGRectMake(0, SCREEN_WIDTH, SCREEN_HEIGHT, 0);
            self.animateCommenRotateViewFullScreenFrame = self.animateCommenFullScreenFrame;
            self.animateHiddenRotateViewFullScreenFrame = self.animateHiddenFullScreenFrame;
        }
            break;
        case LLJControlViewTypeRight:
        {
            x = frame.size.width *(1 - widthScale);
            y = frame.size.height *heightScale;
            w = frame.size.width *widthScale;
            h = frame.size.height *(1 - heightScale*2);
            self.animateHiddenSmallScreenFrame = CGRectMake(x+w, y, 0, h);
            self.animateCommenFullScreenFrame = CGRectMake(SCREEN_HEIGHT*(1 - widthScale), SCREEN_WIDTH *heightScale, SCREEN_HEIGHT*widthScale, SCREEN_WIDTH *(1 - 2*heightScale));
            self.animateHiddenFullScreenFrame = CGRectMake(SCREEN_HEIGHT, SCREEN_WIDTH *heightScale, 0, SCREEN_WIDTH *(1 - 2*heightScale));
            self.animateCommenRotateViewFullScreenFrame = self.animateCommenFullScreenFrame;
            self.animateHiddenRotateViewFullScreenFrame = self.animateHiddenFullScreenFrame;
        }
            break;
        case LLJControlViewTypeCenter:
        {
            x = frame.size.width *widthScale;
            y = frame.size.height *heightScale;
            w = frame.size.width *(1-widthScale*2);
            h = frame.size.height *(1 - heightScale*2);
            self.animateHiddenSmallScreenFrame = CGRectMake(x, y, w, h);
            self.animateCommenFullScreenFrame = CGRectMake(SCREEN_HEIGHT*widthScale, SCREEN_WIDTH *heightScale, SCREEN_HEIGHT*(1 - 2*widthScale), SCREEN_WIDTH *(1 - 2*heightScale));
            self.animateHiddenFullScreenFrame = CGRectMake(SCREEN_HEIGHT*widthScale, SCREEN_WIDTH *heightScale, SCREEN_HEIGHT*(1 - 2*widthScale), SCREEN_WIDTH *(1 - 2*heightScale));
            self.animateCommenRotateViewFullScreenFrame = self.animateCommenFullScreenFrame;
            self.animateHiddenRotateViewFullScreenFrame = self.animateHiddenFullScreenFrame;
        }
            break;
            
        default:
            break;
    }
    self.animateCommenSmallScreenFrame = CGRectMake(x, y, w, h);
    
    if (self.allwaysHidden || self.model.hiddenControlViewWhenEnterPlayer) {
        return self.animateHiddenSmallScreenFrame;
    }else{
        return self.animateCommenSmallScreenFrame;
    }
}

- (void)setUpanimateHiddenSmallScreenFrame:(LLJControlViewSubViewModel *)model type:(LLJControlViewType)type {
    
    [self layoutIfNeeded];
    
    if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
        model.subView.animateCommenFullScreenFrame = model.subView.frame;
    }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
        model.subView.animateCommenRotateViewFullScreenFrame = model.subView.frame;
    }else{
        model.subView.animateCommenSmallScreenFrame = model.subView.frame;
    }
    switch (type) {
        case LLJControlViewTypeTop:
        {
            CGRect frame = model.subView.frame;
            frame.origin.y = 0;
            frame.size.height = 0;
            if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenFullScreenFrame = frame;
            }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenRotateViewFullScreenFrame = frame;
            }else{
                model.subView.animateHiddenSmallScreenFrame = frame;
            }
        }
            break;
        case LLJControlViewTypeLeft:
        {
            CGRect frame = model.subView.frame;
            frame.origin.x = 0;
            frame.size.width = 0;
            if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenFullScreenFrame = frame;
            }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenRotateViewFullScreenFrame = frame;
            }else{
                model.subView.animateHiddenSmallScreenFrame = frame;
            }
        }
            break;
        case LLJControlViewTypeBottom:
        {
            CGRect frame = model.subView.frame;
            frame.origin.y = self.animateHiddenSmallScreenFrame.size.height;
            frame.size.height = 0;
            if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenFullScreenFrame = frame;
            }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenRotateViewFullScreenFrame = frame;
            }else{
                model.subView.animateHiddenSmallScreenFrame = frame;
            }
        }
            break;
        case LLJControlViewTypeRight:
        {
            CGRect frame = model.subView.frame;
            frame.origin.x = self.animateHiddenSmallScreenFrame.size.width;
            frame.size.width = 0;
            if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenFullScreenFrame = frame;
            }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                model.subView.animateHiddenRotateViewFullScreenFrame = frame;
            }else{
                model.subView.animateHiddenSmallScreenFrame = frame;
            }
        }
            break;
            
        default:
            break;
    }
    
    [self viewHidden:self.viewHidden];
}

- (void)insertSubview:(UIView *)subView addType:(LLJAddsubViewType)type atIndex:(NSInteger)index subViewSize:(CGSize)size subViewLeftOrTopSpace:(CGFloat)leftSpace subViewRightOrBottomSpace:(CGFloat)rightSpace centerOffset:(CGFloat)offset {
    
    NSMutableArray *array;
    LLJControlViewSubViewModel *model = [[LLJControlViewSubViewModel alloc]init];
    model.subView = subView;
    model.subViewSize = size;
    model.subViewLeftOrTopSpace = leftSpace;
    model.subViewRightOrBottomSpace = rightSpace;
    model.centerOffset = offset;
    
    switch (type) {
        case LLJAddsubViewTypeLeftOrTop:
        {
            array = [NSMutableArray arrayWithArray:self.leftOrTopSubViewArray];
            [array insertObject:model atIndex:index];
            self.leftOrTopSubViewArray = array;
        }
            break;
        case LLJAddsubViewTypeCenter:
        {
            array = [NSMutableArray arrayWithArray:self.centerSubViewArray];
            [array insertObject:model atIndex:index];
            self.centerSubViewArray = array;
        }
            break;
        case LLJAddsubViewTypeRightOrBottom:
        {
            array = [NSMutableArray arrayWithArray:self.rightOrBottomSubViewArray];
            [array insertObject:model atIndex:index];
            self.rightOrBottomSubViewArray = array;
        }
            break;
        case LLJAddsubViewTypeLeftAndRight:
        {
            array = [NSMutableArray arrayWithArray:self.leftAndRightSubViewArray];
            [array insertObject:model atIndex:index];
            self.leftAndRightSubViewArray = array;
        }
            break;
        default:
            break;
    }
}
- (void)addSubview:(UIView *)subView addType:(LLJAddsubViewType)type subViewSize:(CGSize)size subViewLeftOrTopSpace:(CGFloat)leftSpace subViewRightOrBottomSpace:(CGFloat)rightSpace centerOffset:(CGFloat)offset {
    
    NSInteger insertIndex = 0;
    switch (type) {
        case LLJAddsubViewTypeLeftOrTop:
        {
            insertIndex = self.leftOrTopSubViewArray.count;
        }
            break;
        case LLJAddsubViewTypeCenter:
        {
            insertIndex = self.centerSubViewArray.count;
        }
            break;
        case LLJAddsubViewTypeRightOrBottom:
        {
            insertIndex = self.rightOrBottomSubViewArray.count;
        }
            break;
        case LLJAddsubViewTypeLeftAndRight:
        {
            insertIndex = self.leftAndRightSubViewArray.count;
        }
            break;
        default:
            break;
    }
    [self insertSubview:subView addType:type atIndex:insertIndex subViewSize:size subViewLeftOrTopSpace:leftSpace subViewRightOrBottomSpace:rightSpace centerOffset:offset];
}

- (void)setAllwaysHidden:(BOOL)allwaysHidden {
        
    if (allwaysHidden) {
        [self viewHidden:allwaysHidden];
        _allwaysHidden = allwaysHidden;
    }else{
        _allwaysHidden = allwaysHidden;
        [self viewHidden:allwaysHidden];
    }
}

- (void)viewHidden:(BOOL)isHidden{
    
    if (!self.allwaysHidden) {
        if (isHidden) {
            
            [UIView animateWithDuration:0.35 animations:^{
                if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                    self.frame = self.animateHiddenFullScreenFrame;
                }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                    self.frame = self.animateHiddenRotateViewFullScreenFrame;
                }else{
                    self.frame = self.animateHiddenSmallScreenFrame;
                }
                for (UIView *subview in self.subviews) {
                    if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                        subview.frame = subview.animateHiddenFullScreenFrame;
                    }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                        subview.frame = subview.animateHiddenRotateViewFullScreenFrame;
                    }else{
                        subview.frame = subview.animateHiddenSmallScreenFrame;
                    }
                    subview.alpha = 0.0;
                }
            } completion:^(BOOL finished) {
            
            }];
            
        }else{
        
            [UIView animateWithDuration:0.35 animations:^{
                if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                    self.frame = self.animateCommenFullScreenFrame;
                }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                    self.frame = self.animateCommenRotateViewFullScreenFrame;
                }else{
                    self.frame = self.animateCommenSmallScreenFrame;
                }
                for (UIView *subview in self.subviews) {
                    if (self.rotateToFullScreen && self.model.rotateScreenWhenRotateToFullView) {
                        subview.frame = subview.animateCommenFullScreenFrame;
                    }else if (self.rotateToFullScreen && !self.model.rotateScreenWhenRotateToFullView) {
                        subview.frame = subview.animateCommenRotateViewFullScreenFrame;
                    }else{
                        subview.frame = subview.animateCommenSmallScreenFrame;
                    }
                    subview.alpha = 1.0;
                }
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    self.viewHidden = self.allwaysHidden ? self.allwaysHidden : isHidden;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
