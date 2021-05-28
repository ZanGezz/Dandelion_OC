//
//  LLJQRCodeController.m
//  Dandelion
//
//  Created by 刘帅 on 2021/2/20.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "LLJQRCodeController.h"
#import "JDSnowView.h"

@interface LLJQRCodeController ()

@end

@implementation LLJQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LLJWhiteColor;
    JDSnowView *snow = [[JDSnowView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:snow];
}

@end
