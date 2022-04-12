//
//  UITableViewCell+TipsView.h
//  Dandelion
//
//  Created by 刘帅 on 2021/3/23.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (TipsView)

@property (nonatomic, copy) NSString *tipsContent; //tips显示内容
@property (nonatomic) CGFloat rowHeight;           //tips显示内容
@property (nonatomic) CGFloat selectRowHeight;           //tips显示内容
@property (nonatomic) CGFloat unselectRowHeight;           //tips显示内容

@end

NS_ASSUME_NONNULL_END
