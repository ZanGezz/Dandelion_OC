//
//  LLJVideoController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/20.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJVideoController.h"
#import "LLJVideoPlayController.h"
#import "LLJVideoRecordController.h"

@interface LLJVideoController ()

@end

@implementation LLJVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)setUpUI {

    UIButton *pause = [UIButton buttonWithType:UIButtonTypeCustom];
    pause.backgroundColor = LLJBlackColor;
    pause.layer.masksToBounds = YES;
    pause.layer.cornerRadius = 4.0;
    [pause setTitleColor:LLJWhiteColor forState:UIControlStateNormal];
    pause.titleLabel.font = LLJBoldFont(14);
    [pause setTitle:@"视频录制" forState:UIControlStateNormal];
    [pause addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pause];
    [pause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(-30);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];

    UIButton *resume = [UIButton buttonWithType:UIButtonTypeCustom];
    resume.backgroundColor = LLJBlackColor;
    resume.layer.masksToBounds = YES;
    resume.layer.cornerRadius = 4.0;
    [resume setTitleColor:LLJWhiteColor forState:UIControlStateNormal];
    resume.titleLabel.font = LLJBoldFont(14);
    [resume setTitle:@"视频播放" forState:UIControlStateNormal];
    [resume addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resume];
    [resume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(30);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - 按钮事件 -
- (void)record{
    LLJVideoRecordController *record = [[LLJVideoRecordController alloc]init];
    record.titleName = @"视频录制";
    [self.navigationController pushViewController:record animated:YES];
}
- (void)play{
    LLJVideoPlayController *play = [[LLJVideoPlayController alloc]init];
    play.titleName = @"视频播放";
    [self.navigationController pushViewController:play animated:YES];
}

@end
