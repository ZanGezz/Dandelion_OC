//
//  ZBAssetAllocationView.m
//  Dandelion
//
//  Created by 刘帅 on 2021/3/22.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "ZBAssetAllocationView.h"
#import "LLJCycleView.h"
#import "LLJProductListView.h"

@interface ZBAssetAllocationView ()

@property (nonatomic, strong) LLJCycleView *cycleView;
@property (nonatomic, strong) LLJProductListView *listView;

@end

@implementation ZBAssetAllocationView

#pragma mark - 初始化 -
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.cycleView];
        [self addSubview:self.listView];
        
        [self layoutSubview];
    }
    return self;
}

#pragma mark - 刷新数据 -
- (void)reloadData:(NSArray *)data {
    [self.cycleView strokeWithSource:data];
    [self.listView reloadData:data];
}

#pragma mark - UI -
- (void)layoutSubview {
        
    CGFloat cycleViewOffsetX = self.frame.size.width/4 + self.cycleViewOffsetX;
    CGFloat listViewOffsetX  = self.frame.size.width*3/4 + self.listViewOffsetX;

    CGPoint cycleViewCenter = CGPointMake(cycleViewOffsetX, self.frame.size.height/2);
    self.cycleView.center = cycleViewCenter;
    
    CGPoint listViewCenter = CGPointMake(listViewOffsetX, self.frame.size.height/2);
    self.listView.center = listViewCenter;
}
- (void)setCycleViewOffsetX:(CGFloat)cycleViewOffsetX {
    _cycleViewOffsetX = cycleViewOffsetX;
    [self layoutSubview];
}
- (void)setListViewOffsetX:(CGFloat)listViewOffsetX {
    _listViewOffsetX = listViewOffsetX;
    [self layoutSubview];
}

#pragma mark - 懒加载 -
- (LLJCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[LLJCycleView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        _cycleView.strokeWithAnimation = YES;
    }
    return _cycleView;
}

- (LLJProductListView *)listView {
    if (!_listView) {
        _listView = [[LLJProductListView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    }
    return _listView;
}

@end
