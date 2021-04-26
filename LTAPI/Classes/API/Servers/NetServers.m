//
//  NetServers.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "NetServers.h"
#import "RequestHelper.h"
#import "LocalData.h"
#import "DataManager.h"
#import "PrefixHeader.h"
#import "NSDictionary+TransformUntils.h"

static NSString *LTAPIHomeLogin_userRegedit = @"sdk.user.reg";/**<普通注册*/
static NSString *LTAPIHomeLogin_phoneRegedit = @"sdk.user.reg.mobile";/**<手机注册*/
static NSString *LTAPIHomeLogin_regeditMsgSend = @"sdk.sms.reg.send";/**<发送验证码*/
static NSString *LTAPIHomeLogin_forgotPassword = @"sdk.user.pwd.iforgot";/**<通过手机号重置密码*/
static NSString *LTAPIHomeLogin_forgotMsgSend = @"sdk.sms.iforgot.send";/**<忘记密码发送验证码*/
static NSString *LTAPIHomeLogin_userLogin = @"sdk.user.login";/**<普通登录*/
static NSString *LTAPIHomeActivityList = @"sdk.notice.list";/**<公告*/
static NSString *LTAPIHomeRechageType = @"sdk.pay.type";/**<充值通道*/
static NSString *LTAPIHomeRechageOrder = @"sdk.point.add";/**<充值豆点*/

static NSString *LTAPIHomeLogin_userFastLogin = @"sdk.user.login.tmp";/**<游客登入*/
static NSString *LTAPIHomeLogin_userLogout = @"sdk.user.logout";/**<登出*/
static NSString *LTAPIProdectOrder_addOrder = @"sdk.order.add";/**<添加订单*/
static NSString *LTAPIProdectOrder_selectOrder = @"sdk.order.get";/**<查询订单*/
static NSString *LTAPIProdectOrder_getPayToken = @"sdk.order.iop.get";/**<获取支付TOKEN*/
static NSString *LTAPIProdectOrder_sendToken = @"sdk.apple.iap.notify";/**<苹果验单--向SDK服务器验单*/
static NSString *LTAPIUserInfo_upDateGameInfo = @"sdk.user.role.update";/**<更新角色的信息*/

static NSString *LTAPIUserInfo_userAuth = @"sdk.user.auth";/**<实名认证*/
static NSString *LTAPIUserInfo_getUserInfo = @"router/user";/**<用户中心*/
static NSString *LTAPIUserInfo_getChangePhoneCode = @"sdk.sms.change.send";/**<更换手机号获取验证码*/
static NSString *LTAPIUserInfo_codeCheck = @"sdk.sms.change.check";/**<更换手机号验证码校验*/
static NSString *LTAPIUserInfo_reSetPassword = @"sdk.user.pwd.set";/**<修改密码*/
static NSString *LTAPIUserInfo_getOrderList = @"sdk.order.list";/**<订单列表*/
static NSString *LTAPIUserInfo_setMobileBind = @"sdk.user.mobile.bind";/**绑定手机号*/
static NSString *LTAPIUserInfo_getMobileSendCode = @"sdk.sms.bind.send";/***绑定手机号获取验证码*/
static NSString *LTAPIUserInfo_getSystemService = @"sdk.system.service";/**<客服信息*/
static NSString *LTAPIUserInfo_getEditPsdSendCode = @"sdk.sms.verify.send";/**<修改密码获取验证码*/
static NSString *LTAPIUserInfo_changePsd = @"sdk.user.pwd.mobile";/**<短信验证码修改密码*/
static NSString *LTAPIUserInfo_mobileBindChange = @"sdk.user.mobile.bind.change";/**<换绑手机号*/
static NSString *LTAPIConfig_homeConfg = @"sdk.app.init";/**<换绑手机号*/

static NSString *LTAPIUserInfo_getGift = @"sdk.user.gift.get";/**<领取礼包*/
static NSString *LTAPIUserInfo_getGiftList = @"sdk.gift.list";/**<获取礼包列表*/
static NSString *LTAPIUserInfo_getGiftUseList = @"sdk.user.gift.list";/**<已领取礼包列表*/
static NSString *LTAPIUserInfo_getGiftInfo = @"sdk.gift.get";/**<礼包详情*/

@implementation NetServers

+ (NSDictionary *)commomParas:(NSString *)method {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:[self getSystemParas]];
    [paramDic setObject:method?:@"" forKey:@"method"];
    return paramDic;
}

//系统参数
+ (NSDictionary *)getSystemParas {
    NSAssert(CLIENT_KEY !=nil, @"CLIENT_KEY 不能为空请检查LTConfig.h文件配置");
    NSString *deviceInfo = [NSString stringWithFormat:@"%@||%@",[DeviceHelper getDeviceType],[DeviceHelper getSystemVersion]];
    return @{@"client_key":CLIENT_KEY,@"timestamp":TIMESTAMP,@"v":SDK_SERVICESVERSION,@"sdk_v":LTSDKVERSION,@"format":@"json",@"device":deviceInfo,@"imei":[DeviceHelper getOpenUDID]};
}

///用户session 参数
+ (NSDictionary *)publicUserParas:(NSDictionary *)paras {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paras?:@{}];
    NSString *uid = [LTSDKUserModel shareManger].uid;
    NSString *session = [LTSDKUserModel shareManger].session;
    [dic addEntriesFromDictionary:@{@"uid":uid?:@"",@"session":session?:@""}];
    return dic;
}

+ (NSMutableDictionary *)commonParameWithParame:(NSMutableDictionary *)param requestURL:(NSString *)requestUrl {
    if (!param) {
        param = [NSMutableDictionary dictionary];
    }
    if ([param isKindOfClass:[NSDictionary class]]) {
        param = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    NSString *channelId = @"0";
    
    if(DataManager.sharedDataManager.sid.length > 0 ){
        channelId = DataManager.sharedDataManager.sid;
    }else {
        if (INFO_DIC[@"channelId"]) {
            channelId = INFO_DIC[@"channelId"];
        }
    }
    [param setObject:channelId forKey:@"sid"];
    NSDictionary *dic = [self commomParas:requestUrl];
    [param addEntriesFromDictionary:dic];
    NSString *sign = [ToolsHelper getSign:param];
    [param setObject:sign forKey:@"sign"];
    return param;
}

+ (NetworkingEngine *)userRegistWithUserName:(NSString *)name psd:(NSString *)psd completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithDictionary:@{@"uname":name?:@"",@"passwd":psd?:@"",@"imei":[DeviceHelper getOpenUDID]}];
    parame = [self commonParameWithParame:parame requestURL:LTAPIHomeLogin_userRegedit];
    return [RequestHelper requestWithParamsDic:parame httpMethod:@"POST" requestMethod:LTAPIHomeLogin_userRegedit completedHandler:handler];
}

+(NetworkingEngine *)mobileRegistPhoneNo:(NSString *)phoneNo passwd:(NSString *)passwd vercode:(NSString *)vercode completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":phoneNo?:@"",@"vercode":vercode?:@"",@"passwd":passwd?:@"",@"imei":[DeviceHelper getOpenUDID]?:@""}];
     parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIHomeLogin_phoneRegedit];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIHomeLogin_phoneRegedit completedHandler:handler];
}

/***获取验证码*/
+(NetworkingEngine *)sendSmscodeWithPhoneNo:(NSString *)phoneNo completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":phoneNo?:@"",@"type":@"reg"}];
     parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIHomeLogin_regeditMsgSend];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIHomeLogin_regeditMsgSend completedHandler:handler];
}

+(NetworkingEngine *)mobileRepasswdWithPhoneNo:(NSString *)phoneNo passwd:(NSString *)passwd vercode:(NSString *)vercode completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":phoneNo?:@"",@"vercode":vercode?:@"",@"passwd":passwd?:@""}];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIHomeLogin_forgotPassword];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIHomeLogin_forgotPassword completedHandler:handler];
}

+ (NetworkingEngine *)sendFotgotSmscodeWithPhoneNo:(NSString *)phoneNo completedHandler:(RequestDicHanlder)handler {
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":phoneNo?:@""}];
    parame = [self commonParameWithParame:parame requestURL:LTAPIHomeLogin_forgotMsgSend];
    return [RequestHelper requestWithParamsDic:parame httpMethod:@"POST" requestMethod:LTAPIHomeLogin_forgotMsgSend completedHandler:handler];
}

//普通登录   
+(NetworkingEngine *)loginWithAccount:(NSString *)account psd:(NSString *)psd completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:@{@"uname":account?:@"",@"passwd":psd?:@""}];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIHomeLogin_userLogin];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIHomeLogin_userLogin completedHandler:handler];
}
//游戏公告
+(NetworkingEngine *)getActivityListWithCompletedHandler:(RequestArrHanlder)handler
{
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:@{}];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIHomeActivityList];
    return [RequestHelper requestWithDic:parameDic httpMethod:@"POST" requestMethod:LTAPIHomeActivityList completedHandler:handler];

    
    
}

//游客登入
//@{@"imei":[DeviceHelper getOpenUDID], @"sid":sidStr}//游客登入
+(NetworkingEngine *)fastLoginRegiest:(NSString *)account password:(NSString *)pwd CompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:@{@"imei":[DeviceHelper getOpenUDID]}];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIHomeLogin_userFastLogin];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIHomeLogin_userFastLogin completedHandler:handler];
}

//实名认证
+(NetworkingEngine *)userAuthWithName:(NSString *)name ids:(NSString *)ids CompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary: [self publicUserParas:nil]];
    [parameDic addEntriesFromDictionary: @{@"realname":name,@"idcard":ids}];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_userAuth];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_userAuth completedHandler:handler];
}

//登出
+(NetworkingEngine *)logoutWithCompletedHandler:(RequestDicHanlder)handler {
    NSDictionary *parameDic = [self commomParas:LTAPIHomeLogin_userLogout];
    NSMutableDictionary *mParaDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:parameDic]];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIHomeLogin_userLogout completedHandler:handler];
}

//订单类
+(NetworkingEngine *)addOrderWithParaDic:(NSDictionary *)paraDic CompletedHandler:(RequestDicHanlder)handler {
    NSDictionary *parasDic = [self commomParas:LTAPIProdectOrder_addOrder];
    NSMutableDictionary *mParaDic = [NSMutableDictionary dictionaryWithDictionary:paraDic];
    [mParaDic addEntriesFromDictionary:[self publicUserParas:parasDic]];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    BigLog(@"----111111-----");
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIProdectOrder_addOrder completedHandler:handler];
    
}
//查询订单
+(NetworkingEngine *)queryPStatusWithOrderID:(NSString *)orderID ompletedHandler:(RequestDicHanlder)handler {
    NSDictionary *parameDic = [self commomParas:LTAPIProdectOrder_selectOrder];
    NSMutableDictionary *mParaDic = [NSMutableDictionary dictionaryWithDictionary:parameDic];
    [mParaDic addEntriesFromDictionary:[self publicUserParas:@{@"order_code":orderID}]];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    BigLog(@"-----44444");
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIProdectOrder_selectOrder completedHandler:handler];
}

//获取支付TOKEN
+(NetworkingEngine *)getOrderWithIOP:(NSDictionary *)paraDic ompletedHandler:(RequestDicHanlder)handler {
    NSDictionary *parameDic = [self commomParas:LTAPIProdectOrder_getPayToken];
    NSMutableDictionary *mParaDic = [NSMutableDictionary dictionaryWithDictionary:parameDic];
    [mParaDic addEntriesFromDictionary:[self publicUserParas:@{@"order_code":paraDic[@"order_code"],@"type":paraDic[@"type"]}]];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    BigLog(@"-----333333");
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIProdectOrder_getPayToken completedHandler:handler];
}
//获取充值通道
+(NetworkingEngine *)getRechageTypeOCompletedHandler:(RequestDicHanlder)handler {
    
    NSDictionary *parameDic = [self commomParas:LTAPIHomeRechageType];
    NSMutableDictionary *mParaDic = [NSMutableDictionary dictionaryWithDictionary:parameDic];
    [mParaDic addEntriesFromDictionary:[self publicUserParas:mParaDic]];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIHomeRechageType completedHandler:handler];
}
//充值豆点
+(NetworkingEngine *)rechageECoinWithType:(NSString *)type payFee:(NSString *)fee completedHandler:(RequestDicHanlder)handler {
    
    NSDictionary *parameDic = [self commomParas:LTAPIHomeRechageOrder];
    NSMutableDictionary *mParaDic = [NSMutableDictionary dictionaryWithDictionary:parameDic];
    [mParaDic addEntriesFromDictionary:[self publicUserParas:@{@"type":type,@"pay_fee":fee}]];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIHomeRechageOrder completedHandler:handler];
}

//苹果验单--向SDK服务器验单
+ (NetworkingEngine *)appleVerifyWithTransactionId:(NSString *)transactionId receiptString:(NSString *)receiptString Order_code:(NSString *)order_code completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *mParaDic = [NSMutableDictionary dictionaryWithDictionary:@{@"product_id":transactionId,@"receipt":receiptString,@"order_code":order_code}];
    [mParaDic addEntriesFromDictionary:[self commomParas:LTAPIProdectOrder_sendToken]];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    BigLog(@"-----22222");
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIProdectOrder_sendToken completedHandler:handler];
}

//角色的提交
+ (NetworkingEngine *)submitRoleinfoWithParaDic:(NSDictionary *)paraDic CompletedHandler:(RequestDicHanlder)handler {
    NSString *uid = [LTSDKUserModel shareManger].uid;// [[LocalData getUserInfo] objectForKey:@"uid"];
    NSDictionary *parameDic = [self commomParas:LTAPIUserInfo_upDateGameInfo];
    NSMutableDictionary *mParaDic = [NSMutableDictionary new];
    [mParaDic setObject:uid?:@"" forKey:@"uid"];
    if (!INFO_DIC[@"channelId"]) {
        [mParaDic setObject:@"0" forKey:@"sid"];
    }else{
        [mParaDic setObject:INFO_DIC[@"channelId"] forKey:@"sid"];
    }
    [mParaDic addEntriesFromDictionary:paraDic];
    [mParaDic addEntriesFromDictionary:parameDic];
    NSString *sign = [ToolsHelper getSign:mParaDic];
    [mParaDic setObject:sign forKey:@"sign"];
    //BigLog(@"角色提交数据=%@",mParaDic);
    return [RequestHelper requestWithParamsDic:mParaDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_upDateGameInfo completedHandler:handler];
}

//获取订单列表
+ (NetworkingEngine *)getOrderList:(NSInteger)page CompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"page":[NSString stringWithFormat:@"%ld",(long)(page<=0?1:page)]}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getOrderList];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getOrderList completedHandler:handler];
}

+ (NetworkingEngine *)resetPassword:(NSString *)originPsd newPsd:(NSString *)newPsd CompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"new_passwd":newPsd?:@"",@"passwd":originPsd?:@""}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_reSetPassword];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_reSetPassword completedHandler:handler];
}

+ (NetworkingEngine *)getBindMobilerCode:(NSString *)mobile CompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"mobile":mobile?:@""}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getMobileSendCode];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getMobileSendCode completedHandler:handler];
}

+ (NetworkingEngine *)bindMobiler:(NSString *)mobile veriCode:(NSString *)veriCode passwd:(NSString *)password CompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"mobile":mobile?:@"",@"vercode":veriCode?:@"",@"passwd":password?:@""}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_setMobileBind];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_setMobileBind completedHandler:handler];
}

+ (NetworkingEngine *)getSystemServiceCompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getSystemService];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getSystemService completedHandler:handler];
}

+ (NetworkingEngine *)getChangePhoneCodCompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:nil]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getChangePhoneCode];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getChangePhoneCode completedHandler:handler];
}

+ (NetworkingEngine *)checkChangPhoneCode:(NSString *)veriCode completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"vercode":veriCode?:@""}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_codeCheck];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_codeCheck completedHandler:handler];
}

+ (NetworkingEngine *)getChangePasswordCodCompletedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:nil]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getEditPsdSendCode];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getEditPsdSendCode completedHandler:handler];
}

+ (NetworkingEngine *)changePasswordForPhoneCode:(NSString *)veriCode password:(NSString *)password  completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"vercode":veriCode?:@"",@"passwd":password?:@""}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_changePsd];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_changePsd completedHandler:handler];
}

+ (NetworkingEngine *)changeMobileBindPhone:(NSString *)phone veriCode:(NSString *)veriCode oldcode:(NSString *)oldcode  completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"mobile":phone,@"vercode":veriCode?:@"",@"oldcode":oldcode?:@""}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_mobileBindChange];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_mobileBindChange completedHandler:handler];
}

+ (NetworkingEngine *)getUserInfoGetGift:(NSString *)giftId completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"gift_id":giftId}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getGift];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getGift completedHandler:handler];
}

+ (NetworkingEngine *)getUserInfoGiftList:(NSInteger)pages completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"page":@(pages)}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getGiftList];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getGiftList completedHandler:handler];
}

+ (NetworkingEngine *)getUserInfoGiftUseList:(NSInteger)pages completedHandler:(RequestDicHanlder)handler{
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"page":@(pages)}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getGiftUseList];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getGiftUseList completedHandler:handler];
}

+ (NetworkingEngine *)getUserInfoGetGiftInfo:(NSString *)giftId completedHandler:(RequestDicHanlder)handler {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{@"gift_id":giftId}]];
    parameDic = [self commonParameWithParame:parameDic requestURL:LTAPIUserInfo_getGiftInfo];
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIUserInfo_getGiftInfo completedHandler:handler];
}

+ (NSString *)getPayUrl:(NSString *)orderCode {
    NSAssert(orderCode.length > 0, @"orderCode 为空或格式不正确");
    NSMutableDictionary *parame =[NSMutableDictionary dictionaryWithDictionary:[self publicUserParas:@{
        @"client_key":CLIENT_KEY,
        @"order_code":orderCode,
        @"timestamp":TIMESTAMP,
    }] ];
    NSString *sign = [ToolsHelper getSign:parame];
    parame[@"sign"] = sign;
    NSString *parameString = [parame toURLParamsString];
    NSString *url = [NSString stringWithFormat:@"%@/router/payment?%@",MAIN_URL,parameString];
    return url;
}

+ (NetworkingEngine *)getHomeConfigCompletedHandler:(RequestDicHanlder)handler {
    NSDictionary *parameDic = [self commonParameWithParame:nil requestURL:LTAPIConfig_homeConfg];;
    return [RequestHelper requestWithParamsDic:parameDic httpMethod:@"POST" requestMethod:LTAPIConfig_homeConfg completedHandler:handler];
}

+ (NSString *)getPageSid {
    __block NSString *sid = @"";
    NSString *path1 = [NSBundle mainBundle].bundlePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dicpath = [fileManager subpathsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/",path1] error:nil];
    [dicpath enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = obj;
        if ([path hasPrefix:@"sid_"]) {
            sid = path;
            return;
        }
    }];
    
    if (sid.length <= 0) {
        return @"";
    }
   sid = [sid componentsSeparatedByString:@"_"].lastObject;
   return sid;
}

@end
