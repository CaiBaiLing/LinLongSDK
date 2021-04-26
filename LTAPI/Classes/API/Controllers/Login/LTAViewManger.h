//
//  LTSViewManger.h
//  LTAPI
//
//  Created by zuzu360 on 2019/12/25.
//  Copyright © 2019 LTSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LTSDK.h"

NS_ASSUME_NONNULL_BEGIN

static NSString const *requestConfigDataCompleteKey = @"RequestConfigDataCompleteKey";//请求后端配置文件

extern LTRequestResult LTAcountLoginBlock;

@interface LTCustomNavigationController : UINavigationController

@end

@interface LTAViewManger : NSObject

+ (instancetype)manage;

+ (void)destoryManage;

-(void)loginViewSuccessCallBack:(LTRequestResult)callBack;

- (void)showPayView:(NSDictionary *)info dismissView:(void(^)(void))dismissBlock;

- (void)logoutWithCallBack:(LTRequestResult)receiverBlock;

- (void)loginViewSuccessCallBack:(LTRequestResult)callBack isAutoLogin:(BOOL)isAutoLogin;

+ (void)hidenSuspensionBall;
///显示悬浮球
+ (void)showSuspensionBallView:(LTRequestResult)receiverBlock;
@end

NS_ASSUME_NONNULL_END
