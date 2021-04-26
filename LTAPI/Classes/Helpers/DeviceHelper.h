//
//  DeviceHelper.h
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, DeviceScreenType) {
    DeviceScreenInch3_5 = 0,
    DeviceScreenInch4_0,
    DeviceScreenInch4_7,
    DeviceScreenInch5_5,
    DeviceScreenIpad,
    DeviceScreenUnKnow
};

@interface DeviceHelper : NSObject

/**
 * 获取设备系统版本号
 * @return 设备系统版本的string 例如:11.3
 */
+ (NSString *)getSystemVersion;

/**
 * 获取设备型号
 * @return 设备型号string 例如:iPhone10,3
 */
+ (NSString *)getDeviceType;

///**
// * 获取当前设备使用网络类型(2G,3G,4G,WIFI等等)
// * @return 网络型号的string 0无网络,1蜂窝,2wifi
// */
//+ (NSString *)getNetworkType;

/**
 * 获取当前屏幕的编程frame
 * @return 设备屏幕的编程frame
 */
+ (CGRect)getScreenFrame;

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
+ (NSString *)getOpenUDID;

/**
 * 获取系统语言
 * @return 返回语言string
 */
+ (NSString *)getSystemLanguages;

/**
 * 设备类型
 * @return 返回
 */
+ (DeviceScreenType)getDeviceScreenType;

/**
 * 时间戳 - 秒级
 * @return 返回时间戳string
 */
+ (NSString *)getTimestamp;

/**
 * 时间戳 - 毫秒级
 * @return 返回时间戳string
 */
+ (NSString *)getSTimestamp;

@end
