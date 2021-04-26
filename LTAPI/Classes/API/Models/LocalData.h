//
//  LocalData.h
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject
+ (id)getIapList;
+ (void)addIapData:(NSDictionary *)dataDic;

+ (void)delIapData:(NSString *)order_code;

//+ (void)setUserInfo:(NSDictionary *)infoDic;
//+ (NSDictionary *)getUserInfo;

+ (void)setRoleInfo:(NSDictionary *)infoDic;
+ (NSDictionary *)getRoleInfo;
//保存订单信息
+ (void)setOrder:(NSDictionary *)dic;
+(NSDictionary *)getOrderDic;
//保存SDK订单号
+ (void)setOrderCode:(NSString *)order_code;
+ (NSString *)getOrderCode;

//获取游戏区服，角色，游戏等级
+ (void)setServer:(NSString *)server;
+ (NSString *)getServer;

+ (void)setRoleName:(NSString *)roleName;
+ (NSString *)getRoleName;

+ (void)setLevel:(NSString *)Level;
+ (NSString *)getLevel;


//记录支付失败的订单
+ (void)setPFailed:(NSMutableArray *)pFailedArr;
+ (NSMutableArray *)getPFailedArr;

//记录城市信息，通过公网ip地址访问淘宝接口获取
+ (void)recordTimeWithCountSeconds:(NSInteger)countSeconds;
+ (void)cleanTime;
+ (NSInteger)getTime;

//记录服务器启动的次数
+ (NSInteger)getStartupTimes;
+ (void)increaseStartupTimes;
+ (BOOL)hasInstalled;
+ (void)recordInstall;
+ (void)cleanInstall;

+ (void)setIop:(NSString *)iop;
+ (NSString *)getIop;

#pragma mark - rsapublic key
+ (NSString *)rsapub;
+ (void)recordRsapub:(NSString *)rsaPub;

#pragma mark - agentgame
+ (NSString *)getAgentgame;
+ (void)recordAgentgame:(NSString *)agentgame;
+ (BOOL)hasShowInviteView;
+ (void)hadShowInviteView;

@end
