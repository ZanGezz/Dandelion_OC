//
//  ZBAssetAllocationView.h
//  Dandelion
//
//  Created by 刘帅 on 2021/3/22.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBAssetAllocationView : UIView

@property (nonatomic) CGFloat cycleViewOffsetX;
@property (nonatomic) CGFloat listViewOffsetX;

- (void)reloadData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
