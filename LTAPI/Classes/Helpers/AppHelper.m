//
//  AppHelper.m
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "AppHelper.h"
#import "PrefixHeader.h"
@implementation AppHelper

/**
 * app显示的名字
 * @return appName的string
 */
+ (NSString *)getAppDisplayName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/**
 * app的bundle ID，也就是套装ID
 * @return bundle ID string
 */
+ (NSString *)getAppBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/**
 * app的bundle version ，通常为build version
 * @return bundle version string
 */
+ (NSString *)getBundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

/**
 * short version，通常使用这个作为版本号
 * @return short version string
 */
+ (NSString *)getBundleShortVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//判断是否填写url的identifier
+ (BOOL)isRegisteredURLIdentifier:(NSString *)identifier
{
    static dispatch_once_t fetchBundleOnce;
    static NSArray *urlTypes = nil;
    
    dispatch_once(&fetchBundleOnce, ^{
        urlTypes = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleURLTypes"];
    });
    for (NSDictionary *urlType in urlTypes) {
        NSString *urlIdentifier = [urlType valueForKey:@"CFBundleURLName"];
        if ([urlIdentifier isEqualToString:identifier]) {
            return YES;
        }
    }
    return NO;
}

//判断是否填写url scheme
+ (BOOL)isRegisteredURLScheme:(NSString *)urlScheme
{
    static dispatch_once_t fetchBundleOnce;
    static NSArray *urlTypes = nil;
    
    dispatch_once(&fetchBundleOnce, ^{
        urlTypes = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleURLTypes"];
    });
    for (NSDictionary *urlType in urlTypes) {
        NSArray *urlSchemes = [urlType valueForKey:@"CFBundleURLSchemes"];
        if ([urlSchemes containsObject:urlScheme]) {
            return YES;
        }
    }
    return NO;
}

@end
