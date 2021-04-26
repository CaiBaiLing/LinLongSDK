//
//  LTSViewManger.m
//  LTAPI
//
//  Created by zuzu360 on 2019/12/25.
//  Copyright © 2019 LTSDK. All rights reserved.
//

#import "LTAViewManger.h"
#import <UIKit/UIKit.h>
#import "LTAHomeLoginViewController.h"
#import "PrefixHeader.h"
#import "UIViewController+LTPresentViewController.h"
#import "LTPayViewController.h"
#import "NetServers.h"
#import "ActivityAlertView.h"
#import "DataManager.h"
#import "LTSuspensionBall.h"

static LTAViewManger *LTA_manage = nil;
static dispatch_once_t LTA_onceToken;

LTRequestResult LTAcountLoginBlock = nil;


@implementation LTCustomNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self.navigationBar setShadowImage:[UIImage new]];
        [self.navigationBar setBarTintColor:[UIColor whiteColor]];
//        [self.navigationBar setTintColor:UIColor.whiteColor];
//        [self.navigationBar setBarTintColor:[UIColor colorWithRed:38.f/255.f green:38.f/255.f blue:38.f/255.f alpha:1]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TEXTNOMARLCOLOR}];
    }
    return self;
}

@end


@interface LTAViewManger()

@end


@implementation LTAViewManger

+ (instancetype)manage {
    dispatch_once(&LTA_onceToken, ^{
        if (!LTA_manage) {
            LTA_manage = [[LTAViewManger alloc] init];
        }
    });
    return LTA_manage;
}

+ (void)destoryManage {
    LTA_manage = nil;
    LTA_onceToken = 0;
}

- (void)loginViewSuccessCallBack:(LTRequestResult)callBack {
    [self loginViewSuccessCallBack:callBack isAutoLogin:YES];
    
}

- (void)loginViewSuccessCallBack:(LTRequestResult)callBack isAutoLogin:(BOOL)isAutoLogin {
    LTAcountLoginBlock = callBack;
    LTAHomeLoginViewController *homeVC = [[LTAHomeLoginViewController alloc] init];
    homeVC.loginCallBack = ^(BOOL isSucess,NSString *message, NSDictionary *responseDic) {
        [LTAViewManger showSuspensionBallView:callBack];
        !callBack?:callBack(isSucess,message,responseDic);
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSString *todayStr = [formatter stringFromDate:date];
        
        NSString *oldStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"isTodayHiddenNotice"];
        
        if (oldStr && [todayStr intValue]-[oldStr intValue] == 0) {
            
        }else{
            //活动公告
            [ActivityAlertView showAlertViewWithagreeBlock:^{
                
            } readPrivacyPolicyBlock:^{
                
            } readProtocolBlock:^{
                
            }];
        };
        
    };
    homeVC.isAutoLogin = isAutoLogin;

    LTCustomNavigationController *vc = [[LTCustomNavigationController alloc] initWithRootViewController:homeVC];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.navigationBar.tintColor = UIColor.whiteColor;
    if ([UIApplication sharedApplication].keyWindow.rootViewController) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    }else {
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    }
}

- (void)showPayView:(NSDictionary *)info dismissView:(void(^)(void))dismissBlock {
    LTPayViewController *vc = [[LTPayViewController alloc] init];
    vc.cakeDic = info;
    vc.dismissBlock = ^{
        [LTAViewManger showSuspensionBallView:nil];
        !dismissBlock?:dismissBlock();
    };
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    if ([UIApplication sharedApplication].keyWindow.rootViewController) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
    }else {
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    }
}

- (void)logoutWithCallBack:(LTRequestResult)receiverBlock {
    [TipView showPreloader];
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userInfo = [userDefault objectForKey:@"KEY_USERINFO"];
    NSString *uid = [DataManager sharedDataManager].userInfo.uid;//[userInfo objectForKey:@"uid"];
    NSString *session = [DataManager sharedDataManager].userInfo.session;//[userInfo objectForKey:@"session"];
    
    if (!uid) {
        [TipView hidePreloader];
        return;
    }
    if (!session) {
        [TipView hidePreloader];
        return;
    }
    [NetServers logoutWithCompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [TipView hidePreloader];
        BigLog(@"登出返回 = %@",msg);
        if (code) {
            [LTAViewManger hidenSuspensionBall];
            !receiverBlock?:receiverBlock(YES,msg,infoDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:LTSDKACOUNTQUITNOTIFYKEY object:nil userInfo:nil];
            return;
        }
        !receiverBlock?:receiverBlock(NO,msg,infoDic);
    }];
}

///隐藏悬浮球
+ (void)hidenSuspensionBall {
    [LTSuspensionBall hidenSuspensionBall];
}

///显示悬浮球
+ (void)showSuspensionBallView:(LTRequestResult)receiverBlock{
    [LTSuspensionBall showSuspensionBall:receiverBlock];
}

@end
