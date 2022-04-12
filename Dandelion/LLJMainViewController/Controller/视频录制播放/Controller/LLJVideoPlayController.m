//
//  LLJVideoPlayController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/20.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJVideoPlayController.h"
#import <AVFoundation/AVFoundation.h>
#import "SDCycleScrollView.h"
#import "LLJRecordManage.h"
#import "LLJVideoPlayer.h"
#import "LLJVideoPlayModel.h"
#import "LLJVideoHelper.h"
#import "LLJFTableView.h"
#import "LLJMainCell.h"

@interface LLJVideoPlayController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SDCycleScrollView *cycleScroll;
@property (nonatomic) BOOL statusBarHidden;
@property (nonatomic, strong) LLJRecordManage *recordManage;
@property (nonatomic, strong) LLJVideoPlayer *videoPlayer;
@property (nonatomic, strong) LLJFTableView *mytableView;

@end

@implementation LLJVideoPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)buttonClick:(UIButton *)sender {
    self.cycleScroll.autoScroll = sender.selected;
    sender.selected = !sender.selected;
}

- (void)videoBack {
    [self.videoPlayer.playManage llj_seekTime:-30 completionHandler:^(BOOL finished) {
        
    }];
}

- (void)videoFront {
    [self.videoPlayer.playManage llj_seekTime:10 completionHandler:^(BOOL finished) {
        
    }];
}

- (void)setUpUI {

    //进入页面隐藏状态栏
    self.hiddenStatusBarWhenPushIn = YES;
    //进入页面隐藏导航栏
    self.hiddenNavgationBarWhenPushIn = YES;
        
    if (IS_VALID_ARRAY(self.imageArray)) {
        [self SDCycleScrollView];
    }else{
        self.imageArray = [LLJHelper getFilesWithPath:LLJ_videoRecord_Path];
        self.urlString = [LLJ_videoRecord_Path stringByAppendingPathComponent:[self.imageArray firstObject]];
        [self.view addSubview:self.mytableView];
    }
    
    [self createVideoPlayer];
}

- (void)SDCycleScrollView {
    self.cycleScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SCREEN_WIDTH*9/16 + 10, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_WIDTH*9/16 - 10) delegate:self placeholderImage:nil];
    self.cycleScroll.layer.masksToBounds = YES;
    self.cycleScroll.pageControlDotSize = CGSizeMake(LLJD_S(20), 2);
    self.cycleScroll.currentPageDotColor = LLJWhiteColor;
    self.cycleScroll.pageDotColor = LLJColor(0, 0, 0, 1);
    self.cycleScroll.layer.cornerRadius = 10.0f;
    self.cycleScroll.titleLabelTextFont = LLJLargeFont;
    self.cycleScroll.titleLabelTextColor = LLJWhiteColor;
    self.cycleScroll.titleLabelBackgroundColor = [UIColor clearColor];
    self.cycleScroll.imageURLStringsGroup = self.imageArray;
    [self.view addSubview:self.cycleScroll];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"暂停轮播" forState:UIControlStateNormal];
    button.backgroundColor = LLJBlackColor;
    button.titleLabel.font = LLJFont(16);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cycleScroll addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cycleScroll.mas_right);
        make.top.mas_equalTo(self.cycleScroll.mas_top);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"快10" forState:UIControlStateNormal];
    button2.backgroundColor = LLJBlackColor;
    button2.titleLabel.font = LLJFont(16);
    [button2 addTarget:self action:@selector(videoFront) forControlEvents:UIControlEventTouchUpInside];
    [self.cycleScroll addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cycleScroll.mas_right);
        make.top.mas_equalTo(button.mas_bottom);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"退30" forState:UIControlStateNormal];
    button1.backgroundColor = LLJBlackColor;
    button1.titleLabel.font = LLJFont(16);
    [button1 addTarget:self action:@selector(videoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.cycleScroll addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(button2.mas_left);
        make.top.mas_equalTo(button.mas_bottom);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark - 创建播放工具 -
- (void)createVideoPlayer {
    
    self.videoPlayer = [[LLJVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16) playModel:[self createPlayModelWithURL:self.urlString]];
    self.videoPlayer.superViewController = self;
    [self.view addSubview:self.videoPlayer];
}
- (LLJVideoPlayModel *)createPlayModelWithURL:(NSString *)urlString {
    
    LLJVideoPlayModel *playModel = [[LLJVideoPlayModel alloc]init];
    if (self.urlString) {
        playModel.videoUrl = [NSURL fileURLWithPath:urlString];
    }else{
        playModel.videoUrl = [NSURL URLWithString:@"https://bwol-video-ufile.ebeiwai.com/42091DE374DB6D839C33DC5901307461_360p.m3u8"];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *subString in self.dataArray) {
        [array addObject:[NSURL fileURLWithPath:subString]];
    }
    playModel.videoUrlArray = array;
    
    return playModel;
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return LLJD_Y(80);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLJMainCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (!mainCell) {
        mainCell = [[LLJMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *fileName = self.imageArray[indexPath.row];
    [mainCell setTitleName:fileName];
    return mainCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.urlString = [LLJ_videoRecord_Path stringByAppendingPathComponent:[self.imageArray firstObject]];
    [self.videoPlayer exchangePlayerSourceWithModel:[NSURL fileURLWithPath:self.urlString]];
    [self.videoPlayer createDefaultPlayerUI];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *path = self.imageArray[indexPath.row];
    [LLJHelper deleteFileByPath:[LLJ_videoRecord_Path stringByAppendingPathComponent:path]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.imageArray];
    [array removeObject:path];
    self.imageArray = array;
    [self.mytableView reloadData];
}

#pragma mark - 懒加载属性 -
- (LLJFTableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[LLJFTableView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*9/16, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_WIDTH*9/16) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
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
    [self.videoPlayer toolRelease];
    NSLog(@"LLJVideoPlayController");
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
