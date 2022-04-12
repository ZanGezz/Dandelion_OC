//
//  LLJVideoRecordController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/6/8.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJVideoRecordController.h"
#import <AVFoundation/AVFoundation.h>
#import "LLJRecordManage.h"

@interface LLJVideoRecordController ()

@property (nonatomic, strong) LLJRecordManage *recordManage;

@end

@implementation LLJVideoRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)setUpUI {

    //进入页面隐藏状态栏
    self.hiddenStatusBarWhenPushIn = YES;
    //进入页面隐藏导航栏
    self.hiddenNavgationBarWhenPushIn = YES;
    
    [self creatVideoRecord];
}

#pragma mark - 创建录制工具 -
- (void)creatVideoRecord {
    
    UIView *preView = [[UIView alloc]init];
    preView.backgroundColor = [UIColor blackColor];
    preView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:preView];

    self.recordManage = [[LLJRecordManage alloc]initWithPreview:preView recordModel:[self getModel]];
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    start.backgroundColor = [UIColor redColor];
    [start setTitle:@"开始" forState:UIControlStateNormal];
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    [start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];


    UIButton *stop = [UIButton buttonWithType:UIButtonTypeCustom];
    stop.backgroundColor = [UIColor redColor];
    [stop setTitle:@"结束" forState:UIControlStateNormal];
    [stop addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop];
    [stop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];

    UIButton *pause = [UIButton buttonWithType:UIButtonTypeCustom];
    pause.backgroundColor = [UIColor redColor];
    [pause setTitle:@"暂停" forState:UIControlStateNormal];
    [pause addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pause];
    [pause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(start.mas_left);
        make.top.mas_equalTo(start.mas_bottom).offset(50);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];

    UIButton *resume = [UIButton buttonWithType:UIButtonTypeCustom];
    resume.backgroundColor = [UIColor redColor];
    [resume setTitle:@"继续" forState:UIControlStateNormal];
    [resume addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resume];
    [resume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(stop.mas_right);
        make.top.mas_equalTo(stop.mas_bottom).offset(50);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(40);
    }];
    
}

#pragma mark - 按钮事件 -
- (void)start{
    [self.recordManage start];
}
- (void)finish{
    [self.recordManage finish];
    self.recordManage.model = [self getModel];
}
- (void)pause{
    [self.recordManage pause];
}

- (void)resume{
    [self.recordManage resume];
}

- (LLJRecordModel *)getModel {
    LLJRecordModel *model = [[LLJRecordModel alloc]init];
    model.filePath = LLJ_videoRecord_Path;
    model.fileName = [NSString stringWithFormat:@"%@.mp4",[LLJHelper getTimeInterval:[NSDate date]]];
    model.writeToPhotoLibrary = YES;
    model.maxRecordTime = 20;
    model.recordType = LLJRecordTypeVideo;
    return model;
}

#pragma mark - 页面旋转 -
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    NSLog(@"LLJVideoRecordController");
}

//https://www.baijiayun.com/web/playback/index?classid=19020668965963&token=UIyxeEvLYcu1tkVXuv8O6GYgHkfhfXklf_rwskmtasamdgCgLdee4bllojWrz1IajAk6Qj2pOAo&user_number=438004
//https://www.baijiayun.com/web/playback/index?classid=19020989677387&token=nMbK0NyqusDwKJlLWbwcars6qMUckDYLiuUNQKd6aDoYgtLzXXi528GUyAu0zoLyCqdH1zJ1Si0&user_number=438004
//https://www.baijiayun.com/web/playback/index?classid=19020669014875&token=P-f28G3wlozwKJlLWbwcaoPgQUfcg26CPu0vGoE5_jwYgtLzXXi52-rRumFGU90dCqdH1zJ1Si0&user_number=438004
//https://www.baijiayun.com/web/playback/index?classid=19020669015130&token=-rZsbujtmOPwKJlLWbwcaoPgQUfcg26C-dc17qodjCEYgtLzXXi52-rRumFGU90dCqdH1zJ1Si0&user_number=438004
//https://www.baijiayun.com/web/playback/index?classid=19020669015114&token=OQRJhvHltZK1tkVXuv8O6ILLvedW7Q6Pisgesjn9mfymdgCgLdee4bllojWrz1IajAk6Qj2pOAo&user_number=438004
//https://www.baijiayun.com/web/playback/index?classid=19020668951627&token=8gYJj-wOi1HwKJlLWbwcaid-R8fJrP879y12sdA_cF4YgtLzXXi52-rRumFGU90dCqdH1zJ1Si0&user_number=438004
//https://www.baijiayun.com/web/playback/index?classid=19020668949578&token=ZXIQCYvKao_wKJlLWbwcaid-R8fJrP873SEs-RJM--0YgtLzXXi52-rRumFGU90dCqdH1zJ1Si0&user_number=438004
//0EA7C3F482345ADD9C33DC5901307461
//E2D8089CF5261C3D9C33DC5901307461
//35739F1F0226F3D29C33DC5901307461
//42091DE374DB6D839C33DC5901307461
//A15ECB0FBAA4DC1F9C33DC5901307461
//7EC59DDAB2E47BC89C33DC5901307461
//22DB71C9FA71D7429C33DC5901307461
//https://bwol-video-ufile.ebeiwai.com/42091DE374DB6D839C33DC5901307461_360p.m3u8
//https://alhls-cdn.zhanqi.tv/zqlive/272471_0m4e4.m3u8
//[self testM3u8VideoWithUrl:@"https://bwol-video-ufile.ebeiwai.com/42091DE374DB6D839C33DC5901307461_360p.m3u8"];

@end
