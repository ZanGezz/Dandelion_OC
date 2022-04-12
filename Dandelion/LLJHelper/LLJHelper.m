//
//  LLJHelper.m
//  Dandelion
//
//  Created by 刘帅 on 2019/7/17.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#define Keychain_IDFV_key @"com.dandelion.IDFV.key"

@interface LLJHelper ()


@end

@implementation LLJHelper


/**
 * 颜色生成图片
 */
+ (UIImage *)imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 是否含有emoj
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

/**
 * 根据json字符串获取数组或字典
 */
+ (id)getSetWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        return nil;
    }
    return obj;
}

/**
 * 字典转换成json
 */
+ (NSString *)dictionaryToJson:(id)arr
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 * 计算字符串长度：根据字体计算长度
 */
+ (CGSize)sizeWithString:(NSString *)string withFont:(UIFont *)font
{
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return titleSize;
}

/**
 *  G:公元时代，例如AD公元; yy:年的后2位;  yyyy:完整年; MM:月，显示为1-12; MMM:月，显示为英文月份简写,如 Jan
 *  MMMM:月，显示为英文月份全称，如 Janualy;  dd:日，2位数表示，如02;  d:日，1-2位显示，如 2; EEE:简写星期几，如Sun
 *  EEEE:全写星期几，如Sunday; aa:上下午，AM/PM; H:时，24小时制，0-23; K:时，12小时制，0-11; m:分，1-2位; mm:分，2位
 *  s:秒，1-2位; ss:秒，2位; S毫秒
 *  根据日期获取时间戳： [NSDate date]  ->  12345678987
 */
+ (NSString*)getTimeInterval:(NSDate *)date{
    
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a*1000];//转为字符型
    return timeString;
}

/**
 * 根据时间戳获取年月日周：12345678987 -> ["年","月","日","周"];
 */
+ (NSArray *)getWeekDayTime:(NSString *)dateStr
{
    if (dateStr) {
        NSArray * arrWeek = [NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[dateStr integerValue]/1000.0];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday;
        comps = [calendar components:unitFlags fromDate:date];
        NSString *week = [arrWeek objectAtIndex:([comps weekday]-1)];
        NSString *year = [NSString stringWithFormat:@"%ld",(long)[comps year]];
        NSString *month = [NSString stringWithFormat:@"%ld",(long)[comps month]];
        NSString *day = [NSString stringWithFormat:@"%ld",(long)[comps day]];
        
        return @[year,month,day,week];
    }else{
        return @[@"-",@"-",@"-",@"-"];
    }
}

/**
 * 根据时间戳：12345678987 -> 几年前或几月前或几天前或几秒前或刚刚;
 */
+ (NSString *)getMomentTime:(long long)timestamp
{
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970] ;
    long long timeDifference = nowTimestamp - timestamp/1000;
    long long second = timeDifference;
    long long minute = second/60;
    long long hour = minute/60;
    long long day = hour/24;
    long long month = day/30;
    long long year = month/12;
    
    if (1 <= year) {
        return [NSString stringWithFormat:@"%lld年前",year];
    } else if(1 <= month) {
        return [NSString stringWithFormat:@"%lld月前",month];
    } else if(1 <= day) {
        return [NSString stringWithFormat:@"%lld天前",day];
    } else if(1 <= hour) {
        return [NSString stringWithFormat:@"%lld小时前",hour];
    } else if(1 <= minute) {
        return [NSString stringWithFormat:@"%lld分钟前",minute];
    } else if(1 <= second) {
        return [NSString stringWithFormat:@"%lld秒前",second];
    } else {
        return @"刚刚";
    }
}

/**
 * 根据date和格式生成字符串：[NSDate date]及现在时间 -> yyyy:mm:dd : 2020:10:20 或
 * yyyy-mm-dd ：2020-10-20
 * yyyy年mm月dd日 ：2020年10月20日
 * 等等格式有很多自行设置
 */
+ (NSString*)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    if (date == nil || [date isEqual:[NSNull null]]) {
        return @"";
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = formatter;
    NSString *time2 = [_formatter stringFromDate:date];
    return time2;
}

/**
 * 跟上面反过来使用
 */
+ (NSDate*)dateFromString:(NSString *)date formatter:(NSString *)formatter
{
    if (date == nil || [date isEqualToString:@""] || [date isEqual:[NSNull null]]) {
        return nil;
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = formatter;
    [_formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *_date = [_formatter dateFromString:date];
    return _date;
}

/**
 * 根据时间戳生成日期：12345678987 -> yyyy:mm:dd : 2020:10:20 或
 * yyyy-mm-dd ：2020-10-20
 * yyyy年mm月dd日 ：2020年10月20日
 */
+ (NSString*)stringfromTime:(long)time formatter:(NSString *)formatter
{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = formatter;
    NSString *time1 = [_formatter stringFromDate:date];
    return time1;
}

/**
 * 根据秒生成时间：3600s -> 00:00:00即几点几分几秒  hourHidden当h=0时是否隐藏，即00:00
 */
+ (NSString *)formatSecondsToString:(NSInteger)seconds hourHidden:(BOOL)hidden
{
    NSString *hhmmss = nil;
    if (seconds < 0) {
        return @"00:00:00";
    }
    int h = (int)round((seconds%86400)/3600);
    int m = (int)round((seconds%3600)/60);
    int s = (int)round(seconds%60);
    
    if (h < 0 && hidden) {
        hhmmss = [NSString stringWithFormat:@"%02d:%02d", m, s];
    }else{
        hhmmss = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    }
    return hhmmss;
}

/**
 * 压缩修改图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

/**
 * 生成图片验证码
 */
+ (UIImage *)imageCodeViewWithStr:(NSString *)imageCodeStr{
    
    UIView *imageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 40)];
    CGSize textSize = [@"W" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    //每个label能随机产生的位置的point.x的最大范围
    int randWidth = (imageBgView.frame.size.width)/imageCodeStr.length - textSize.width;
    //每个label能随机产生的位置的point.y的最大范围
    int randHeight = imageBgView.frame.size.height - textSize.height;
    for (int i = 0; i<imageCodeStr.length; i++) {
        //随机生成每个label的位置CGPoint(x,y)
        CGFloat px = arc4random()%randWidth + i*(imageBgView.frame.size.width-3)/imageCodeStr.length;
        CGFloat py = arc4random()%randHeight;
        UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake(px+3, py, textSize.width, textSize.height)];
        label.text = [NSString stringWithFormat:@"%C",[imageCodeStr characterAtIndex:i]];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = LLJColor(246, 100, 100, 1);
        //label是否是可以是斜的，isRotation这个属性暴露在外面，可进行设置
        double r = (double)arc4random() / ARC4RAND_MAX * 2 - 1.0f;//随机生成-1到1的小数
        if (r>0.3) {
            r=0.3;
        }else if(r<-0.3){
            r=-0.3;
        }
        label.transform = CGAffineTransformMakeRotation(r);
        [imageBgView addSubview:label];
    }
    
    for (int i = 0; i<10; i++) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat pX = arc4random() % (int)CGRectGetWidth(imageBgView.frame);
        CGFloat pY = arc4random() % (int)CGRectGetHeight(imageBgView.frame);
        [path moveToPoint:CGPointMake(pX, pY)];
        CGFloat ptX = arc4random() % (int)CGRectGetWidth(imageBgView.frame);
        CGFloat ptY = arc4random() % (int)CGRectGetHeight(imageBgView.frame);
        [path addLineToPoint:CGPointMake(ptX, ptY)];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [[UIColor getRandenColorWithNumBer:0.2] CGColor];//layer的边框色
        layer.lineWidth = 1.0f;
        layer.strokeEnd = 1;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        [imageBgView.layer addSublayer:layer];
    }
    
    UIGraphicsBeginImageContext(imageBgView.bounds.size);
    [imageBgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 邮箱是否有效
 */
+ (BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        return YES;
    }
    else {
        return NO;
    }
}

/**
 * 只输入6-16位数字 字母和字符
 */
+(BOOL)isValidateString:(NSString *)myString
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"$_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [myString rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        return FALSE;
    }else{
        if (myString.length < 6 || myString.length > 16) {
            return FALSE;
        }else{
            return TRUE;
        }
    }
}

/**
 * 只输入数字小数点
 */
+ (BOOL)validateNumberAndPoint:(NSString*)number
{
    
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    int i =0;
    while (i < number.length) {
        
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

/**
 * 手机号合法
 */
+ (BOOL)checkTelNumber:(NSString*)mobile
{
    if (mobile.length < 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(175)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

/**
 * 转码为UTF8格式字符串
 */
+ (NSString *)changeToUTF8String:(NSString *)subString{
    NSString *utf8 = [subString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return utf8;
}

/**
 * UTF8转码为正常格式字符串
 */
+ (NSString *)UTF8changeToCommenString:(NSString *)subString{
    NSString *commen = [subString stringByRemovingPercentEncoding];
    return commen;
}

/**
 * 根据模型名称和实例将模型数据赋值给实例，不改变实例指针；
 */
+ (void)recoverDataByEntityName:(NSString *)entityName model:(id)model instance:(id)instance{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([NSClassFromString(entityName) class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [instance setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
}

/**
 * 比较版本大小newVersion大于oldVersion返回yes
 */
+ (BOOL)checkVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion{
    
    NSArray *old = [oldVersion componentsSeparatedByString:@"."];
    NSArray *new = [newVersion componentsSeparatedByString:@"."];
    
    for (int i = 0; i < new.count; i ++) {
        
        NSString *oldNum,*newNum;
        if (old.count > i) {
            oldNum = old[i];
        }else{
            oldNum = @"0";
        }
        newNum = new[i];
        if (oldNum.integerValue < newNum.integerValue) {
            return YES;
        }
    }
    return NO;
}


/**
 * 获取设备名称 例如：梓辰的手机
 */
+ (NSString *)deviceName{
    return [[UIDevice currentDevice] name];
}

/**
 * 获取设备名称 ipone
 */
+ (NSString *)deviceModel{
    return [[UIDevice currentDevice] model];
}

/**
 *  系统名称
 */
+ (NSString *)systemName{
    return [UIDevice currentDevice].systemName;
}
/**
 * 获取设备系统版本
 */
+ (NSString *)systemVersion{
    return [UIDevice currentDevice].systemVersion;
}

/**
 * app版本
 */
+ (NSString *)currentAppVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 * 获取设备UUID
 */
+ (NSString *)deviceUUID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


/**  获取UUID*/
+ (NSString *)getUUIDByKeyChain{
    // 这个key的前缀最好是你的BundleID
    NSString*strUUID = (NSString*)[self load:Keychain_IDFV_key];
    //首次执行该方法时，uuid为空
    if([strUUID isEqualToString:@""] || !strUUID)
    {
        // 获取UUID 这个是要引入<AdSupport/AdSupport.h>的
        strUUID = [self deviceUUID];
        
        if(strUUID.length ==0 || [strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"])
        {
            //生成一个uuid的方法
            CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);
            strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
            CFRelease(uuidRef);
        }
        
        //将该uuid保存到keychain
        [self save:Keychain_IDFV_key data:strUUID];
    }
    return strUUID;
}
+ (NSMutableDictionary*)getKeychainQuery:(NSString*)service {
    return[NSMutableDictionary dictionaryWithObjectsAndKeys:
           (id)kSecClassGenericPassword,(id)kSecClass,
           service,(id)kSecAttrService,
           service,(id)kSecAttrAccount,
           (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
           nil];
}
+ (void)save:(NSString*)service data:(id)data{
    //Get search dictionary
    NSMutableDictionary*keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to searchdictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data]forKey:(id)kSecValueData];
    //Add item to keychain with the searchdictionary
    SecItemAdd((CFDictionaryRef)keychainQuery,NULL);
}
+ (id)load:(NSString*)service {
    id ret =nil;
    NSMutableDictionary*keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we areexpecting only a single attribute to be returned (the password) wecan set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData =NULL;
    if(SecItemCopyMatching((CFDictionaryRef)keychainQuery,(CFTypeRef*)&keyData) ==noErr){
        @try{
            ret =[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)keyData];
        }@catch(NSException *e) {
        }@finally{
        }
    }
    if(keyData)
        CFRelease(keyData);
    return ret;
}
+ (void)deleteKeyData:(NSString*)service {
    NSMutableDictionary*keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

/**
 * 获取系统亮度
 */
+ (CGFloat)getSystemBright {
    return [UIScreen mainScreen].brightness;
}

/**
 * 设置系统亮度
 */
+ (void)setSystemBright:(CGFloat)value {
    [[UIScreen mainScreen] setBrightness:value];
}

/**
 * 获取系统声音
 */
+ (CGFloat)getSystemVolume {
    return LLJSg.volumeValue;
}

/**
 * 设置系统声音
 */
+ (void)setSystemVolume:(CGFloat)value {
    LLJSg.volumeValue = value;
}

/**
 * 创建本地文件夹路径
 */
+ (BOOL)createSourcePath:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

/**
 * 创建本地文件路径
 */
+ (BOOL)createFilePath:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return YES;
}

/**
 * 获取路径下子文件
 */
+ (NSArray *)getFilesWithPath:(NSString *)path {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}

/**
 TODO:删除本地文件
 
 @param path 文件地址
 */
+ (BOOL)deleteFileByPath:(NSString *)path {
    
    NSURL *url = [NSURL fileURLWithPath:path];
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (blHave) {
        blHave = [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
    return blHave;
}
/**
 TODO:删除本地所以文件

 */
+ (BOOL)deleteAllFileByPath:(NSString *)path {
    
    BOOL remove = NO;
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *str in arr) {
        NSString *path1 = [path stringByAppendingPathComponent:str];
        remove = [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:path1] error:nil];
    }
    return remove;
}

/**
  TODO:退出app
 */
+ (void)exitApplication {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.height / 2, window.bounds.size.width, 0.5);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

@end
