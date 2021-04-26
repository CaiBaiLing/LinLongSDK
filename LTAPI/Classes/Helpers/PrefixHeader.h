//
//  PrefixHeader.pch
//  LTAPI
//
//  Created by 朱建洋 on 2019/11/23.
//  Copyright © 2019 朱建洋. All rights reserved.
//

#ifndef PrefixHeader_Header
#define PrefixHeader_Header

#ifdef DEBUG
#define BigLog(fmt,...) NSLog(@"[BigLog]: " fmt,##__VA_ARGS__);
#else
#define BigLog(fmt,...)
#endif
/***********************************本地配置文件******************************************/
#define SDK_CNF_DIC [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LTConfig" ofType:@"plist"]]
#define MAIN_URL SDK_CNF_DIC[@"mainURL"] //主地址
#define API_URL [NSString stringWithFormat:@"%@/router/client",MAIN_URL]
//密钥
#define CLIENT_KEY SDK_CNF_DIC[@"clientKey"]
#define CLIENT_SECRET SDK_CNF_DIC[@"clientSecret"]
 //接口地址
//#define SDK_SID @"0"//渠道ID
//#define SDK_SID SDK_CNF_DIC[@"channelID"]//渠道ID
#define INFO_DIC [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil]]

//#define SDK_SID INFO_DIC[@"channelId"]//渠道ID

#define SDK_SERVICESVERSION @"1.0.6"//sdk服务端版本号
#define DES_ENCRYPT_KEY @"12||5..8" //DES加密秘钥


/***********************************加载公共头******************************************/
#import "DeviceHelper.h"
#import "AppHelper.h"
#import "ToolsHelper.h"
#import "TipView.h"
#import <UIKit/UIKit.h>
#import "UIView+LTAPIView.h"

//常用属性设置
#define FONTARIAL @"Arial"
#define SDK_BUNDLENAME @"LTSDK.bundle"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define FUNC_FITLEN(originLen) [ToolsHelper fitLentoCurrentScreenWithOriginLen:originLen]

#define SDK_IMAGEPATH(imageName) [NSString stringWithFormat:@"%@/%@",SDK_BUNDLENAME, imageName]

#define SDK_PATHImage(imageName) [UIImage imageNamed:SDK_IMAGEPATH(imageName)]

#define SDK_IMAGE(imageName) [[UIImage imageNamed:SDK_IMAGEPATH(imageName)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

//[UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:SDK_BUNDLENAME]] pathForResource: imgName ofType:@"png"]]

#define HexColor(hexValue) HexAlphaColor(hexValue,1.f)
//[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define HexAlphaColor(hexValue,alphaValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue]

#define DEFAULTCOLOR HexColor(0xFF4500)
#define themeYellowCOLOR HexColor(0xFF8500)
#define LTSDKFont(value) [UIFont fontWithName:@"PingFang SC" size:value]

#define TEXTDEFAULTCOLOR [ToolsHelper getCurrentColorWithLightColor:HexColor(0x999999) darkColor:UIColor.whiteColor]
#define TEXTNOMARLCOLOR [ToolsHelper getCurrentColorWithLightColor:HexColor(0x333333) darkColor:UIColor.whiteColor]
#define TEXTBorderCOLOR [ToolsHelper getCurrentColorWithLightColor:HexColor(0xD7D7D7) darkColor:UIColor.whiteColor]
#define DEFAULTBGCOLOR  [ToolsHelper getCurrentColorWithLightColor:UIColor.whiteColor darkColor:HexColor(0x1B1B1E)] //getCurrentColor(UIColor.whiteColor,HexColor(0x1B1B1E))
#define MECHENTERBGCOLOR HexAlphaColor(0xFFFFFF, 0.9)

#define LTAPI_DeviceHeight UIScreen.mainScreen.bounds.size.height
#define LTAPI_DeviceWidth UIScreen.mainScreen.bounds.size.width
#define LTAPI_SubViewWidth LTSDKScale(315)
#define LTSDKScale(x)  x * (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown?UIScreen.mainScreen.bounds.size.width: UIScreen.mainScreen.bounds.size.height)/375.f)

//判断横竖屏
#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define kUIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IphoneX (kUIPhone && (MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) > 736))

//设备信息
#define TIMESTAMP [DeviceHelper getTimestamp]
#define TipsUserError @"账号6-16位数字或字母组合"
#define TipsPSDError @"密码为8-16位数字字母组合"
#define TipsPhoneNoError @"手机号或手机格式错误"
#define LTSDKVERSION @"V2.4.0"
#define LTSDPolicyURL @"https://share.8688games.com/policy.html"   //隐私协议
#define LTSDKAgreementURL @"https://share.8688games.com/agreement.html"  //注册协议
#endif /* PrefixHeader_pch */

