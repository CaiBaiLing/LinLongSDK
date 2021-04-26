//
//  LTSDK.h
//  BigSDK
//
//  Created by zhengli on 2018/5/9.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//支付参数
extern NSString *_Nonnull const key_out_trade_no;
extern NSString *_Nonnull const key_product_price;
extern NSString *_Nonnull const key_product_count;
extern NSString *_Nonnull const key_product_id;
extern NSString *_Nonnull const key_product_name;
extern NSString *_Nonnull const key_product_desc;
extern NSString *_Nonnull const key_exchange_rate;
extern NSString *_Nonnull const key_currency_name;

//角色参数
extern NSString *_Nonnull const key_role_id ;
extern NSString *_Nonnull const key_server_name;
extern NSString *_Nonnull const key_server_id;
extern NSString *_Nonnull const key_role_name;
extern NSString *_Nonnull const key_party_name;
extern NSString *_Nonnull const key_role_level;
extern NSString *_Nonnull const key_role_vip;
extern NSString *_Nonnull const key_role_balance;
extern NSString *_Nonnull const key_rolelevel_ctime;
extern NSString *_Nonnull const key_rolelevel_mtime;
extern NSString *_Nonnull const key_role_type ;

//厂商需求 extend
extern NSString *_Nonnull const key_extendString ;

extern NSString *_Nonnull const LTSDKACOUNTQUITNOTIFYKEY;/**<切换账号通知Key*/
///请求回调类型 responseDic 回调数据
typedef void (^MainThreadCallBack)(NSDictionary * _Nullable responseDic);
///请求回调类型    isSucess 是否成功，message 提示信息   responseDic 回调数据
typedef void (^LTRequestResult)(BOOL isSucess,NSString *_Nullable message,NSDictionary * _Nullable responseDic);

@interface LTSDK : NSObject

///SDK登入接口，只有在登入成功的时候才会激活回调，登入失败则由sdk处理
+ (void)showLoginWithCallBack:(_Nullable MainThreadCallBack)receiverBlock;
+ (void)showLoginWithRequestBack:(_Nullable LTRequestResult)requestBlock;

///退出登入
+ (void)logoutWithCallBack:(_Nullable MainThreadCallBack)receiverBlock;
+ (void)logoutWithRequestBack:(_Nullable LTRequestResult)requestBlock;

///设置角色信息
+ (void)setRoleInfo:(nonnull NSDictionary *)roleInfo;
+ (void)setRoleInfo:(nonnull NSDictionary *)roleInfo requestResult:(_Nullable LTRequestResult)result;

///支付接口(只对订单请求做回调，不监听支付结果)
+ (void)buy:(nonnull NSDictionary *)info failedBlock:(void (^ _Nullable)(void))failedBlock;

///获取SDK版本号
+ (nonnull NSString *)getVersion;

@end
