//
//  LLJGesManage.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/11.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJGesManage.h"

@interface LLJGesManage ()<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat lastPan_s;
@property (nonatomic) CGFloat newPan_s;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) LLJVideoPlayModel *model;
@property (nonatomic)         LLJGesClickType    type;

@end

@implementation LLJGesManage

#pragma mark - 初始化 -
- (instancetype)initWithTapView:(UIView *)tapView model:(LLJVideoPlayModel *)model {
    self = [super init];
    if (self) {
        
        self.newPan_s = 0.0;
        self.lastPan_s = 0.0;
        self.model = model;
        self.tapView = tapView;
        self.pan_base_s = 300;
        [self addMyGestureRecognizer];
    }
    return self;
}
- (void)addMyGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.tapView addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.tapView addGestureRecognizer:tapOnce];
    
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tapOnce.numberOfTapsRequired = 2;
    [self.tapView addGestureRecognizer:tapTwice];
    //双击时取消单击
    [tapTwice requireGestureRecognizerToFail:tapOnce];
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    if (tap.numberOfTapsRequired == 2) {
        //双击
        self.type = LLJGesClickTypeTapTwice;
    }else{
        //单击
        self.type = LLJGesClickTypeTapOnce;
    }
    !self.gesClick ?: self.gesClick(self.type,tap.state,0.0,0.0);
}
- (void)pan:(UIPanGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {

    }else if (ges.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [ges translationInView:self.tapView];
        CGPoint location = [ges locationInView:self.tapView];
        
        if (fabs(point.x) < fabs(point.y)) {
            
            if (location.x < self.tapView.bounds.size.width/2.0){
                //左侧亮度
                if (!self.model.isBrightAdjustmentAllowedSmallScreen && !self.model.isCurrentFullScreen) {
                    return;
                }
                self.newPan_s = -point.y;
                self.type = LLJGesClickTypePanLeftAndVertical;

            }else{
                //右侧音量
                if (!self.model.isVolumeAdjustmentAllowedSmallScreen && !self.model.isCurrentFullScreen) {
                    return;
                }
                self.newPan_s = -point.y;
                self.type = LLJGesClickTypePanRightAndVertical;
            }
        }else{
            //水平进度
            if (!self.model.isSliderAdjustmentAllowedSmallScreen && !self.model.isCurrentFullScreen) {
                return;
            }
            self.newPan_s = point.x;
            self.type = LLJGesClickTypePanHorizontal;

        }
        !self.gesClick ?: self.gesClick(self.type,ges.state,self.newPan_s/self.pan_base_s,(self.newPan_s-self.lastPan_s)/self.pan_base_s);
        self.lastPan_s = self.newPan_s;
        
    }else if (ges.state == UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateFailed){

        switch (self.type) {
            case LLJGesClickTypePanLeftAndVertical:
            {
                if (!self.model.isBrightAdjustmentAllowedSmallScreen && !self.model.isCurrentFullScreen) {
                    return;
                }
            }
            case LLJGesClickTypePanRightAndVertical:
            {
                if (!self.model.isVolumeAdjustmentAllowedSmallScreen && !self.model.isCurrentFullScreen) {
                    return;
                }
            }
                break;
            case LLJGesClickTypePanHorizontal:
            {
                if (!self.model.isSliderAdjustmentAllowedSmallScreen && !self.model.isCurrentFullScreen) {
                    return;
                }
            }
                break;
                
            default:
                break;
        }
        
        if (ges.state == UIGestureRecognizerStateEnded) {
            !self.gesClick ?: self.gesClick(self.type,ges.state,-self.newPan_s/self.pan_base_s,-(self.newPan_s-self.lastPan_s)/self.pan_base_s);
        }
        self.newPan_s = 0.0;
        self.lastPan_s = 0.0;
    }
}

@end
