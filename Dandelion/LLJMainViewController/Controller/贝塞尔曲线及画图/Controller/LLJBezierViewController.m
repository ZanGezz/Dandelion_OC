//
//  LLJBezierViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2021/2/24.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "LLJBezierViewController.h"
#import "LLJCycleModel.h"
#import "ZBAssetAllocationView.h"

@interface LLJBezierViewController ()

@property (nonatomic, strong) ZBAssetAllocationView *assetView;
@property (nonatomic, strong) NSArray *array;
@end

@implementation LLJBezierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self setUpUI];
}

- (void)reloadDataSource {
    [self.assetView reloadData:self.array];
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
    NSInteger count = 10;
    for (int i = 0; i < count; i ++) {
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
            model.productProperty = 9.199;
            model.strokeColor     = [UIColor purpleColor];
        } else {
            double property = 30/(count-7);
            model.productProperty = property;
            model.strokeColor     = [UIColor brownColor];
            if (i == count - 1) {
                model.productProperty = 30 - property*(count - 8);
            }
        }
        model.productName     = @"定期";
        [array addObject:model];
    }
    
    self.array = array;
    
    ZBAssetAllocationView *assetView = [[ZBAssetAllocationView alloc]initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 160)];
    [self.view addSubview:assetView];
    assetView.cycleViewOffsetX = 20;
    [assetView reloadData:array];
    self.assetView = assetView;
}

@end
