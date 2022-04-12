//
//  NSString+AES256.h
//  XYZ_iOS
//
//  Created by ruikaiqiang on 16/1/21.
//  Copyright © 2016年 焦点科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES128)

/**
    AES加密
 */
- (NSString *)entryptAESBase64;
- (NSString *)deentryptAESBase64;

/**
   MD5加密
*/
- (NSString *)md5String;

@end
