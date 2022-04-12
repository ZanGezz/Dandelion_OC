//
//  LLJCMMotionController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/30.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJCMMotionController.h"
#import "LLJCMMotionButton.h"

@interface LLJCMMotionController ()

@property (nonatomic, strong) LLJCMMotionButton *cmmotion;

@end

@implementation LLJCMMotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI {
    
    LLJCMMotionButton *cmmotion = [LLJCMMotionButton buttonWithType:UIButtonTypeCustom];
    //保持view在最上层
    cmmotion.layer.zPosition = 1.0;
    [cmmotion setImage:[UIImage imageNamed:@"zhazha.png"] forState:UIControlStateNormal];
    cmmotion.layer.masksToBounds = YES;
    cmmotion.layer.cornerRadius = 50.0;
    cmmotion.layer.borderWidth = 5.0;
    cmmotion.layer.borderColor = [UIColor redColor].CGColor;
    [cmmotion addTarget:self action:@selector(cmmotionClick) forControlEvents:UIControlEventTouchUpInside];
    [kRootView addSubview:cmmotion];
    [cmmotion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(kRootView.mas_centerX);
        make.centerY.mas_equalTo(kRootView.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [kRootView layoutIfNeeded];
    [cmmotion addCMMotion];
    
    self.cmmotion = cmmotion;
}

- (void)cmmotionClick {
    NSLog(@"追不上我，哈哈。。。");
}

@end
