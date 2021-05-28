//
//  LLJGesAndAuthIDController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/11/13.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJGesAndAuthIDController.h"
#import "LLJVideoPlayController.h"
#import "LLJBridgeViewController.h"
#import "FWGuideView.h"
#import "LLJMainCell.h"

@interface LLJGesAndAuthIDController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FWGuideView *guideView;
@property (nonatomic, strong) LLJFTableView *mytableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *imageSource;

@end

@implementation LLJGesAndAuthIDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

- (void)creatUI {
    //获取本地数据
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];

    [self.dataSource addObjectsFromArray:[LLJHelper getFilesWithPath:LLJ_video_Path]];
    [self.dataSource addObjectsFromArray:[LLJHelper getFilesWithPath:LLJ_image_Path]];
    for (NSString *fileName in self.dataSource) {
        NSString *filePath;
        if ([fileName containsString:@"png"]) {
            filePath = [LLJ_image_Path stringByAppendingPathComponent:fileName];
            [imageArray addObject:filePath];
        }else{
            filePath = [LLJ_video_Path stringByAppendingPathComponent:fileName];
            [videoArray addObject:filePath];
        }
    }
    self.dataSource = videoArray;
    self.imageSource = imageArray;
    [self.view addSubview:self.mytableView];
    
    [self guideViewShow];
}

- (void)guideViewShow {
    //页面出现
    [FWGuideView guideViewShow:self.view action:^{
        
    }];
}

#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
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
    NSString *fileName = [[self.dataSource[indexPath.row] componentsSeparatedByString:@"/"] lastObject];
    [mainCell setTitleName:fileName];
    return mainCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >= self.dataSource.count - 6) {
        LLJBridgeViewController *instance = [[LLJBridgeViewController alloc]init];
        instance.titleName = @"";
        instance.urlString = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:instance animated:YES];
    }else{
        LLJVideoPlayController *instance = [[LLJVideoPlayController alloc]init];
        instance.titleName = self.dataSource[indexPath.row];
        instance.urlString = self.dataSource[indexPath.row];
        instance.imageArray = self.imageSource;
        [self.navigationController pushViewController:instance animated:YES];
    }
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
    NSString *path = self.dataSource[indexPath.row];
    [LLJHelper deleteFileByPath:path];
    [self.dataSource removeObject:path];
    [self.mytableView reloadData];
}


#pragma mark - 懒加载属性 -
- (LLJFTableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[LLJFTableView alloc]initWithFrame:CGRectMake(0, LLJTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight - LLJTabBarHeight) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
}

@end
