//
//  DeviceHelper.m
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "DeviceHelper.h"
#import <sys/sysctl.h> //检索系统信息和允许适当的进程设置系统信息
//#import "Reachability.h"
#import "OpenUDID.h"
#import "PrefixHeader.h"

@implementation DeviceHelper

/**
 * 获取设备系统版本号
 * @return 设备系统版本的string 例如:11.3
 */
+ (NSString *)getSystemVersion
{
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion;
}

/**
 * 获取设备型号
 * @return 设备型号string 例如:iPhone10,3
 */
+ (NSString *)getDeviceType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *deviceType = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return deviceType;
}
//+(NSString *)exchangeDeviceStrWith:(NSString *)platform
//{
//    NSString *resultStr;
//        if ([platform isEqualToString:@"iPhone5,1"]) resultStr = @"iPhone 5";
//        if ([platform isEqualToString:@"iPhone5,2"]) resultStr = @"iPhone 5";
//        if ([platform isEqualToString:@"iPhone5,3"]) resultStr = @"iPhone 5c";
//        if ([platform isEqualToString:@"iPhone5,4"]) resultStr = @"iPhone 5c";
//        if ([platform isEqualToString:@"iPhone6,1"]) resultStr = @"iPhone 5s";
//        if ([platform isEqualToString:@"iPhone6,2"]) resultStr = @"iPhone 5s";
//        if ([platform isEqualToString:@"iPhone7,1"]) resultStr = @"iPhone 6 Plus";
//        if ([platform isEqualToString:@"iPhone7,2"]) resultStr = @"iPhone 6";
//        if ([platform isEqualToString:@"iPhone8,1"]) resultStr = @"iPhone 6s";
//        if ([platform isEqualToString:@"iPhone8,2"]) resultStr = @"iPhone 6s Plus";
//        if ([platform isEqualToString:@"iPhone8,4"]) resultStr = @"iPhone SE";
//        if ([platform isEqualToString:@"iPhone9,1"]) resultStr = @"iPhone 7";
//        if ([platform isEqualToString:@"iPhone9,2"]) resultStr = @"iPhone 7 Plus";
//        if ([platform isEqualToString:@"iPhone10,1"]) resultStr = @"iPhone 8";
//        if ([platform isEqualToString:@"iPhone10,4"]) resultStr = @"iPhone 8";
//        if ([platform isEqualToString:@"iPhone10,2"]) resultStr = @"iPhone 8 Plus";
//        if ([platform isEqualToString:@"iPhone10,5"]) resultStr = @"iPhone 8 Plus";
//        if ([platform isEqualToString:@"iPhone10,3"]) resultStr = @"iPhone X";
//        if ([platform isEqualToString:@"iPhone10,6"]) resultStr = @"iPhone X";
//        if ([platform isEqualToString:@"iPhone11,2"]) resultStr = @"iPhone XS";
//        if ([platform isEqualToString:@"iPhone11,6"]) resultStr = @"iPhone XS MAX";
//        if ([platform isEqualToString:@"iPhone11,8"]) resultStr = @"iPhone XR";
//        if ([platform isEqualToString:@"iPhone12,1"]) resultStr = @"iPhone 11";
//        if ([platform isEqualToString:@"iPhone12,3"]) resultStr = @"iPhone 11 Pro";
//        if ([platform isEqualToString:@"iPhone12,5"]) resultStr = @"iPhone 11 Pro Max";
//    return resultStr ;
//}
/**
 * 获取当前设备使用网络类型(2G,3G,4G,WIFI等等)
 * @return 网络型号的string 0无网络,1蜂窝,2wifi
 */
//+ (NSString *)getNetworkType
//{
//    //最好使用苹果官网，使用中国其他网站有时候无法得到正确的网络状态
//    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
//
//    //0无网络,1蜂窝,2wifi
//    return [NSString stringWithFormat:@"%ld",internetStatus];
//}

/**
 * 获取当前屏幕的编程frame
 * @return 设备屏幕的编程frame
 */
+ (CGRect)getScreenFrame
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    return CGRectMake(0, 0, width>height?width:height, width>height?height:width);
}

/*
 在iOS 5发布时，uniqueIdentifier被弃用了，这引起了广大开发者需要寻找一个可以替代UDID，
 并且不受苹果控制的方案。由此OpenUDID成为了当时使用最广泛的开源UDID替代方案。
 OpenUDID在工程中实现起来非常简单，并且还支持一系列的广告提供商。
 NSString *openUDID = [OpenUDID value];
 
 OpenUDID利用了一个非常巧妙的方法在不同程序间存储标示符 — 在粘贴板中用了一个特殊的名称来存储标示符。
 通过这种方法，别的程序（同样使用了OpenUDID）知道去什么地方获取已经生成的标示符（而不用再生成一个新的）。
 
 之前已经提到过，在将来，苹果将开始强制使用advertisingIdentifier 或identifierForVendor。
 如果这一天到来的话，即使OpenUDID看起来是非常不错的选择，但是你可能不得不过渡到苹果推出的方法。
 示例: 0d943976b24c85900c764dd9f75ce054dc5986ff
 */
+ (NSString *)getOpenUDID
{
    NSString *openUDID = [OpenUDID value];
    return openUDID?:@"";
}

/**
 * 获取系统语言
 * @return 返回语言string
 */
+ (NSString *)getSystemLanguages
{
    NSArray *languages = [NSLocale preferredLanguages];
    return [languages objectAtIndex:0]?:@"";
}

/**
 * 设备类型
 * @return 返回
 */
+ (DeviceScreenType)getDeviceScreenType
{
    //通过获取当前屏幕的较长边的长度，捕捉当前屏幕信息,获取正当的途径。
    float ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    float ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    float RealHeight = ScreenHeight>ScreenWidth?ScreenHeight:ScreenWidth;
    if (480==RealHeight){
        return DeviceScreenInch3_5;
    }
    else if (568==RealHeight){
        return DeviceScreenInch4_0;
    }
    else if (1024==RealHeight){
        return DeviceScreenIpad;
    }
    else if (667==RealHeight){
        return DeviceScreenInch4_7;
    }
    else if (736==RealHeight){
        return DeviceScreenInch5_5;
    }
    else{
        return DeviceScreenUnKnow;
    }
}

/**
 * 时间戳 - 秒级
 * @return 返回时间戳string
 */
+ (NSString *)getTimestamp
{
    double secondTime=[[[NSDate alloc]init]timeIntervalSince1970];
    NSString * secondTimeStr=[NSString stringWithFormat:@"%f",secondTime];
    NSRange pointRange=[secondTimeStr rangeOfString:@"."];
    NSString * MSTime=[secondTimeStr substringToIndex:pointRange.location];
    return MSTime;
}

/**
 * 时间戳 - 毫秒级
 * @return 返回时间戳string
 */
+ (NSString *)getSTimestamp
{
    double secondTime=[[[NSDate alloc]init]timeIntervalSince1970]*1000;
    NSString * secondTimeStr=[NSString stringWithFormat:@"%f",secondTime];
    NSRange pointRange=[secondTimeStr rangeOfString:@"."];
    NSString * MSTime=[secondTimeStr substringToIndex:pointRange.location];
    
    return MSTime;
}

@end
