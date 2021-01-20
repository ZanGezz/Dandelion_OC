//
//  LLJDownLoadController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/16.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJDownLoadController.h"
#import "LLJVideoPlayController.h"
#import "LLJDownLoadManage.h"
#import "LLJDownLoadCell.h"

@interface LLJDownLoadController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) LLJFTableView *mytableView;
@property (nonatomic, strong) NSArray *urlArray;
@property (nonatomic, strong) NSArray<LLJDownLoadModel *> *downLoadingArray;
@property (nonatomic, strong) NSArray<LLJDownLoadModel *> *finishDownloadArray;

@end

@implementation LLJDownLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)setUpUI {
    
    [LLJHelper deleteAllFileByPath:LLJ_videoDownLoad_Path];
    
    
    self.urlArray = @[@"https://bwol-video-ufile.ebeiwai.com/0EA7C3F482345ADD9C33DC5901307461_360p.m3u8",
                      @"https://bwol-video-ufile.ebeiwai.com/E2D8089CF5261C3D9C33DC5901307461_360p.m3u8",
                      @"https://bwol-video-ufile.ebeiwai.com/35739F1F0226F3D29C33DC5901307461_360p.m3u8",
                      @"https://bwol-video-ufile.ebeiwai.com/42091DE374DB6D839C33DC5901307461_360p.m3u8",
                      @"https://bwol-video-ufile.ebeiwai.com/A15ECB0FBAA4DC1F9C33DC5901307461_360p.m3u8",
                      @"https://bwol-video-ufile.ebeiwai.com/7EC59DDAB2E47BC89C33DC5901307461_360p.m3u8",
                      @"https://bwol-video-ufile.ebeiwai.com/22DB71C9FA71D7429C33DC5901307461_360p.m3u8"];
    
    self.urlArray = @[@"http://jlzg.cnrmobile.com/resource/index/sp/jlzg0226.mp4"];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeSystem];
    [right setTitle:@"添加" forState:UIControlStateNormal];
    [right setTitleColor:LLJWhiteColor forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 40, 20);
    right.titleLabel.font = LLJBoldFont(14);
    [right addTarget:self action:@selector(addDownLoadSource) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.mytableView];
}

- (void)addDownLoadSource {
    
    LLJDownLoadModel *model = [[LLJDownLoadModel alloc]init];
    model.urlString = [self getArc4randomDowmLoadURLString];
    [LLJDownLoad addDownLoadSourceWithUrl:model];
    [self updateTableView];
}

- (NSString *)getArc4randomDowmLoadURLString {
    return self.urlArray[arc4random()%self.urlArray.count];
}

- (void)updateTableView {
    self.downLoadingArray = [LLJDownLoad getAllowDownLoadSourceExceptFinish];
    [self.mytableView reloadData];
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.downLoadingArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return LLJD_Y(80);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLJDownLoadCell *downLoadCell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (!downLoadCell) {
        downLoadCell = [[LLJDownLoadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        downLoadCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [downLoadCell setupContentWithModel:self.downLoadingArray[indexPath.row]];
    return downLoadCell;
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
    LLJDownLoadModel *model = self.downLoadingArray[indexPath.row];
    if (model) {
        [LLJDownLoad removeModelWithTimeTag:model.task.timeTag];
        [LLJHelper deleteFileByPath:model.filePath];
        [self updateTableView];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LLJDownLoadModel *model = self.downLoadingArray[indexPath.row];
    if (model.type == LLJDownLoadTypeFinish) {
        LLJVideoPlayController *instance = [[LLJVideoPlayController alloc]init];
        instance.titleName = model.fileName;
        instance.urlString = model.filePath;
        instance.imageArray = @[];
        [self.navigationController pushViewController:instance animated:YES];
    }
}

#pragma mark - 懒加载属性 -
- (LLJFTableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[LLJFTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight - LLJTabBarHeight) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
}

- (void)dealloc {
    NSLog(@"class = %@",NSStringFromClass([self class]));
}
@end
