//
//  BFBackButton.h
//  bfclass
//
//  Created by 刘帅 on 2018/11/27.
//  Copyright © 2018 fltrp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFBackButton : UIButton

@property (nonatomic) CGSize touchSize;
@property (nonatomic, copy) void (^backBlock)(void);

@end

NS_ASSUME_NONNULL_END
