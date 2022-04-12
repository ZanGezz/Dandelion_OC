//
//  FWNoDataView.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/18.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FWNoDataType) {
    FWNoDataTypeNoData,        //无数据
    FWNoDataTypeLoadFail,      //加载失败
    FWNoDataTypeNoNetWork,     //无网络
    FWNoDataTypeInteract       //互动问答
};

@interface FWNoDataView : UIView

@property (nonatomic) FWNoDataType type;

@property (nonatomic, copy) void (^reloadData)(void);

@end

NS_ASSUME_NONNULL_END
