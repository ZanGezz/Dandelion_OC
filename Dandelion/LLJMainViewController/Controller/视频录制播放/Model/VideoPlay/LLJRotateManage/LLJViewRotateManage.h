//
//  LLJViewRotateManage.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/9.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLJVideoPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLJViewRotateManage : NSObject

@property (nonatomic, copy) void (^rotateScreen)(BOOL toFull);

- (instancetype)initWithModel:(LLJVideoPlayModel *)model rotateView:(UIView *)rotateView;

- (void)viewRotate;

@end

NS_ASSUME_NONNULL_END
