//
//  LLJDownLoadCell.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/19.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLJDownLoadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLJDownLoadCell : UITableViewCell

- (void)removeObserver;

- (void)setupContentWithModel:(LLJDownLoadModel *)model;

@end

NS_ASSUME_NONNULL_END
