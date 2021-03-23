//
//  LLJProductListView.m
//  Dandelion
//
//  Created by 刘帅 on 2021/3/2.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "LLJProductListView.h"
#import "LLJCycleModel.h"

#define View_H  12.0   //一个小view高度
#define View_W   80.0  //一个小view的宽
#define Offset_Y 12.0  //上下间隔高度


@interface LLJProductListView ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LLJProductListView

#pragma mark - UI -
- (void)reloadData:(NSArray *)sourceArray {
    
    //防止mas布局拿不到frame
    [self.superview layoutIfNeeded];
    
    self.dataArray = sourceArray;
    if (self.frame.size.width == 0) {
        return;
    }
    //先移除子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //是否数据过多，导致一列无法显示
    BOOL r = (self.dataArray.count *View_H + (self.dataArray.count - 1)*Offset_Y) > self.frame.size.height ? YES : NO;
    //重新计算设置view的frame
    CGFloat W,H;
    //计算创建行数和列数
    int row = 0, line = 0;
    if (r) {
        row = (self.frame.size.height - View_H) / (Offset_Y + View_H) + 1;
        line = (int)self.dataArray.count/row + 1;
        W = line *View_W;
        H = (Offset_Y + View_H)*row - Offset_Y;
        if (W > self.frame.size.width) {
            W = self.frame.size.width;
            line = (int)W / View_W;
            W = line *View_W;
        }

    } else {
        line = 1;
        row = (int)self.dataArray.count;
        W = View_W;
        H = (Offset_Y + View_H)*self.dataArray.count - Offset_Y;
    }
    
    UIView *contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    contentView.frame = CGRectMake(0, 0, W, H);
    CGPoint center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    contentView.center = center;
    //创建子view 80 12
    NSInteger sourceIndex = 0;
    for (int i = 0; i < line; i ++) {
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(View_W*i, 0, View_W, H);
        [contentView addSubview:bgView];
        for (int j = 0; j < row; j ++) {
            
            if (sourceIndex >= self.dataArray.count) {
                break;
            }
            
            LLJCycleModel *model = self.dataArray[sourceIndex];
            UIView *subView = [[UIView alloc]init];
            subView.frame = CGRectMake(0, (Offset_Y + View_H)*j, View_W, View_H);
            [bgView addSubview:subView];
            
            UIView *colorView = [[UIView alloc]init];
            colorView.backgroundColor = model.strokeColor;
            [subView addSubview:colorView];
            [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(subView.mas_centerY);
                make.left.mas_equalTo(subView.mas_left);
                make.width.mas_equalTo(8.0);
                make.height.mas_equalTo(8.0);
            }];
            
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.font = LLJFont(12);
            titleLabel.textColor = LLJColor(68, 68, 68, 1);
            titleLabel.text = model.productName;
            [subView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(subView.mas_centerY);
                make.left.mas_equalTo(colorView.mas_right).offset(5);
                make.width.mas_equalTo(64);
                make.height.mas_equalTo(12);
            }];
            sourceIndex ++;
        }
    }
}

@end
