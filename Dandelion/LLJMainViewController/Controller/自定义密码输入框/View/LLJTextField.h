//
//  LLJTextField.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/13.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJTextField : UITextField

@property (nonatomic, copy) NSString *inputText;

- (void)resetText:(LLJTextField *)textField;

@end

NS_ASSUME_NONNULL_END
