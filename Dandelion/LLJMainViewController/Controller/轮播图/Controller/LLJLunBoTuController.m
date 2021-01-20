//
//  LLJLunBoTuController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/12/25.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJLunBoTuController.h"
#import "SDCycleScrollView.h"
#import "LLJImagePickerHelper.h"

@interface LLJLunBoTuController ()<SDCycleScrollViewDelegate>

@end

@implementation LLJLunBoTuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)setUpUI {
    
    [LLJImagePickerHelper showPhotoListWithPresentViewController:self photoUsage:^(BOOL canBeUsed) {
            
        } selectBlock:^(UIImage * _Nonnull iamge) {
            
        } cancelBlock:^{
            
        }];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"IMG_3749.JPG" ofType:@""];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) delegate:self placeholderImage:[LLJHelper imageWithRenderColor:[UIColor orangeColor] renderSize:CGSizeMake(SCREEN_WIDTH, 300)]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    cycleScrollView.autoScrollTimeInterval = 2.0f;
    cycleScrollView.imageURLStringsGroup = @[path];
    [self.view addSubview:cycleScrollView];
}

@end
