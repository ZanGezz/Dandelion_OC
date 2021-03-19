//
//  LLJCycleModel.h
//  Dandelion
//
//  Created by 刘帅 on 2021/2/24.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJCycleModel : NSObject

//总资产
@property (nonatomic) double totalProperty;

//产品资产
@property (nonatomic) double productProperty;

//产品名称
@property (nonatomic, strong) NSString *productName;

//产品资产占比
@property (nonatomic) double ratio;          // = productProperty / totalProperty

//最小占比
@property (nonatomic) double minRatio;       // 设置最小默认0.001  千分之一下画出来不显示了

//产品资产估计占比 防止占比太小画不出图 该属性为最终画图使用
@property (nonatomic) double estimateRatio;  // = ratio < minRatio ? minRatio : ratio

//线宽颜色
@property (nonatomic, strong) UIColor *strokeColor;

//填充颜色 实现有点问题 先使用无色
//@property (nonatomic, strong) UIColor *fillColor;

@end

NS_ASSUME_NONNULL_END
