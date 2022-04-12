//
//  LLJDefaultPlayerUI.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/3.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJDefaultPlayerUI.h"
#import "LLJSilderView.h"

@class LLJVideoPlayer;

@interface LLJDefaultPlayerUI ()

@property (nonatomic, strong) LLJVideoPlayModel *model;
@property (nonatomic, copy) LLJBrightView *brightView;
@property (nonatomic, copy) LLJBrightView *volumeView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) UIButton *fullScreen;
@property (nonatomic, strong) UIButton *rotation;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *currentTimeLabel;
@property (nonatomic, strong) UILabel  *totalTimeLabel;
@property (nonatomic, strong) LLJSilderView *slider;


@end

@implementation LLJDefaultPlayerUI

- (instancetype)initWithSuperView:(UIView *)superView model:(LLJVideoPlayModel *)model controlManage:(nonnull LLJControlViewManage *)manage{
    self = [super init];
    if (self) {
    
        self.model = model;
        [self addSubViews:manage toSuperView:superView];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)upDatePlayButtonStatus:(BOOL)videoPlaySucess {
    
    if (videoPlaySucess) {
        [self.startButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else {
        [self.startButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    }
    self.startButton.selected = !videoPlaySucess;
}

- (void)setCurrentTimeLabelText:(NSString *)currentTimeLabelText {
    _currentTimeLabelText = currentTimeLabelText;
    self.currentTimeLabel.text = currentTimeLabelText;
}
- (void)setTotalTimeLabelText:(NSString *)totalTimeLabelText {
    _totalTimeLabelText = totalTimeLabelText;
    self.totalTimeLabel.text = totalTimeLabelText;

}
- (void)setSliderValue:(CGFloat)sliderValue{
    _sliderValue = sliderValue;
    if (_sliderValue > 1.0) {
        _sliderValue = 1.0;
    }
    if (_sliderValue < 0.0) {
        _sliderValue = 0.0;
    }
    self.slider.value = sliderValue;
}
-(void)setLoadValue:(CGFloat)loadValue {
    _loadValue = loadValue;
    self.slider.progressValue = loadValue;
}

- (void)setVolumeValue:(CGFloat)volumeValue {
    
    _volumeValue = volumeValue;
    if (_volumeValue > 1.0) {
        _volumeValue = 1.0;
    }
    if (_volumeValue < 0.0) {
        _volumeValue = 0.0;
    }
    [self performSelector:@selector(brightHidden) withObject:nil afterDelay:0.0];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(volumeHidden) object:nil];
    _volumeView.hidden = NO;
    _volumeView.alpha = 1.0;
    [self updateVolumeViewTransForm];
    _volumeView.value = volumeValue;
    [LLJHelper setSystemVolume:volumeValue];
    [self performSelector:@selector(volumeHidden) withObject:nil afterDelay:2.0];
}
- (void)volumeHidden {

    [UIView animateWithDuration:0.35 animations:^{
        self->_volumeView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self->_volumeView.hidden = YES;
    }];
}

- (void)setBrightValue:(CGFloat)brightValue {
    
    _brightValue = brightValue;
    if (_brightValue > 1.0) {
        _brightValue = 1.0;
    }
    if (_brightValue < 0.0) {
        _brightValue = 0.0;
    }
    [self performSelector:@selector(volumeHidden) withObject:nil afterDelay:0.0];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(brightHidden) object:nil];
    _brightView.hidden = NO;
    _brightView.alpha = 1.0;
    [self updateVolumeViewTransForm];
    _brightView.value = brightValue;
    [LLJHelper setSystemBright:brightValue];
    [self performSelector:@selector(brightHidden) withObject:nil afterDelay:2.0];
}
- (void)brightHidden {
    
    [UIView animateWithDuration:0.35 animations:^{
        self->_brightView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self->_brightView.hidden = YES;
    }];
}

- (void)updateVolumeViewTransForm {
    _brightView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    _volumeView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [UIView animateWithDuration:0.35 animations:^{
        self->_brightView.transform = self.model.transform;
        self->_volumeView.transform = self.model.transform;
    }];
}


- (void)buttonClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 8001:{
            //返回按钮
            !self.backClick ?: self.backClick(sender);
        }
            break;
        case 8002:{
            //清晰度按钮
            !self.definiteClick ?: self.definiteClick(sender);
        }
            break;
        case 8003:{
            //播放速度
            !self.rateClick ?: self.rateClick(sender);
        }
            break;
        case 8004:{
            //播放
            if (sender.selected) {
                !self.playClick ?: self.playClick(sender);
            }else{
                !self.pauseClick ?: self.pauseClick(sender);
            }
        }
            break;
        case 8005:{
            //全屏
            !self.fullScreenClick ?: self.fullScreenClick(sender);
        }
            break;
        case 8006:{
            //解锁
            if (!sender.selected) {
                !self.lockClick ?: self.lockClick(sender);
                [self.lockButton setImage:[UIImage imageNamed:@"suo"] forState:UIControlStateNormal];

            }else{
                !self.unLockClick ?: self.unLockClick(sender);
                [self.lockButton setImage:[UIImage imageNamed:@"kaisuo"] forState:UIControlStateNormal];
            }
            sender.selected = !sender.selected;
        }
            break;
        case 8007:{
            //旋转
            !self.rotationClick ?: self.rotationClick(sender);
        }
        default:
            break;
    }
}

//开始滚动进度条
- (void)sliderBegan:(UISlider *)slider {
    !self.sliderBegin ?: self.sliderBegin(slider);
    NSLog(@"开始滚动进度条");
}
//滚动条持续滚动中
- (void)sliderMoving:(UISlider *)slider {
    !self.sliderMoving ?: self.sliderMoving(slider);
    NSLog(@"滚动条持续滚动中");
}
//滚动条结束滚动
- (void)sliderEnded:(UISlider *)slider {
    NSLog(@"滚动条结束滚动");
    !self.sliderEnd ?: self.sliderEnd(slider);
}

- (void)addSubViews:(LLJControlViewManage *)manage toSuperView:(UIView *)superView{
    
    //音量亮度
    _brightValue = [LLJHelper getSystemBright];
    _volumeValue = [LLJHelper getSystemVolume];
    [kRootView addSubview:self.brightView];
    [kRootView addSubview:self.volumeView];
    [self updateVolumeViewTransForm];
    
    //控制层
    [superView addSubview:manage.topView];
    [superView addSubview:manage.leftView];
    [superView addSubview:manage.bottomView];
    [superView addSubview:manage.rightView];
    [superView addSubview:manage.centerView];

    //top
    [manage.topView addSubview:self.backButton addType:LLJAddsubViewTypeLeftOrTop subViewSize:CGSizeMake(20, 20) subViewLeftOrTopSpace:15 subViewRightOrBottomSpace:0 centerOffset:0];
    [manage.topView addSubview:self.titleLabel addType:LLJAddsubViewTypeLeftOrTop subViewSize:CGSizeMake(100, 20) subViewLeftOrTopSpace:10 subViewRightOrBottomSpace:0 centerOffset:0];
    [manage.topView addSubview:self.moreButton addType:LLJAddsubViewTypeRightOrBottom subViewSize:CGSizeMake(40, 18) subViewLeftOrTopSpace:0 subViewRightOrBottomSpace:20 centerOffset:0];
    [manage.topView addSubview:self.shareButton addType:LLJAddsubViewTypeRightOrBottom subViewSize:CGSizeMake(40, 18) subViewLeftOrTopSpace:0 subViewRightOrBottomSpace:15 centerOffset:0];
    
    //left
    [manage.leftView addSubview:self.lockButton addType:LLJAddsubViewTypeCenter subViewSize:CGSizeMake(20, 20) subViewLeftOrTopSpace:0 subViewRightOrBottomSpace:0 centerOffset:0];
    
    //bottom
    [manage.bottomView addSubview:self.startButton addType:LLJAddsubViewTypeLeftOrTop subViewSize:CGSizeMake(20, 20) subViewLeftOrTopSpace:15 subViewRightOrBottomSpace:0 centerOffset:0];
    [manage.bottomView addSubview:self.currentTimeLabel addType:LLJAddsubViewTypeLeftOrTop subViewSize:CGSizeMake(55, 13) subViewLeftOrTopSpace:15 subViewRightOrBottomSpace:0 centerOffset:0];
    [manage.bottomView addSubview:self.fullScreen addType:LLJAddsubViewTypeRightOrBottom subViewSize:CGSizeMake(20, 20) subViewLeftOrTopSpace:0 subViewRightOrBottomSpace:15 centerOffset:0];
    [manage.bottomView addSubview:self.totalTimeLabel addType:LLJAddsubViewTypeRightOrBottom subViewSize:CGSizeMake(55, 13) subViewLeftOrTopSpace:0 subViewRightOrBottomSpace:15 centerOffset:0];
    
    [manage.bottomView addSubview:self.slider addType:LLJAddsubViewTypeLeftAndRight subViewSize:CGSizeMake(200, 30) subViewLeftOrTopSpace:10 subViewRightOrBottomSpace:10 centerOffset:0];
    
    //right 
    [manage.rightView addSubview:self.rotation addType:LLJAddsubViewTypeCenter subViewSize:CGSizeMake(20, 20) subViewLeftOrTopSpace:0 subViewRightOrBottomSpace:0 centerOffset:0];

}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.tag = 8001;
    }
    return _backButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitle:@"上一集" forState:UIControlStateNormal];
        _shareButton.layer.masksToBounds = YES;
        _shareButton.layer.cornerRadius = 2.0;
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _shareButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _shareButton.layer.borderWidth = 1.0;
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = 8002;
    }
    return _shareButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"下一集" forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moreButton.layer.masksToBounds = YES;
        _moreButton.layer.cornerRadius = 2.0;
        _moreButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _moreButton.layer.borderWidth = 1.0;
        [_moreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.tag = 8003;
    }
    return _moreButton;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _startButton.tag = 8004;
    }
    return _startButton;
}

- (UIButton *)fullScreen {
    if (!_fullScreen) {
        _fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreen setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
        [_fullScreen addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreen.tag = 8005;
    }
    return _fullScreen;
}

- (UIButton *)lockButton {
    if (!_lockButton) {
        _lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockButton setImage:[UIImage imageNamed:@"kaisuo"] forState:UIControlStateNormal];
        [_lockButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _lockButton.tag = 8006;
    }
    return _lockButton;
}

- (UIButton *)rotation {
    if (!_rotation) {
        _rotation = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rotation setImage:[UIImage imageNamed:@"xuanzhuan"] forState:UIControlStateNormal];
        [_rotation addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rotation.tag = 8007;
    }
    return _rotation;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00:00";
        _currentTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00:00";
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _totalTimeLabel;
}

- (LLJSilderView *)slider {
    if (!_slider) {
        _slider = [[LLJSilderView alloc]init];
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        _slider.minimumTrackTintColor = [UIColor orangeColor];
        [_slider setThumbImage:[UIImage imageNamed:@"yuandian"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderMoving:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(sliderBegan:) forControlEvents:UIControlEventTouchDown];
    }
    return _slider;
}

- (LLJBrightView *)brightView {
    if (!_brightView) {
        _brightView = [[LLJBrightView alloc]initWithBaseTag:3456];
        _brightView.initialValue = [LLJHelper getSystemBright];
        _brightView.hidden = YES;
    }
    return _brightView;
}

- (LLJBrightView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[LLJBrightView alloc]initWithBaseTag:6789];
        _volumeView.initialValue = [LLJHelper getSystemVolume];
        _volumeView.hidden = YES;
    }
    return _volumeView;
}

- (void)dealloc {
    
    _brightView = nil;
    _volumeView = nil;
    [LLJHelper setSystemVolume:self.volumeView.initialValue];
    [LLJHelper setSystemBright:self.brightView.initialValue];
    NSLog(@"class = %@",NSStringFromClass([self class]));
}

@end
