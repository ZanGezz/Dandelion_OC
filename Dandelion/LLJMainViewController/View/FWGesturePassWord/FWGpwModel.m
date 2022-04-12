//
//  FWGpwManager.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/22.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWGpwModel.h"

@implementation FWGpwModel

#pragma mark - 初始化 -
- (instancetype)init{
    self = [super init];
    if (self) {
        //设置默认属性
        self.strokeWidth = 1.0f;            //圆弧的宽度
        self.circleRadius = LLJD_X(34.0);           //半径
        self.centerPointRadius = LLJD_X(10.0);      //中心圆半径
        self.lineWidth = 3.0f;               //连接线宽度
        
        self.strokeColorNormal = LLJColor(100, 75, 111, 1);                    //圆弧的填充颜色（正常)
        self.fillColorNormal = LLJColor(243, 244, 245, 1);                      //除中心圆点外 其他部分的填充色（正常）
        self.centerPointColorNormal = LLJColor(243, 244, 245, 1);           //中心圆点的颜色（正常）
        self.lineColorNormal = LLJColor(105, 79, 116, 1);                       //线条填充颜色（正常）
        
        self.strokeColorSelected = LLJColor(100, 75, 111, 1);        //圆弧的填充颜色（选择）
        self.fillColorSelected = LLJColor(243, 244, 245, 1);          //除中心圆点外 其他部分的填充色（选择）
        self.centerPointColorSelected = LLJColor(105, 79, 116, 1);   //中心圆点的颜色（选择）
        self.lineColorSelected = LLJColor(105, 79, 116, 1);          //线条填充颜色（选择）
        
        self.strokeColorIncorrect = [UIColor colorWithHex:0xfdddd6];       //圆弧的填充颜色（错误）
        self.fillColorIncorrect = [UIColor colorWithHex:0xfdddd6];         //除中心圆点外 其他部分的填充色（错误）
        self.centerPointColorIncorrect = [UIColor colorWithHex:0xf75730];  //中心圆点的颜色（错误）
        self.lineColorIncorrect = [UIColor colorWithHex:0xf75730];         //线条填充颜色（错误）
        
        self.showCenterPoint = YES;       //是否显示中心圆
        self.fillCenterPoint = YES;       //是否填充中心圆
    }
    return self;
}

@end
