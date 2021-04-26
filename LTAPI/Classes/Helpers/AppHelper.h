//
//  AppHelper.h
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject

/**
 * app显示的名字
 * @return appName的string
 */
+ (NSString *)getAppDisplayName;

/**
 * app的bundle ID，也就是套装ID
 * @return bundle ID string
 */
+ (NSString *)getAppBundleID;

/**
 * app的bundle version ，通常为build version
 * @return bundle version string
 */
+ (NSString *)getBundleVersion;

/**
 * short version，通常使用这个作为版本号
 * @return short version string
 */
+ (NSString *)getBundleShortVersion;

//判断是否填写url的identifier
+ (BOOL)isRegisteredURLIdentifier:(NSString *)identifier;

//判断是否填写url scheme
+ (BOOL)isRegisteredURLScheme:(NSString *)urlScheme;

@end
