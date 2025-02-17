//
//  AppDelegate.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.

//  ~/Library/Group Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Assets/TemporaryItems/MobileApps 找到.ipa

#import "AppDelegate.h"
#import "LLJTabBarController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()

@property (nonatomic) BOOL foreGround;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化单例
    [LLJCoreDataHelper helper];
    
    //检测网络变化
    [LLJNetWork monitorNetworking];
    
    //设置语言
    [FWLangageHelper setNewLangage:[FWLangageHelper currentLangage]];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[LLJTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    
    //*******听云崩溃日志获取********
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler); //设置异常Log信息的处理
    
    //NSArray *array = @[@"2"];
    //NSString *str = [array objectAtIndex:2];
    NSLog(@"kkkkk = %f",LLJStatusBarHeight);
    
    [self log];
    
    return YES;
}

//*******听云崩溃日志获取********
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"exception = %@",exception);
}


/*
 *** 从其他app分享公共资源到本app
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if (self.window) {
        if (url) {
            NSString *fileName = url.lastPathComponent; // 从路径中获得完整的文件名（带后缀）
            // path 类似这种格式：file:///private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
            NSString *path = url.absoluteString; // 完整的url字符串
            path = [self URLDecodedString:path]; // 解决url编码问题
            
            NSMutableString *string = [[NSMutableString alloc] initWithString:path];
            
            if ([path hasPrefix:@"file://"]) { // 通过前缀来判断是文件
                // 去除前缀：/private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
                [string replaceOccurrencesOfString:@"file://" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, path.length)];
                
                // 此时获取到文件存储在本地的路径，就可以在自己需要使用的页面使用了
                NSDictionary *dict = @{@"fileName":fileName,
                                       @"filePath":string};
                
                return YES;
            }
        }
    }
    return YES;
}
// 当文件名为中文时，解决url编码问题
- (NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)log {
    
    for (int i = 1; i < 10; i ++) {
        for (int j = 0; j < i; j ++) {
            printf("*");
        }
        printf("%d", i);
        printf("\n");
    }
}


@end
