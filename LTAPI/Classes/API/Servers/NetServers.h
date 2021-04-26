//
//  NetServers.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingEngine.h"
#import "RequestHelper.h"
typedef NS_ENUM(NSInteger, SearchType) {
    SEARCHTYPE_GAME = 0,
    SEARCHTYPE_SERVER = 1,
};

//注册方式
typedef NS_ENUM(NSInteger, RegisterType) {
    REGISTERTYPE_PHONE = 1, //手机
    REGISTERTYPE_NORMAL = 2, //普通
    REGISTERTYPE_GUEST = 3, //游客
};

//send smscode type
typedef NS_ENUM(NSInteger, SmscodeType) {
    SMSCODETYPE_REGISTER = 1,
    SMSCODETYPE_LOGIN = 2,
    SMSCODETYPE_CHANGEPASSWD = 3,
    SMSCODETYPE_CHANGEINFO = 4,
};

@interface NetServers : NSObject
/** 用户注册
 @param name 用户名
 @param psd 密码
 @param handler 回调
*/
+(NetworkingEngine *)userRegistWithUserName:(NSString *)name psd:(NSString *)psd completedHandler:(RequestDicHanlder)handler;

/**手机注册
 @param phoneNo 手机号
 @param passwd  密码
 @param vercode 验证码
 @param handler 回调

 */
+(NetworkingEngine *)mobileRegistPhoneNo:(NSString *)phoneNo passwd:(NSString *)passwd vercode:(NSString *)vercode completedHandler:(RequestDicHanlder)handler;

/**发送验证码
 @param phoneNo 手机号
 */
+ (NetworkingEngine *)sendSmscodeWithPhoneNo:(NSString *)phoneNo completedHandler:(RequestDicHanlder)handler;

/**重置密码
 @param phoneNo 手机号
 @param passwd  密码
 @param vercode 验证码
 @param handler 回调
*/
+(NetworkingEngine *)mobileRepasswdWithPhoneNo:(NSString *)phoneNo passwd:(NSString *)passwd vercode:(NSString *)vercode completedHandler:(RequestDicHanlder)handler;

/**忘记密码发送验证码
 
    @param phoneNo 手机号
*/
+ (NetworkingEngine *)sendFotgotSmscodeWithPhoneNo:(NSString *)phoneNo completedHandler:(RequestDicHanlder)handler;

/**普通用户登录
 
    @param account  账号
    @param psd  密码
 */
+(NetworkingEngine *)loginWithAccount:(NSString *)account psd:(NSString *)psd completedHandler:(RequestDicHanlder)handler;
//游戏公告
+(NetworkingEngine *)getActivityListWithCompletedHandler:(RequestArrHanlder)handler;
//获取充值通道
+(NetworkingEngine *)getRechageTypeOCompletedHandler:(RequestDicHanlder)handler;
//游客登入
+(NetworkingEngine *)fastLoginRegiest:(NSString *)account password:(NSString *)pwd CompletedHandler:(RequestDicHanlder)handler;

/**实名认证
 
 @param name 真实姓名
 @param ids 身份证号
 @param handler 回调
 */
+(NetworkingEngine *)userAuthWithName:(NSString *)name ids:(NSString *)ids CompletedHandler:(RequestDicHanlder)handler;

//登出
+(NetworkingEngine *)logoutWithCompletedHandler:(RequestDicHanlder)handler;

//添加订单
+(NetworkingEngine *)addOrderWithParaDic:(NSDictionary *)paraDic CompletedHandler:(RequestDicHanlder)handler;
//充值豆点
+(NetworkingEngine *)rechageECoinWithType:(NSString *)type payFee:(NSString *)fee completedHandler:(RequestDicHanlder)handler;
//查询订单
+(NetworkingEngine *)queryPStatusWithOrderID:(NSString *)orderID ompletedHandler:(RequestDicHanlder)handler;

//获取支付TOKEN
+(NetworkingEngine *)getOrderWithIOP:(NSDictionary *)paraDic ompletedHandler:(RequestDicHanlder)handler;

//角色信息提交
+(NetworkingEngine *)submitRoleinfoWithParaDic:(NSDictionary *)paraDic CompletedHandler:(RequestDicHanlder)handler;

//苹果验单
+ (NetworkingEngine *)appleVerifyWithTransactionId:(NSString *)transactionId
                                     receiptString:(NSString *)receiptString
                                        Order_code:(NSString *)order_code
                                  completedHandler:(RequestDicHanlder)handler;
/**获取订单列表*/
+(NetworkingEngine *)getOrderList:(NSInteger)page CompletedHandler:(RequestDicHanlder)handler;

/**修改密码
 
 @param originPsd 原密码
 @param newPsd 新密码
 @param handler 回调
 */
+(NetworkingEngine *)resetPassword:(NSString *)originPsd newPsd:(NSString *)newPsd CompletedHandler:(RequestDicHanlder)handler;

/** 获取绑定手机号验证码
 
 @param mobile 手机号
 @param handler 回调
*/
+(NetworkingEngine *)getBindMobilerCode:(NSString *)mobile CompletedHandler:(RequestDicHanlder)handler;

/** 绑定手机号
 
 @param mobile     手机号
 @param veriCode 验证码
 @param handler   回调
 */
+ (NetworkingEngine *)bindMobiler:(NSString *)mobile veriCode:(NSString *)veriCode passwd:(NSString *)password CompletedHandler:(RequestDicHanlder)handler;

/** 获取客服信息 */
+ (NetworkingEngine *)getSystemServiceCompletedHandler:(RequestDicHanlder)handler;

/**更换绑定手机获取验证码*/
+ (NetworkingEngine *)getChangePhoneCodCompletedHandler:(RequestDicHanlder)handler;

/**校验更换绑定手机号验证码
 
    @param veriCode   验证码
 */
+ (NetworkingEngine *)checkChangPhoneCode:(NSString *)veriCode completedHandler:(RequestDicHanlder)handler;

/**通过手机号修改验证码
 
    @param veriCode   验证码
    @param password   密码
 */
+ (NetworkingEngine *)changePasswordForPhoneCode:(NSString *)veriCode password:(NSString *)password  completedHandler:(RequestDicHanlder)handler;

/**修改密码获取验证码*/
+ (NetworkingEngine *)getChangePasswordCodCompletedHandler:(RequestDicHanlder)handler;

/**更换绑定的手机
 
 @param phone   更换的手机号
 @param veriCode   验证码
 @param oldcode   老手机的验证码
 */
+ (NetworkingEngine *)changeMobileBindPhone:(NSString *)phone veriCode:(NSString *)veriCode oldcode:(NSString *)oldcode  completedHandler:(RequestDicHanlder)handler;

+ (NSString *)getPayUrl:(NSString *)orderCode;

/**获取首页UI配置*/
+ (NetworkingEngine *)getHomeConfigCompletedHandler:(RequestDicHanlder)handler;

/**领取礼包
 @param giftId  礼包ID
 */
+ (NetworkingEngine *)getUserInfoGetGift:(NSString *)giftId completedHandler:(RequestDicHanlder)handler;

/**礼包列表
@param pages  页码
*/
+ (NetworkingEngine *)getUserInfoGiftList:(NSInteger)pages completedHandler:(RequestDicHanlder)handler;

/**已领取礼包列表
@param pages  页码
*/
+ (NetworkingEngine *)getUserInfoGiftUseList:(NSInteger)pages completedHandler:(RequestDicHanlder)handler;

/**礼包详情
@param giftId  礼包ID
*/
+ (NetworkingEngine *)getUserInfoGetGiftInfo:(NSString *)giftId completedHandler:(RequestDicHanlder)handler;

/**获取推广码
*/
+ (NSString *)getPageSid;
@end
