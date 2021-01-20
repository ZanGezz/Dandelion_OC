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
 * TODO:颜色生成图片
 */
+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;
/**
 * TODO:是否含有emoj
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;
/**
 * TODO:根据json字符串获取数组或字典
 */
+ (id)getSetWithJsonString:(NSString *)jsonString;
/**
 * TODO:字典转换成json
 */
+ (NSString *)dictionaryToJson:(id)arr;
/**
 * TODO:计算字符串长度：根据字体计算长度
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
 * TODO:根据时间戳获取年月日周：12345678987 -> ["年","月","日","周"];
 */
+ (NSArray *)getWeekDayTime:(NSString *)dateStr;
/**
 * TODO:根据时间戳：12345678987 -> 几年前或几月前或几天前或几秒前或刚刚;
 */
+ (NSString *)getMomentTime:(long long)timestamp;

/**
 * TODO:根据date和格式生成字符串：[NSDate date]及现在时间 -> yyyy:mm:dd : 2020:10:20 或
 * yyyy-mm-dd ：2020-10-20
 * yyyy年mm月dd日 ：2020年10月20日
 * 等等格式有很多自行设置
 */
+ (NSString*)stringFromDate:(NSDate*)date formatter:(NSString*)formatter;
/**
 * TODO:跟上面反过来使用
 */
+ (NSDate*)dateFromString:(NSString *)date formatter:(NSString *)formatter;

/**
 * TODO:根据时间戳生成日期：12345678987 -> yyyy:mm:dd : 2020:10:20 或
 * TODO:yyyy-mm-dd ：2020-10-20
 * TODO:yyyy年mm月dd日 ：2020年10月20日
 */
+ (NSString*)stringfromTime:(long)time formatter:(NSString *)formatter;
/**
 * TODO:根据秒生成时间：3600s -> 00:00:00即几点几分几秒  hourHidden当h=0时是否隐藏，即00:00
 */
+ (NSString *)formatSecondsToString:(NSInteger)seconds hourHidden:(BOOL)hidden;


/**
 * TODO:压缩修改图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 * TODO:生成图片验证码
 */
+ (UIImage *)imageCodeViewWithStr:(NSString *)imageCodeStr;

/**
 * TODO:邮箱是否有效
 */
+ (BOOL)validateEmail:(NSString*)email;
/**
 * TODO:只输入6-16位数字 字母和字符
 */
+ (BOOL)isValidateString:(NSString *)myString;
/**
 * TODO:只输入数字小数点
 */
+ (BOOL)validateNumberAndPoint:(NSString*)number;
/**
 * TODO:手机号合法
 */
+ (BOOL)checkTelNumber:(NSString*)telNumber;
/**
 * TODO:转码为UTF8格式字符串
 */
+ (NSString *)changeToUTF8String:(NSString *)subString;
/**
 * TODO:UTF8转码为正常格式字符串
 */
+ (NSString *)UTF8changeToCommenString:(NSString *)subString;

/**
 * TODO:根据模型名称和实例将模型数据赋值给实例，不改变实例指针；
 */
+ (void)recoverDataByEntityName:(NSString *)entityName model:(id)model instance:(id)instance;
/**
 * TODO:比较版本大小newVersion大于oldVersion返回yes
 */
+ (BOOL)checkVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion;

/**
 * TODO:获取设备名称 例如：梓辰的手机
 */
+ (NSString *)deviceName;
/**
 * TODO:获取设备名称 ipone
 */
+ (NSString *)deviceModel;
/**
 *  TODO:系统名称
 */
+ (NSString *)systemName;
/**
 * TODO:获取设备系统版本
 */
+ (NSString *)systemVersion;
/**
 * TODO:app版本
 */
+ (NSString *)currentAppVersion;
/**
 * TODO:获取设备UUID
 */
+ (NSString *)deviceUUID;
/**
 * TODO:获取设备UUID
 */
+ (NSString *)getUUIDByKeyChain;

/**
 * TODO:获取系统亮度
 */
+ (CGFloat)getSystemBright;

/**
 * TODO:设置系统亮度
 */
+ (void)setSystemBright:(CGFloat)value;

/**
 * TODO:获取系统声音
 */
+ (CGFloat)getSystemVolume;

/**
 * TODO:设置系统声音
 */
+ (void)setSystemVolume:(CGFloat)value;

/**
 * TODO:创建本地文件夹路径
 */
+ (BOOL)createSourcePath:(NSString *)path;

/**
 * TODO:创建本地文件路径
 */
+ (BOOL)createFilePath:(NSString *)path;
/**
 * TODO:获取路径下子文件
 */
+ (NSArray *)getFilesWithPath:(NSString *)path;

/**
 * TODO:删除本地文件
 * @param path 文件地址
 */

+ (BOOL)deleteFileByPath:(NSString *)path;
/**
 * TODO:删除本地所以文件
 */
+(BOOL)deleteAllFileByPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
