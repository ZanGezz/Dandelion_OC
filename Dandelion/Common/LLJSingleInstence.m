//
//  LLJSingleInstence.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/24.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJSingleInstence.h"
#import <CoreData/CoreData.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LLJSingleInstence ()

@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UISlider *volumeSlider;


@end

@implementation LLJSingleInstence


/**
 *  创建单例
 */
+ (LLJSingleInstence *)shareInstance
{
    static LLJSingleInstence *_instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[LLJSingleInstence alloc] init];
    }) ;
    return _instance;
}

/**
 *  懒加载系统音量view
 */
- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc]init];
        _volumeView.showsRouteButton = NO;
        //默认YES，这里为了突出，故意设置一遍
        _volumeView.showsVolumeSlider = YES;
        [_volumeView sizeToFit];
        [_volumeView setFrame:CGRectMake(-1000, -1000, 10, 10)];

        [kRootView addSubview:_volumeView];
        [_volumeView userActivity];
    }
    return _volumeView;
}
- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        for (UIView *view in [self.volumeView subviews]){
            if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
                _volumeSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeSlider;
}

/**
 *  设置系统音量
 */
- (void)setVolumeValue:(CGFloat)volumeValue {
    [self.volumeSlider setValue:volumeValue];
}

/**
 *  获取系统音量
 */
- (CGFloat)volumeValue {
    return self.volumeSlider.value;
}

@end
