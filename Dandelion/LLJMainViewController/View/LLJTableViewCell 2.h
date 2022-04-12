//
//  LLJTableViewCell.h
//  Dandelion
//
//  Created by 刘帅 on 2019/11/11.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLJCommenModel+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLJTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^shareBlock)(NSString *name);

- (void)setupContentWithModel:(LLJCommenModel *)model;

@end

NS_ASSUME_NONNULL_END
