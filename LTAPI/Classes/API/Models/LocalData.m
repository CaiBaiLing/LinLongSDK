//
//  LocalData.m
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "LocalData.h"
#import "PrefixHeader.h"


#define KEY_IAPLIST (@"KEY_IAPLIST")
#define KEY_USERLIST (@"KEY_USERLIST")
#define KEY_RANDOMCODE (@"KEY_RANDOMCODE")
#define KEY_STARTUPTIMES @"KEY_STARTUPTIMES"
#define KEY_FIRSTOPEN @"KEY_FIRSTOPEN"
#define KEY_RSAPUBLIC @"KEY_RSAPUBLIC"
#define KEY_SERVER @"KEY_SERVER"
#define KEY_ROLENAME @"KEY_ROLENANE"
#define KEY_LEVEL @"KEY_LEVEL"
#define KEY_USERINFO (@"KEY_USERINFO")//登录成功个人信息
#define KEY_ORDERINFO (@"KEY_ORDERINFO")//订单号
#define KEY_ROLEINFO (@"KEY_ROLEINFO") //角色信息
#define KEY_PFAILEDARR (@"KEY_PFAILEDARR")//记录支付失败的信息
#define KEY_IOP (@"KEY_IOP") //IOP

static NSString * const kAgentgameKey = @"kAgentgameKey";
static NSString * const kHasShowInviteViewKey = @"kHasShowInviteViewKey";

@implementation LocalData

//添加内购数据
+ (void)addIapData:(NSDictionary *)dataDic
{
    NSArray *dataArr1 = [[NSUserDefaults standardUserDefaults] arrayForKey:KEY_IAPLIST];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:dataArr1];
    [mutableArr addObject:dataDic];
    [[NSUserDefaults standardUserDefaults] setObject:[mutableArr copy] forKey:KEY_IAPLIST];//支付失败的订单用数组保存起来
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//删除一条内购数据
+ (void)delIapData:(NSString *)order_code
{
    if (!order_code || [order_code isEqualToString:@""]) {
        return;
    }
    NSArray *iapArr = [self getIapList];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:iapArr];
    if (iapArr && [iapArr respondsToSelector:@selector(count)]) {
        NSInteger index = 0;
        for (NSDictionary *dic in mutableArr) {
            if ([dic[@"order_code"] compare:order_code options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                [mutableArr removeObjectAtIndex:index];
                break;
            }
            index++;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[mutableArr copy] forKey:KEY_IAPLIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取内购信息
+ (id)getIapList{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:KEY_IAPLIST];
}

//保存内购信息
+ (void)setIapInfo:(NSDictionary *)infoDic{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:infoDic forKey:KEY_IAPLIST];
}


//保存用户信息
+ (void)setUserInfo:(NSDictionary *)infoDic{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:infoDic forKey:KEY_USERINFO];
    [userDefault synchronize];
}

//获取用户信息
+ (NSDictionary *)getUserInfo{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:KEY_USERINFO];
}


//保存订单信息
+ (void)setOrder:(NSDictionary *)dic{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dic forKey:KEY_ORDERINFO];
    
}
+(NSDictionary *)getOrderDic{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    return [userDefault objectForKey:KEY_ORDERINFO];
}
//保存SDK订单号
+ (void)setOrderCode:(NSString *)order_code{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:order_code forKey:@"order_code"];
}
+ (NSString *)getOrderCode{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"order_code"];
}


//保存角色信息
+ (void)setRoleInfo:(NSDictionary *)infoDic{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:infoDic forKey:KEY_ROLEINFO];
    
}
+ (NSDictionary *)getRoleInfo{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:KEY_ROLEINFO];
    
}

//记录支付失败的订单
+ (void)setPFailed:(NSMutableArray *)pFailedArr{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:pFailedArr forKey:KEY_PFAILEDARR];
    
}
+ (NSMutableArray *)getPFailedArr{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:KEY_PFAILEDARR];
}

+ (void)setRandomCode:(NSString *)randomCode
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:randomCode forKey:KEY_RANDOMCODE];
}

+ (NSString *)getRandomCode
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:KEY_RANDOMCODE];
}

// 获取游戏服务，角色，等级
+ (void)setServer:(NSString *)server{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:server forKey:KEY_SERVER];
    
}
+ (NSString *)getServer{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:KEY_SERVER];
}

+ (void)setRoleName:(NSString *)roleName{
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    [userDefalts setObject:roleName forKey:KEY_ROLENAME];
    
}
+ (NSString *)getRoleName{
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    return [userDefalts objectForKey:KEY_ROLENAME];
}

+ (void)setLevel:(NSString *)Level{
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    [userDefalts setObject:Level forKey:KEY_LEVEL];
}
+ (NSString *)getLevel{
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    return [userDefalts objectForKey:KEY_LEVEL];
}

+ (void)recordTimeWithCountSeconds:(NSInteger)countSeconds{
    if (countSeconds > 0) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setInteger:countSeconds forKey:@"secondsCountDown"];
        [userDefault setObject:[NSString stringWithFormat:@"%@", [DeviceHelper getTimestamp]] forKey:@"recordTime"];
        [userDefault synchronize];
    }
    
}

+ (void)cleanTime{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"secondsCountDown"];
    [userDefault removeObjectForKey:@"recordTime"];
}

+ (NSInteger)getTime{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger time = (int)[userDefault integerForKey:@"secondsCountDown"];
    NSString *recordTime = [userDefault stringForKey:@"recordTime"];
    NSInteger passTime = [[DeviceHelper getTimestamp] longLongValue] - [recordTime longLongValue];
    if (time-passTime>=0 && passTime >= 0) {
        return time-passTime;
    }
    return 0;
}

//记录服务器启动的次数
+ (NSInteger)getStartupTimes{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger openCnt = [userDefaults integerForKey:KEY_STARTUPTIMES];
    return openCnt == 0?1:openCnt;
}

+ (void)increaseStartupTimes{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger startupTimes = [userDefaults integerForKey:KEY_STARTUPTIMES];
    startupTimes++;
    [userDefaults setInteger:startupTimes forKey:KEY_STARTUPTIMES];
}

+ (BOOL)hasInstalled{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:KEY_FIRSTOPEN];
}

+ (void)recordInstall{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:KEY_FIRSTOPEN];
}

+ (void)cleanInstall{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KEY_FIRSTOPEN];
}

+ (NSString *)rsapub{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:KEY_RSAPUBLIC];
}

+ (void)recordRsapub:(NSString *)rsaPub{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:rsaPub forKey:KEY_RSAPUBLIC];
}

#pragma mark - agentgame
+ (NSString *)getAgentgame{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kAgentgameKey];
}

+ (void)recordAgentgame:(NSString *)agentgame{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:agentgame forKey:kAgentgameKey];
}

+ (BOOL)hasShowInviteView;{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kHasShowInviteViewKey];
    
}

+ (void)hadShowInviteView{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kHasShowInviteViewKey];
}

+ (void)setIop:(NSString *)iop{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:iop forKey:KEY_IOP];
}
+ (NSString *)getIop{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:KEY_IOP];
}

@end
