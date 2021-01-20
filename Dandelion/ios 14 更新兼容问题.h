//
//  ios 14 更新兼容问题.h
//  Dandelion
//
//  Created by 刘帅 on 2020/9/22.
//  Copyright © 2020 liushuai. All rights reserved.
//

#ifndef ios_14________h
#define ios_14________h

//广告标示符获取方式
/*
 *1、[[[UIDevice currentDevice] identifierForVendor] UUIDString];这种方式获取的是临时标示符，多次获取或app卸载重装会改变。
 *2、[[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];这种方式获取为app广告标示符，受系统是否允许追踪按钮影响，如不允许，则获取为00000000-0000-0000-0000-000000000000
 
   *另外ios 14以后此种方法获取UUIDString需要权限允许，即[ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {}]。
    #import <AdSupport/AdSupport.h>
    #import <AppTrackingTransparency/AppTrackingTransparency.h>
 
 
 *3、[cell addsubview：subview];此方法添加子视图，事件响应链无法传递，改为[cell.contentView addsubview：subview]即可；
     原因：通过试图查看发现被系统自带的 cell.contentView` (类名UITableViewCellContentView)遮挡在底部了
 
 
 *4、使view保持在最上层有两种方式，第一种：view.layer.zPosion = 1.0 此种方式视觉上保持在最上层，但实际图层没有变化，因此将无法响应触摸事件。
    第二种：[suprView bringSubviewToFront:subView];此种方式将图层移到最上层，可以响应事件；
    另外：UIAlertController 在keywindow上永远在最下层，不回遮挡其他keywindow子视图；
 
 *3、UIProgressView高度问题

    在xcode12环境下的iOS14系统，UIProgressView的默认高度有8像素左右，需要做相应的适配
    Xcode12-IOS14的兼容
    if (@available(iOS 14.0, *)) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        transform = CGAffineTransformMakeScale(1.0f, 0.5f);
        _progressView.transform = transform;
    }

 *4、iOS14.0-14.1导航栏堆栈推出导致Tabbar隐藏

    iOS14.0与IOS14.1导航栏堆栈推出后，Tabbar会被隐藏，iOS14.2没有发现该问题
    - (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
        if (@available(iOS 14.0, *)) {
            if (self.viewControllers.count > 1) {
                self.topViewController.hidesBottomBarWhenPushed = NO;
            }
        };
        return [super popToRootViewControllerAnimated:animated];
    }
    - (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
        if (@available(iOS 14.0, *)) {
            if (self.viewControllers.count > 1) {
                self.topViewController.hidesBottomBarWhenPushed = NO;
            }
        };
        return [super popToViewController:viewController animated:animated];
    }

 *5、粘贴板问题

     查找本地UIPasteboard使用地方可以参考这篇文章iOS14适配——查找那些SDK使用剪切板
     如果你的App需要在启动时候去读取粘贴板，这个如果是URL格式的可以参考上述“权限问题适配”文章，
     用最新api来规避“提示弹框”；如果是从web页来点击跳转到自家App指定页面，之前是采用粘贴板方式来做的，
     想去规避粘贴板“提示弹框”问题，可以采用Universal Link来处理即可。


 *6、相册

      iOS14 新增了“Limited Photo Library Access” 模式，可以选择允许app访问的照片。

 *7、定位
    
      iOS14 新增用户是否允许使用精确位置，如关闭，app只能获取到用户大致位置。

 *8、Local Network

      iOS14 当 App 要使用 Bonjour 服务时或者访问本地局域网 使用 mDNS 服务等，都需要授权，开发者需要
       在 Info.plist 中详细描述使用的为哪种服务以及用途。下图为需要无需申请权限与需要授权的服务

 *9、相机和麦克风

      iOS14 中 App 使用相机和麦克风时会有图标提示以及绿点和黄点提示，并且会显示当前是哪个
       App 在使用此功能。我们无法控制是否显示该提示。

 *10、上传 AppStore

      更加严格的隐私审核，可以让用户在下载 App 之前就知道此 App将会需要哪些权限。目前苹果商店要求所有
      应用在上架时都必须提供一份隐私政策。如果引入了第三方收集用户信息等SDK，都需要向苹果说明是这些信息的用途。


 *11、WXImageView、FLAnimatedImage、YYAnimatedImage等三方库图片加载不出来

     在iOS 14之前，UIKit在调用displayLayer:之前就会去渲染UIImageView.image；而在iOS 14，UIKit则是先去调用displayLayer:，如果你实现了displayLayer:，那么UIKit就不会再去渲染了。

    @implementation WXImageView
    ...
     
    - (void)setImage:(UIImage *)image {
        [super setImage:image];
        if (image) {
            self.layer.contents = (id)image.CGImage;
        } else {
            self.layer.contents = nil;
        }
    }
     
    @end
    @implementation FLAnimatedImageView
    ...
     
    - (void)displayLayer:(CALayer *)layer {
        if (_currentFrame) {
            layer.contentsScale = _currentFrame.scale;
            layer.contents = (__bridge id)_currentFrame.CGImage;
        } else {
            // If we have no animation frames, call super implementation. iOS 14+ UIImageView use this delegate method for rendering.
            if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
               [super displayLayer:layer];
            }
        }
    }
     
    @end
    @implementation YYAnimatedImageView
    ...
     
    - (void)displayLayer:(CALayer *)layer {
        if (_curFrame) {
            layer.contentsScale = _curFrame.scale;
            layer.contents = (__bridge id)_curFrame.CGImage;
        } else {
            // If we have no animation frames, call super implementation. iOS 14+ UIImageView use this delegate method for rendering.
            if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
               [super displayLayer:layer];
            }
        }
    }
     
    @end
    上面的方式是直接到第三库源码修改，也可以通过hook的方式实现，不用去改动第三库的源码。

    @implementation WXImageViewHook
     
    + (void)load {
        Xcode12-IOS14的兼容
        if (@available(iOS 14.0, *)) {
            [self startHook];
        }
    }
     
    + (void)startHook {
        Class cls =  NSClassFromString(@"WXImageView");
     
        SEL selector = NSSelectorFromString(@"setImage:");
        
        typedef void (^WXImageViewSetImageBlock)(UIImageView* t_self, UIImage* image);
        
        WXImageViewSetImageBlock implementationBlock = ^(UIImageView* t_self, UIImage* image) {
            struct objc_super t_super = {
                .receiver = t_self,
                .super_class = class_getSuperclass([t_self class])
            };
            void(*msgSendSuper)(struct objc_super*, SEL, UIImage*) = (void*)&objc_msgSendSuper;
            msgSendSuper(&t_super, NSSelectorFromString(@"setImage:"), image);
            
            if (image) {
                t_self.layer.contents = (id)image.CGImage;
            } else {
                t_self.layer.contents = nil;
            }
        };
        
        [MKHookUtil addImplementationOfSelector:selector forClass:cls implementationBlock:implementationBlock];
    }
     
    @end
    @implementation FLAnimatedImageView (Hook)
     
    + (void)load {
        Xcode12-IOS14的兼容
        if (@available(iOS 14.0, *)) {
            [MKHookUtil swizzMethodOriginalSelector:@selector(displayLayer:) swizzledSelector:@selector(swizzing_displayLayer:) forClass:[self class]];
        }
    }
     
    - (void)swizzing_displayLayer:(CALayer *)layer {
        Ivar ivar = class_getInstanceVariable(self.class, "_currentFrame");
        UIImage *_currentFrame = object_getIvar(self, ivar);
     
        if (_currentFrame) {
            layer.contentsScale = _currentFrame.scale;
            layer.contents = (__bridge id)_currentFrame.CGImage;
        } else {
            // If we have no animation frames, call super implementation. iOS 14+ UIImageView use this delegate method for rendering.
            if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
               [super displayLayer:layer];
            }
        }
    }
     
    @end
    @implementation YYAnimatedImageView (Hook)
     
    + (void)load {
        if (@available(iOS 14.0, *)) {
            [MKHookUtil swizzMethodOriginalSelector:@selector(displayLayer:) swizzledSelector:@selector(swizzing_displayLayer:) forClass:[self class]];
        }
    }
     
    - (void)swizzing_displayLayer:(CALayer *)layer {
        Ivar ivar = class_getInstanceVariable(self.class, "_curFrame");
        UIImage *_curFrame = object_getIvar(self, ivar);
     
        if (_curFrame) {
            layer.contentsScale = _curFrame.scale;
            layer.contents = (__bridge id)_curFrame.CGImage;
        } else {
            // If we have no animation frames, call super implementation. iOS 14+ UIImageView use this delegate method for rendering.
            if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
               [super displayLayer:layer];
            }
        }
    }
     
    @end
 */


#endif /* ios_14________h */
