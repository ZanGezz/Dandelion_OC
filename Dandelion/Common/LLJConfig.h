//
//  LLJConfig.h
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#ifndef LLJConfig_h
#define LLJConfig_h


//打印log
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//尺寸
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width                            //屏幕宽
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height                           //屏幕高
#define LLJNAV_HEIGHT  64                                                                     //导航栏高
#define LLJNavBarHeight 44.0
#define LLJStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height  //状态栏高度
#define LLJTopHeight (LLJStatusBarHeight + LLJNavBarHeight)
#define LLJTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度
#define LLJBottomSafeHeight 34.0

//弱引用
#define LLJWeakSelf(a) __weak __typeof(a) weakSelf = a

//机型判断
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)) : NO)

//颜色
#define LLJColor(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
#define LLJCommenColor LLJColor(92,72,102,1)

#define LLJPurpleColor LLJColor(105,97,127,1)
#define LLJBlackColor [UIColor blackColor]
#define LLJWhiteColor [UIColor whiteColor]
#define LLJGreyColor LLJColor(0,0,0,0.8)
#define LLJLightGreyColor LLJColor(0,0,0,0.3)


//字体
#define LLJCommenFont  [UIFont systemFontOfSize:iPhone5?14:16]
#define LLJFont(font)  [UIFont systemFontOfSize:iPhone5?(font-2):font]
#define LLJBoldFont(font)  [UIFont boldSystemFontOfSize:iPhone5?(font-2):font]
#define LLJFontName(name,font)  [UIFont fontWithName:name size:iPhone5?(font-2):font]

#define LLJLargeFont  LLJBoldFont(18)
#define LLJStandardFont  LLJFont(16)
#define LLJMediumFont  LLJFont(14)
#define LLJSmallFont  LLJFont(12)



//适配
//iphonex系列 尺寸比例系数
#define iPhoneXRatio (SCREEN_HEIGHT / 812)
//竖屏使用
#define LLJD_X(x) ((x)*SCREEN_WIDTH/375)
#define LLJD_Y(y) (((y)*(iPhoneX ? SCREEN_HEIGHT - 145*iPhoneXRatio : SCREEN_HEIGHT))/667)
#define LLJD_OffSetY(y) ((y)*((SCREEN_HEIGHT - LLJTopHeight - LLJTabBarHeight)/(667 - LLJTopHeight - LLJTabBarHeight)))
//竖屏使用以414 x 896为基础
#define LLJD_S(size) ((size)*SCREEN_WIDTH/414)
#define LLJD_O(offset) offset*(SCREEN_HEIGHT - LLJTopHeight - LLJTabBarHeight)/(896 - LLJTopHeight - LLJTabBarHeight)
//边距
#define LLJSideOffSet  LLJD_S(20)


//判断数组是否为空
#define IS_VALID_ARRAY(array) (array && ![array isEqual:[NSNull null]] && [array isKindOfClass:[NSArray class]] && [array count])
//判断字符串是否为空
#define IS_VALID_STRING(string) (string && ![string isEqual:[NSNull null]] && [string isKindOfClass:[NSString class]] && [string length])
//判断字典是否为空
#define IS_VALID_DIC(dic) !(dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//根视图
#define kRootView [UIApplication sharedApplication].keyWindow.viewForLastBaselineLayout

//Directory存储路径
#define LLJ_Base_Path  [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LLJSource"]

//CoreData永久存储路径
#define LLJ_CoreData_Path  [LLJ_Base_Path stringByAppendingPathComponent:@"CoreData"]

//文件缓存路径
#define LLJ_FWCache_Path  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"FWCache"]

//图片缓存路径
#define LLJ_image_Path  [LLJ_Base_Path stringByAppendingPathComponent:@"image"]
//视频缓存路径
#define LLJ_video_Path  [LLJ_Base_Path stringByAppendingPathComponent:@"video"]
//视频录制路径
#define LLJ_videoRecord_Path  [LLJ_Base_Path stringByAppendingPathComponent:@"videoRecord"]
//视频下载路径
#define LLJ_videoDownLoad_Path  [LLJ_Base_Path stringByAppendingPathComponent:@"videoDownLoad"]

#define ARC4RAND_MAX 0x100000000

//系统版本
#define SYSTEM_VERSION_GRETER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif /* LLJConfig_h */
