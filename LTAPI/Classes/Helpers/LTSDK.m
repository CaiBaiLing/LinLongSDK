//
//  LTSDK.m
//  BigSDK
//
//  Created by zhengli on 2018/5/9.
//  Copyright © 2018年 zhengli. All rights reserved.
//


#import "LTSDK.h"
#import "LocalData.h"
#import "NetServers.h"
#import "LTAViewManger.h"
#import "PrefixHeader.h"
#import "LTSuspensionBall.h"
#import "DataManager.h"
#import "LTAutonymRealNameView.h"
NSString *const LTSDKACOUNTQUITNOTIFYKEY = @"acountQuitNotifyKey";

@implementation LTSDK

//登入接口
+ (void)showLoginWithCallBack:(MainThreadCallBack)receiverBlock{
    [self showLoginWithRequestBack:^(BOOL isSucess, NSString * _Nullable message, NSDictionary * _Nullable responseDic) {
        !receiverBlock?:receiverBlock(responseDic);
    }];
}

+ (void)showLoginWithRequestBack:(LTRequestResult)requestBlock {
    DataManager.sharedDataManager.sid = [NetServers getPageSid];
    BigLog(@"\n----------BigSDK Login--SDK_V%@----------",LTSDKVERSION);
    [LTSDK getHomeConfigComplent:^{
        [[LTAViewManger manage] loginViewSuccessCallBack:^(BOOL isSucess,NSString *message, NSDictionary *responseDic) {
            !requestBlock?:requestBlock(isSucess,message,responseDic);
            
            
        }];
    }];
}

//登出接口
+ (void)logoutWithCallBack:(MainThreadCallBack)receiverBlock{
    [self logoutWithRequestBack:^(BOOL isSucess, NSString * _Nullable message, NSDictionary * _Nullable responseDic) {
        !receiverBlock?:receiverBlock(responseDic);
    }];
}

+ (void)logoutWithRequestBack:(LTRequestResult)requestBlock {
    BigLog(@"\n----------BigSDK Logout----------");
    [[LTAViewManger manage] logoutWithCallBack:^(BOOL isSucess,NSString *message, NSDictionary *responseDic) {
        !requestBlock?:requestBlock(isSucess,message,responseDic);
    }];
}

//设置角色
+ (void)setRoleInfo:(NSDictionary *)roleInfo{
    [self setRoleInfo:roleInfo requestResult:nil];
}

+ (void)setRoleInfo:(nonnull NSDictionary *)roleInfo requestResult:(_Nullable LTRequestResult)result {
    BigLog(@"\n----------BigSDK setRoleInfo----------");
//       [TipView showPreloader];
       NSString *uid = [DataManager sharedDataManager].userInfo.uid;//[[LocalData getUserInfo] objectForKey:@"uid"];
       if (!uid) {
           [TipView toast:@"请先登入"];
           return;
       }
       if (!roleInfo[key_role_type]) {
           [TipView toast:@"lost role_type"];
           return;
       }
       if (!roleInfo[key_server_id]) {
           [TipView toast:@"lost server_id"];
           return;
       }
       if (!roleInfo[key_server_name]) {
           [TipView toast:@"lost server_name"];
           return;
       }
       if (!roleInfo[key_role_id]) {
           [TipView toast:@"lost role_id"];
           return;
       }
       if (!roleInfo[key_role_name]) {
           [TipView toast:@"lost role_name"];
           return;
       }
       if (!roleInfo[key_party_name]) {
           [TipView toast:@"lost role_partyname"];
           return;
       }
       if (!roleInfo[key_role_level]) {
           [TipView toast:@"lost role_level"];
           return;
       } if (!roleInfo[key_role_vip]) {
           [TipView toast:@"lost role_roleVIP"];
           return;
       }
       if (!roleInfo[key_role_balance]) {
           [TipView toast:@"lost role_balance"];
           return;
       }
       if (!roleInfo[key_rolelevel_ctime]) {
           [TipView toast:@"lost role_ctime"];
           return;
       } if (!roleInfo[key_rolelevel_mtime]) {
           [TipView toast:@"lost role_mtime"];
           return;
       }
       [LocalData setRoleInfo:roleInfo];
       [NetServers submitRoleinfoWithParaDic:roleInfo CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
           [TipView hidePreloader];
//           if (debug == 1) {
////               [TipView toast:msg];
//               !result?:result(YES,msg,infoDic);
//               return;
//           }
//           !result?:result(NO,msg,infoDic);
           !result?:result(code,msg,infoDic);
       }];
}

//支付接口
+ (void)buy:(NSDictionary *)info failedBlock:(void (^)(void))failedBlock{
    BigLog(@"\n----------BigSDK buyInfo----------");
    [TipView showPreloader];
    NSString *uid = [DataManager sharedDataManager].userInfo.uid;//[[LocalData getUserInfo] objectForKey:@"uid"];
    NSString *session = [DataManager sharedDataManager].userInfo.session;//[[LocalData getUserInfo] objectForKey:@"session"];
    //NSAssert([DataManager sharedDataManager].userInfo.session.length > 0, @"❌❌❌❌❌❌❌❌❌❌❌❌❌session为空请先登录❌❌❌❌❌❌❌❌❌❌❌❌");
    //NSAssert([DataManager sharedDataManager].userInfo.uid.length > 0, @"❌❌❌❌❌❌❌❌❌❌❌❌❌uid为空请先登录❌❌❌❌❌❌❌❌❌❌❌❌");

    if (!session.length) {
        [TipView toast:@"lost session"];
        return;
    }
    if (!uid.length) {
         [TipView toast:@"lost session"];
         return;
     }
    if (!info[key_out_trade_no]) {
        [TipView toast:@"lost out_trade_no"];
        return;
        
    }
    if (!info[key_product_price]) {
        [TipView toast:@"lost product_price"];
        return;
    }
    if (!info[key_product_count]) {
        [TipView toast:@"lost product_count"];
        return;
    }
    if (!info[key_product_id]) {
        [TipView toast:@"lost productID"];
        return;
    }
    if (!info[key_product_name]) {
        [TipView toast:@"lost product_name"];
        return;
    }
    if (!info[key_product_desc]) {
        [TipView toast:@"lost product_desc"];
        return;
    }
    if (!info[key_exchange_rate]) {
        [TipView toast:@"lost exchange_rate"];
        return;
        
    }
    if (!info[key_currency_name]) {
        [TipView toast:@"lost currency_name"];
        return;
    }
    if (!info[key_role_type]) {
        [TipView toast:@"lost role_type"];
        return;
    }
    
    if (!info[key_role_id]) {
        [TipView toast:@"lost roleID"];
        return;
    }
    if (!info[key_role_name]) {
        [TipView toast:@"lost role_name"];
        return;
    }
    
    if (!info[key_server_id]) {
        [TipView toast:@"lost serverID"];
        return;
    }
    if (!info[key_server_name]) {
        [TipView toast:@"lost server_name"];
        return;
    }
    if (!info[key_party_name]) {
        [TipView toast:@"lost party_name"];
        return;
    }
    if (!info[key_role_level]) {
        [TipView toast:@"lost role_level"];
        return;
    }
    if (!info[key_role_vip]) {
        [TipView toast:@"lost role_VIP"];
        return;
    }
    if (!info[key_role_balance]) {
        [TipView toast:@"lost role_balance"];
        return;
    }
    if (!info[key_rolelevel_ctime]) {
        [TipView toast:@"lost rolelevel_ctime"];
        return;
    }
    if (!info[key_rolelevel_mtime]) {
        [TipView toast:@"lost rolelevel_mtime"];
        return;
    }
    
    [self getHomeConfigComplent:^{
         if ([DataManager sharedDataManager].uiConfigModel.isPay_auth && ![[LTSDKUserModel shareManger].auth boolValue]) {
            [LTAutonymRealNameView showAutonymRealNameViewIsCanSkip:[DataManager sharedDataManager].uiConfigModel.isAuth ==LTAuthTypeMust  nextBtnBlock:nil commitBtnBlock:^(NSString * _Nonnull name, NSString * _Nonnull ids) {
                [TipView showPreloader];
                [NetServers userAuthWithName:name ids:ids CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                    [TipView hidePreloader];
                    if (code) {
                        [LTSDKUserModel shareManger].auth = @(YES);
                        [LTSDKUserModel shareManger].idcard = infoDic[@"idcard"];
                        [LTSDKUserModel shareManger].realname = infoDic[@"realname"];
                        [LTAutonymRealNameView hidenAutonymRealNameView];
                        [self buyView:info failedBlock:failedBlock];
                    }else {
                        [TipView toast:msg];
                    }
                }];
            }];
            return;
        }
        [self buyView:info failedBlock:failedBlock];
    }];
}

+ (void)getHomeConfigComplent:(nullable void(^)(void))complent {
    [NetServers getHomeConfigCompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
         [DataManager sharedDataManager].uiConfigModel = [[LTHomeUIConfigModel  alloc] init];
         [[DataManager sharedDataManager].uiConfigModel setValuesForKeysWithDictionary:infoDic];
        !complent?:complent();
    }];
}

+ (void)buyView:(NSDictionary *)info failedBlock:(void (^)(void))failedBlock {
    [NetServers addOrderWithParaDic:info CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [TipView hidePreloader];
        if (code == 1) {
            [LocalData setOrder:infoDic];
//            [TipView toast:msg];
            NSString *order_code = infoDic[@"order_code"];
            NSString *miss = infoDic[@"miss"];
            //保存订单号
            [LocalData setOrderCode:order_code];
            if ([miss isEqualToString:@"0"]) {
                //苹果支付（内购传的参数是苹果产品的唯一标识）
                BigLog(@"-------------IAP------------");
                NSAssert([miss isEqualToString:@"0"], @"*****************此包暂不支持苹果内购,如需苹果内购请下载内购包******************");
            }
            else{
                //第三方支付
                BigLog(@"----------Cake---------");
                //                [BigViewController showCakeView:infoDic];
                [LTAViewManger hidenSuspensionBall];
                [[LTAViewManger manage] showPayView:infoDic dismissView:^{
                }];
            }
        }
        else{
            !failedBlock?:failedBlock();
            [TipView toast:msg];
        }
    }];
}

//支付成功回调
+ (void)addCakeSuccessedCallback:(MainThreadCallBack)receiverBlock {
    //[BigViewController shareViewController].cakeSuccessed = receiverBlock;
}

//支付失败回调
+ (void)addCakeFaildCallback:(MainThreadCallBack)receiverBlock {
    //[BigViewController shareViewController].cakeFailed = receiverBlock;
}

//weiview
+ (void)showWebViewWithRequest:(NSURLRequest *)url
{
    
}

//加载流程监听
+(void)load{
    
    //自动调用系统状态切换
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self application:note.object didFinishLaunchingWithOptions:nil];
                                                      });
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self applicationDidBecomeActive:note.object];
                                                      });
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self applicationWillTerminate:note.object];
                                                      });
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self applicationDidEnterBackground:note.object];
                                                      });
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self applicationWillEnterForeground:note.object];
                                                      });
                                                  }];
}

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //[IAPServers sharedInstance];//防掉单初始化一下
    BigLog(@"\n----------BigSDK Init----------");
    
}

//APP进入前台监听
+ (void)applicationDidBecomeActive:(UIApplication *)application{
    
    BigLog(@"\n----------BigSDK Active----------");
    
    //刷新充值页面的豆点余额
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadPointData" object:nil];
    
    //本地获取当前订单号
    NSString *order_code = [LocalData getOrderCode];
    if (!order_code) {
        [TipView hidePreloader];
        return;
    }
    [TipView hidePreloader];
    [NetServers queryPStatusWithOrderID:order_code ompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        NSLog(@"OrderMSG：%@",msg);
        [TipView hidePreloader];
        if([[LocalData getIop] isEqualToString:@"1"]){
            if (code == 1) {
                NSLog(@"\n----------CakeSucc----------");
                [TipView alert:@"支付成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_CAKE_SUCCESSED" object:infoDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_CLOSE_CAKE_WINDOW" object:infoDic];
            }
            else{//支付失败
                NSLog(@"\n----------CakeFail----------");
                [TipView alert:@"支付失败"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_CAKE_FAILED" object:infoDic];
            }
            [LocalData setIop:@"0"];
        }
    }];
}

+ (void)applicationWillTerminate:(UIApplication *)application{
    BigLog(@"\n----------BigSDK Terminate----------");
    
}
+ (void)applicationDidEnterBackground:(UIApplication *)application{
    BigLog(@"\n----------BigSDK Enter Background----------");
}
+ (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"\n----------BigSDK Enter Foreground----------");
    
    
    
}

+ (NSString *)getVersion {
    return LTSDKVERSION;
}

@end
