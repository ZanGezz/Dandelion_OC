//
//  FWSearchBarView.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/11.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FWSearchBarDelegate <NSObject>

@optional
//开始编辑
- (void)searchBarBeginEditing:(UITextField *)textField;
//结束编辑
- (void)searchBarEndEditing:(UITextField *)textField;
//正在编辑
- (void)searchBarValueChange:(UITextField *)textField;
//点击取消按钮
- (void)cancelButtonClick;
//点击键盘上的确认按钮
- (void)doneButtonClcik:(UITextField *)textField;

@end


@interface FWSearchBarView : UIView

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *rightName;
@property (nonatomic, weak) id<FWSearchBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
