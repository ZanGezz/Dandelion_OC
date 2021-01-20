//
//  LLJBrightView.h
//  Dandelion
//
//  Created by 刘帅 on 2020/11/12.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJBrightView : UIView

@property (nonatomic) CGFloat initialValue;
@property (nonatomic) CGFloat value;
@property (nonatomic, copy) NSString *backImageName;

- (instancetype)initWithBaseTag:(NSInteger)baseTag;

@end

NS_ASSUME_NONNULL_END
