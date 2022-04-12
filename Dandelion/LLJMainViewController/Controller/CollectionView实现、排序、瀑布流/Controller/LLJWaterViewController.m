//
//  LLJWaterViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/12.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJWaterViewController.h"
#import "LLJFTableView.h"
#import "WSLFlowLayoutStyleOne.h"

@interface LLJWaterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) LLJFTableView *mytableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *vcArray;

@end

@implementation LLJWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"瀑布流";
    
    _dataSource = @[@"竖向瀑布流 item等宽不等高 支持头脚视图",@"水平瀑布流 item等高不等宽 不支持头脚视图", @"竖向瀑布流 item等高不等宽 支持头脚视图", @"特为国务院客户端原创栏目滑块样式定制-水平栅格布局  仅供学习交流"];
    _vcArray = @[@"WSLWaterFlowLayoutStyleOne", @"WSLWaterFlowLayoutStyleOne", @"WSLWaterFlowLayoutStyleOne", @"WSLWaterFlowLayoutStyleOne"];
    
    [self.view addSubview:self.mytableView];
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
}

#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WSLWaterFlowLayoutStyleOne * flowLayout = [NSClassFromString(_vcArray[indexPath.row]) new];
    flowLayout.flowLayoutStyle = (WSLWaterFlowLayoutStyle)indexPath.row;
    
    [self.navigationController pushViewController:flowLayout animated:NO];
}

#pragma mark - 懒加载属性 -
- (LLJFTableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[LLJFTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
}

@end
