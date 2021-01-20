//
//  LLJPersonalController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJPersonalController.h"
#import "LLJTabBarController.h"
#import "LLJBridgeViewController.h"
#import "UITableView+AddForPlaceholder.h"
#import "FWNoDataView.h"
#import "LLJMainCell.h"

@interface LLJPersonalController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) LLJFTableView *mytableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation LLJPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    void (^block)(NSString *age) = ^(NSString *age){
        NSLog(@"age:%@",age);
    };
    block(@"1");
}
- (void)createUI {
    //防止tableView从状态栏下方开始
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.mytableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = LLJColor(241, 241, 241, 1);
    //获取本地数据
    self.dataSource = [self getLocalResource:@"LLJMyKnowledge.txt"];
    
    [self.view addSubview:self.mytableView];
}
- (NSArray *)getLocalResource:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    return [LLJHelper getSetWithJsonString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
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
    [mainCell setTitleName:[[self.dataSource[indexPath.row] componentsSeparatedByString:@"-"] firstObject]];
    return mainCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *subs = [self.dataSource[indexPath.row] componentsSeparatedByString:@"-"];
    LLJBridgeViewController *instance = [[LLJBridgeViewController alloc]init];
    instance.titleName = [subs firstObject];
    instance.urlString = [subs lastObject];
    instance.hiddenNavgationBarWhenPushIn = NO;
    [self.navigationController pushViewController:instance animated:YES];
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
        FWNoDataView *noData = [[FWNoDataView alloc]init];
        noData.type = FWNoDataTypeNoData;
        _mytableView.customNoDataView = noData;
    }
    return _mytableView;
}


@end
