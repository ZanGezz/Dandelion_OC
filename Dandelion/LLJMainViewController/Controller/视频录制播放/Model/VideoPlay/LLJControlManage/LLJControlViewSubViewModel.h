//
//  LLJControlViewSubViewModel.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/3.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJControlViewSubViewModel : NSObject

@property (nonatomic, strong) UIView *subView;
@property (nonatomic) CGSize subViewSize;
@property (nonatomic) CGFloat subViewLeftOrTopSpace;
@property (nonatomic) CGFloat subViewRightOrBottomSpace;
@property (nonatomic) CGFloat centerOffset;

@end

NS_ASSUME_NONNULL_END
