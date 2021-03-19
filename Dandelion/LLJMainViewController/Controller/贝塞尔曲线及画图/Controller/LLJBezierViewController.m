//
//  LLJBezierViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2021/2/24.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "LLJBezierViewController.h"
#import "LLJCycleView.h"
#import "LLJCycleModel.h"
#import "LLJProductListView.h"

@interface LLJBezierViewController ()

@property (nonatomic, strong) LLJCycleView *cycle;
@property (nonatomic, strong) LLJProductListView *productListView;
@property (nonatomic, strong) NSArray *array;
@end

@implementation LLJBezierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self setUpUI];
}

- (void)reloadDataSource {
    [self.productListView reloadData:self.array];
    [self.cycle strokeWithSource:self.array];

}
- (void)setUpUI {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"刷新" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reloadDataSource) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(200, 500, 100, 40);
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    self.view.backgroundColor = LLJWhiteColor;
    
    //假数据
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 17; i ++) {
        LLJCycleModel *model = [[LLJCycleModel alloc]init];
        model.totalProperty = 100.0;

        if (i == 0) {
            model.productProperty = 0.8;
            model.strokeColor     = [UIColor redColor];
            model.productName     = @"定期";
        } else if (i == 1) {
            model.productProperty = 20.0;
            model.strokeColor     = [UIColor orangeColor];
        } else if (i == 2) {
            model.productProperty = 20.0;
            model.strokeColor     = [UIColor blueColor];
        } else if (i == 3) {
            model.productProperty = 0.001;
            model.strokeColor     = [UIColor yellowColor];
        } else if (i == 4) {
            model.productProperty = 10.0;
            model.strokeColor     = [UIColor grayColor];
        } else if (i == 5) {
            model.productProperty = 10.0;
            model.strokeColor     = [UIColor greenColor];
        } else if (i == 6) {
            model.productProperty = 39.199;
            model.strokeColor     = [UIColor purpleColor];
        }
        model.productName     = @"定期";
        [array addObject:model];
    }
    
    LLJCycleView *cycle = [[LLJCycleView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    cycle.strokeWithAnimation = YES;
    [self.view addSubview:cycle];
    [cycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(50);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(180);
    }];
    

    self.array = array;
    self.cycle = cycle;
    
    self.productListView = [[LLJProductListView alloc]init];
    [self.view addSubview:self.productListView];
    [self.productListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cycle.mas_right).offset(80);
        make.width.mas_equalTo(80);
        make.top.mas_equalTo(cycle.mas_top).offset(-10);
        make.bottom.mas_equalTo(cycle.mas_bottom).offset(10);
    }];
    
    [cycle strokeWithSource:array];
    [self.productListView reloadData:array];
}

@end
