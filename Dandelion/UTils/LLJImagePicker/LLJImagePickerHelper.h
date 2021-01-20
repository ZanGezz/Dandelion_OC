//
//  LLJImagePickerHelper.h
//  
//
//  Created by 刘帅 on 2021/1/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJImagePickerHelper : NSObject

/**
 *  @param persentViewController  推出页面的控制器
 *  @param photoUsage     返回是否有权限使用相册 yes 有 no 没有
 *  @param selectImage  返回选中的照片
 *  @param cancel             取消按钮事件
 */
+ (void)showPhotoListWithPresentViewController:(UIViewController *)persentViewController photoUsage:(void(^)(BOOL canBeUsed))photoUsage selectBlock:(void(^)(UIImage *iamge))selectImage cancelBlock:(void(^)(void))cancel;

@end

NS_ASSUME_NONNULL_END
