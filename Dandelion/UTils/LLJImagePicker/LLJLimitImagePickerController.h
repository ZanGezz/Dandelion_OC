//
//  LLJLimitImagePickerController.h
//  
//
//  Created by 刘帅 on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJLimitImagePickerController : UIViewController

@property (nonatomic, copy) void (^selectImage)(UIImage *image);

@end

NS_ASSUME_NONNULL_END
