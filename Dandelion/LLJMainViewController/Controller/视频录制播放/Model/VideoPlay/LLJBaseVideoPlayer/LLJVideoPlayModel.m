//
//  LLJVideoPlayModel.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/26.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJVideoPlayModel.h"
#import "AppDelegate+RotateHelper.h"

@implementation LLJVideoPlayModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isAutoPlay  = YES;
        self.isLocalM3U8 = NO;
        self.rotateScreenWhenRotateToFullView = YES;
        self.isBrightAdjustmentAllowedSmallScreen = YES;
        self.isVolumeAdjustmentAllowedSmallScreen = YES;
        self.isSliderAdjustmentAllowedSmallScreen = YES;
    }
    return self;
}

- (void)setrotateScreenWhenRotateToFullView:(BOOL)rotateScreenWhenRotateToFullView {
    
    _rotateScreenWhenRotateToFullView = rotateScreenWhenRotateToFullView;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (rotateScreenWhenRotateToFullView) {
        delegate.orientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
    }else{
        delegate.orientationMask = UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)isCurrentFullScreen {
    
    if(!self.rotateScreenWhenRotateToFullView) {
        if (ceilf(self.playerBounds.size.height) == SCREEN_WIDTH) {
            return YES;
        }else{
            NSLog(@"SCREEN_HEIGHT = %f,%f",SCREEN_WIDTH,self.playerBounds.size.height);
            return NO;
        }
    }else {
        if (ceilf(self.playerBounds.size.width) == (SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT : SCREEN_WIDTH)) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
