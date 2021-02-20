//
//  LLJHelper.h
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJHelper : NSObject

/**
 * 颜色生成图片
 */
+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;
/**
 * 是否含有emoj
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;
/**
 * 根据json字符串获取数组或字典
 */
+ (id)getSetWithJsonString:(NSString *)jsonString;
/**
 * 字典转换成json
 */
+ (NSString *)dictionaryToJson:(id)arr;
/**
 * 计算字符串长度：根据字体计算长度
 */
+ (CGSize)sizeWithString:(NSString *)string withFont:(UIFont *)font;

/**
 *  G:公元时代，例如AD公元; yy:年的后2位;  yyyy:完整年; MM:月，显示为1-12; MMM:月，显示为英文月份简写,如 Jan
 *  MMMM:月，显示为英文月份全称，如 Janualy;  dd:日，2位数表示，如02;  d:日，1-2位显示，如 2; EEE:简写星期几，如Sun
 *  EEEE:全写星期几，如Sunday; aa:上下午，AM/PM; H:时，24小时制，0-23; K:时，12小时制，0-11; m:分，1-2位; mm:分，2位
 *  s:秒，1-2位; ss:秒，2位; S毫秒
 *  根据日期获取时间戳： [NSDate date]  ->  12345678987
 */
+ (NSString*)getTimeInterval:(NSDate *)date;
/**
 * 根据时间戳获取年月日周：12345678987 -> ["年","月","日","周"];
 */
+ (NSArray *)getWeekDayTime:(NSString *)dateStr;
/**
 * 根据时间戳：12345678987 -> 几年前或几月前或几天前或几秒前或刚刚;
 */
+ (NSString *)getMomentTime:(long long)timestamp;

/**
 * 根据date和格式生成字符串：[NSDate date]及现在时间 -> yyyy:mm:dd : 2020:10:20 或
 * yyyy-mm-dd ：2020-10-20
 * yyyy年mm月dd日 ：2020年10月20日
 * 等等格式有很多自行设置
 */
+ (NSString*)stringFromDate:(NSDate*)date formatter:(NSString*)formatter;
/**
 * 跟上面反过来使用
 */
+ (NSDate*)dateFromString:(NSString *)date formatter:(NSString *)formatter;

/**
 * 根据时间戳生成日期：12345678987 -> yyyy:mm:dd : 2020:10:20 或
 * yyyy-mm-dd ：2020-10-20
 * yyyy年mm月dd日 ：2020年10月20日
 */
+ (NSString*)stringfromTime:(long)time formatter:(NSString *)formatter;
/**
 * 根据秒生成时间：3600s -> 00:00:00即几点几分几秒  hourHidden当h=0时是否隐藏，即00:00
 */
+ (NSString *)formatSecondsToString:(NSInteger)seconds hourHidden:(BOOL)hidden;


/**
 * 压缩修改图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 * 生成图片验证码
 */
+ (UIImage *)imageCodeViewWithStr:(NSString *)imageCodeStr;

/**
 * 邮箱是否有效
 */
+ (BOOL)validateEmail:(NSString*)email;
/**
 * 只输入6-16位数字 字母和字符
 */
+ (BOOL)isValidateString:(NSString *)myString;
/**
 * 只输入数字小数点
 */
+ (BOOL)validateNumberAndPoint:(NSString*)number;
/**
 * 手机号合法
 */
+ (BOOL)checkTelNumber:(NSString*)telNumber;
/**
 * 转码为UTF8格式字符串
 */
+ (NSString *)changeToUTF8String:(NSString *)subString;
/**
 * UTF8转码为正常格式字符串
 */
+ (NSString *)UTF8changeToCommenString:(NSString *)subString;

/**
 * 根据模型名称和实例将模型数据赋值给实例，不改变实例指针；
 */
+ (void)recoverDataByEntityName:(NSString *)entityName model:(id)model instance:(id)instance;
/**
 * 比较版本大小newVersion大于oldVersion返回yes
 */
+ (BOOL)checkVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion;

/**
 * 获取设备名称 例如：梓辰的手机
 */
+ (NSString *)deviceName;
/**
 * 获取设备名称 ipone
 */
+ (NSString *)deviceModel;
/**
 * 系统名称
 */
+ (NSString *)systemName;
/**
 * 获取设备系统版本
 */
+ (NSString *)systemVersion;
/**
 * app版本
 */
+ (NSString *)currentAppVersion;
/**
 * 获取设备UUID
 */
+ (NSString *)deviceUUID;
/**
 * 获取设备UUID
 */
+ (NSString *)getUUIDByKeyChain;

/**
 * 获取系统亮度
 */
+ (CGFloat)getSystemBright;

/**
 * 设置系统亮度
 */
+ (void)setSystemBright:(CGFloat)value;

/**
 * 获取系统声音
 */
+ (CGFloat)getSystemVolume;

/**
 * 设置系统声音
 */
+ (void)setSystemVolume:(CGFloat)value;

/**
 * 创建本地文件夹路径
 */
+ (BOOL)createSourcePath:(NSString *)path;

/**
 * 创建本地文件路径
 */
+ (BOOL)createFilePath:(NSString *)path;
/**
 * 获取路径下子文件
 */
+ (NSArray *)getFilesWithPath:(NSString *)path;

/**
 * 删除本地文件
 * @param path 文件地址
 */

+ (BOOL)deleteFileByPath:(NSString *)path;
/**
 * 删除本地所以文件
 */
+(BOOL)deleteAllFileByPath:(NSString *)path;

/**
 * 退出app
 */
+ (void)exitApplication;

@end

NS_ASSUME_NONNULL_END
