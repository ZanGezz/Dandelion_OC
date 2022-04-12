//
//  LLJAlertViewController.m
//  Dandelion
//
//  Created by 刘帅 on 2019/12/13.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJAlertViewController.h"
#import "LLJAlertView.h"

@interface LLJAlertViewController ()

@end

@implementation LLJAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

#pragma mark - 按钮事件 -
- (void)buttonClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 1001:
        {
            LLJAlertView *alert = [[LLJAlertView alloc]initWithFrame:kRootView.bounds itemArray:@[@"1111",@"2222",@"3333",@"4444"]];
            alert.commenColor = [UIColor blueColor];
            alert.cancelTitle = @"确定";
            alert.didSelectRow = ^(NSString * _Nonnull rowTitle) {
                NSLog(@"title = %@",rowTitle);
            };
            alert.cancelColor = [UIColor redColor];
            [alert viewShow:kRootView];
        }
            //[self addData];
            break;
        case 1002:
            //[self getData];
            break;
        case 1003:
            //[self deletData];
            break;
        case 1004:
            //[self updateData];
            break;
        case 1005:
            //[self writeToFile];
            break;
        case 1006:
            //[self getLocalFile];
            break;
            
        default:
            break;
    }
}

#pragma mark - UI -
- (void)createUI{
        
    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setTitle:@"添加数据" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonAdd.tag = 1001;
    [buttonAdd addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonAdd];
    [buttonAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(-40));
        make.top.mas_equalTo(self.view.mas_top).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *buttonGet = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonGet setTitle:@"获取数据" forState:UIControlStateNormal];
    [buttonGet setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonGet.tag = 1002;
    [buttonGet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonGet];
    [buttonGet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(40));
        make.top.mas_equalTo(self.view.mas_top).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *buttonDelet = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDelet setTitle:@"删除数据" forState:UIControlStateNormal];
    [buttonDelet setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonDelet.tag = 1003;
    [buttonDelet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDelet];
    [buttonDelet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(-40));
        make.top.mas_equalTo(buttonAdd.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *buttonUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonUpdate setTitle:@"修改数据" forState:UIControlStateNormal];
    [buttonUpdate setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonUpdate.tag = 1004;
    [buttonUpdate addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonUpdate];
    [buttonUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(40));
        make.top.mas_equalTo(buttonGet.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(80));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *buttonWriteToFile = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonWriteToFile setTitle:@"写入txt文件" forState:UIControlStateNormal];
    [buttonWriteToFile setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonWriteToFile.tag = 1005;
    [buttonWriteToFile addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonWriteToFile];
    [buttonWriteToFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(-40));
        make.top.mas_equalTo(buttonDelet.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(120));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
    
    UIButton *getButtonWriteToFile = [UIButton buttonWithType:UIButtonTypeCustom];
    [getButtonWriteToFile setTitle:@"获取txt文件" forState:UIControlStateNormal];
    [getButtonWriteToFile setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    getButtonWriteToFile.tag = 1006;
    [getButtonWriteToFile addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getButtonWriteToFile];
    [getButtonWriteToFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(LLJD_X(40));
        make.top.mas_equalTo(buttonUpdate.mas_bottom).offset(LLJD_X(50));
        make.width.mas_equalTo(LLJD_X(120));
        make.height.mas_equalTo(LLJD_Y(20));
    }];
}

@end
