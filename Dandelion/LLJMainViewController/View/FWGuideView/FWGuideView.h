//
//  FWGuideView.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/31.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWGuideView : UIView

+ (FWGuideView *)guideViewShow:(UIView *)superView action:(void (^)(void))action;

- (void)guideViewHidden;

@end

NS_ASSUME_NONNULL_END
