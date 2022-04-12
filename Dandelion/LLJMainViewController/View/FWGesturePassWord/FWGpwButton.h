//
//  FWGpwButton.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/22.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWGpwModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWGpwButton : UIButton

@property (nonatomic) NSInteger buttonNum;

- (instancetype)initWithFrame:(CGRect)frame model:(FWGpwModel *)model;

@end

NS_ASSUME_NONNULL_END
