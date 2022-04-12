//
//  FWTextView.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/31.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWTextView : UITextView

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic) NSInteger maxInputCount;                          //最大输入长度
@property (nonatomic, copy) void (^viewTextLenth)(NSString *viewText);
//@property (nonatomic) BOOL secureTextEntry;                               //最大输入长度


@end

NS_ASSUME_NONNULL_END
