//
//  LLJLanguageController.m
//  Dandelion
//
//  Created by liushuai on 2022/4/8.
//  Copyright © 2022 liushuai. All rights reserved.
//

#import "LLJLanguageController.h"
#import "FWLangageHelper.h"

@interface LLJLanguageController ()

@property (nonatomic, strong) UILabel *ceshiLabel;

@end

@implementation LLJLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // UI
    [self setUpUI];
}


- (void)setUpUI {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"切换" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 100, 80, 40);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actiondd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *ceshi = [[UILabel alloc]init];
    ceshi.text = Language(@"shu");
    ceshi.frame = CGRectMake(0, 200, 80, 100);
    self.ceshiLabel = ceshi;
    [self.view addSubview:ceshi];
    
}

- (void)actiondd:(UIButton *)sender {
    
    if (sender.selected) {
        [FWLangageHelper setNewLangage:@"en"];
    }else{
        [FWLangageHelper setNewLangage:@"zh-Hans"];
    }
    sender.selected = !sender.selected;
    
    self.ceshiLabel.text = Language(@"shu");
}

@end
