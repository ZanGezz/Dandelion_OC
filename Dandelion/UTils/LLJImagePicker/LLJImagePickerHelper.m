//
//  LLJImagePickerHelper.m
//  
//
//  Created by 刘帅 on 2021/1/4.
//

#import "LLJImagePickerHelper.h"
#import "LLJLimitImagePickerController.h"

@interface LLJImagePickerHelper ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, PHPickerViewControllerDelegate>

@property (nonatomic, strong) UIViewController *presentViewController;
@property (nonatomic, strong) LLJImagePickerHelper *picker;
@property (nonatomic, strong) NSArray *filter;
@property (nonatomic)         NSInteger selectionLimit;

@property (nonatomic, copy)   void (^photoUsage)(BOOL canBeUsed);
@property (nonatomic, copy)   void (^selectImage)(UIImage *iamge);
@property (nonatomic, copy)   void (^cancel)(void);

@end

@implementation LLJImagePickerHelper

+ (void)showPhotoListWithPresentViewController:(UIViewController *)persentViewController photoUsage:(nonnull void (^)(BOOL))photoUsage selectBlock:(void(^)(UIImage *iamge))selectImage cancelBlock:(void(^)(void))cancel {
    
    LLJImagePickerHelper *picker = [[LLJImagePickerHelper alloc]init];
    picker.selectImage = selectImage;
    picker.cancel = cancel;
    picker.photoUsage = photoUsage;
    picker.presentViewController = persentViewController;
    //设置代理使用
    picker.picker = picker;

    [picker checkPickerLimit];
}

#pragma mark - 检查相册使用权限 -
- (void)checkPickerLimit {
    
    
    if (@available(iOS 14, *)) {
        PHAccessLevel level2 = PHAccessLevelReadWrite;
        [PHPhotoLibrary requestAuthorizationForAccessLevel:level2 handler:^(PHAuthorizationStatus status) {
            switch (status) {
              case PHAuthorizationStatusLimited:
                  NSLog(@"limited");
              {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      !self.photoUsage ?: self.photoUsage(YES);
                      [self showLimitImagePickerViewController];
                  });
              }
                  break;
              case PHAuthorizationStatusDenied:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !self.photoUsage ?: self.photoUsage(NO);
                    });
                }
                  NSLog(@"denied");
                  break;
              case PHAuthorizationStatusAuthorized:
              {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      !self.photoUsage ?: self.photoUsage(YES);
                      [self showPHPickerViewController];
                  });
              }
                  break;
              default:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !self.photoUsage ?: self.photoUsage(NO);
                    });
                }
                  break;
            }
        }];
    } else {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
            !self.photoUsage ?: self.photoUsage(NO);
        } else {
            !self.photoUsage ?: self.photoUsage(YES);
            [self showImagePickerController];
        }
    }
}

#pragma mark - UIImagePickerController 和 代理 -
- (void)showImagePickerController {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self.picker;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.presentViewController presentViewController:imagePicker animated:YES completion:nil];
}
//代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    !self.selectImage ?: self.selectImage(image);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    !self.cancel ?: self.cancel();
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PHPickerViewController 和 代理 -
- (void)showPHPickerViewController {
    
    if (@available(iOS 14, *)) {
        //三种过滤类型
        PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
        configuration.filter = [PHPickerFilter anyFilterMatchingSubfilters:self.filter]; // 可配置查询用户相册中文件的类型，支持三种
        configuration.selectionLimit = self.selectionLimit; // 默认为1，为0为跟随系统上限
        PHPickerViewController *phpPicker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
        phpPicker.delegate = self.picker;
        phpPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.presentViewController presentViewController:phpPicker  animated:YES completion:nil];
    }
}
//代理
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)) {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (!results || !results.count) {
        !self.cancel ?: self.cancel();
        return;
    }
    NSItemProvider *itemProvider = results.firstObject.itemProvider;
    if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
        __weak typeof(self) weakSelf = self;
        //异步获取
        [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:UIImage.class]) {
                __strong typeof(self) strongSelf = weakSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = object;
                    !strongSelf.selectImage ?: strongSelf.selectImage(image);
                });
            }
        }];
    }
}

#pragma mark - PHPickerViewController 和 代理 -
- (void)showLimitImagePickerViewController {
    
    LLJLimitImagePickerController *limit = [[LLJLimitImagePickerController alloc] init];
    limit.modalPresentationStyle = UIModalPresentationFullScreen;
    limit.selectImage = ^(UIImage * _Nonnull image) {
        !self.selectImage ?: self.selectImage(image);
    };
    [self.presentViewController presentViewController:limit  animated:YES completion:nil];
}

#pragma mark - 初始化 -
- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 14, *)) {
            self.filter = @[PHPickerFilter.imagesFilter];
            self.selectionLimit = 1;
        }
    }
    return self;
}

- (void)dealloc {
    NSLog(@"LLJImagePickerHelper");
}

@end

