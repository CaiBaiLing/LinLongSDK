//
//  NSString+StrHelper.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StrHelper)
///字符串进行md5加密
- (NSString *)getMD5Str;

///验证邮箱格式是否正确
- (BOOL)isRegularEmail;

- (BOOL)isRegularChinaPhone;

- (BOOL)isRegularEmailWithoutAlert;

//验证帐号格式是否正确
- (BOOL)isRegularUname;

///验证密码格式是否正确
- (BOOL)isRegularPasswd;

///身份证格式是否正确
- (BOOL)isIdCard;

- (NSDictionary*)parseURL;

- (NSString *)URLEncodedString;

- (NSString *)timestrToTimeformat;

- (NSString *)urlParamsToMD5;
- (NSData *)dataWithBase64Encoded;
- (BOOL)includeChinese;
- (NSString *) utf8ToUnicode;
/**
    随机生成指定长度用户名(字符串以字母开头)
 */
+ (NSString *)getRoundAccountWihtLenth:(NSInteger)lenth;
/**
    随机生成指定长度密码(字符串以字母开头)
 */
+ (NSString *)getRoundPsswordWihtLenth:(NSInteger)lenth;

@end
