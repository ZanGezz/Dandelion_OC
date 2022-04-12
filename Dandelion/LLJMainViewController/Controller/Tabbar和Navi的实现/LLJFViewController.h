//
//  LLJFViewController.h
//  Dandelion
//
//  Created by 刘帅 on 2019/11/11.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLJFViewController : UIViewController

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic)       BOOL      hiddenNavgationBarWhenPushIn;        //进入页面隐藏导航栏
@property (nonatomic)       BOOL      hiddenStatusBarWhenPushIn;           //进入页面隐藏状态栏
@property (nonatomic)       BOOL      forbidGesturePopViewController;      //禁止左滑手势返回

//返回按钮
- (void)createLeftBackBtnWithImageName:(NSString *)imageName backAction:(void (^)(void))backBlock;

//销毁指定控制器
- (void)removeNavSubControllerByName:(NSString *)vcName;

@end
