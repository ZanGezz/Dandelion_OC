//
//  LLJCircleOfFriendController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/18.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJCircleOfFriendController.h"

@interface LLJCircleOfFriendController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation LLJCircleOfFriendController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}
#pragma mark - UI -
- (void)createUI{
    
    [self createLeftBackBtnWithImageName:@"back" backAction:nil];
    self.view.backgroundColor = LLJColor(241, 241, 241, 1);
    self.title = self.titleName;
    //获取本地数据    
    [self.view addSubview:self.mytableView];
}
#pragma mark - UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return LLJD_Y(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - 懒加载属性 -
- (UITableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - LLJTopHeight - LLJTabBarHeight) style:UITableViewStylePlain];
        _mytableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.backgroundColor = LLJColor(241, 241, 241, 1);
    }
    return _mytableView;
}
@end
