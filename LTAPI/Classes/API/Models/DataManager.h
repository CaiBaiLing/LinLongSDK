//
//  LTDataManager.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "LTSDKUserModel.h"
#import "RoleModel.h"
#import "OrderModel.h"
#import "LTHomeUIConfigModel.h"

@interface DataManager : NSObject

@property (nonatomic, strong) Config *configParams;
@property (nonatomic, strong) LTSDKUserModel *userInfo;
@property (nonatomic, strong) OrderModel *orderInfo;
@property (nonatomic, strong) RoleModel *roleInfo;
@property (nonatomic, strong) LTHomeUIConfigModel *uiConfigModel;

@property (nonatomic, assign) BOOL isReviewed;
@property (nonatomic, copy) NSNumber *time; //服务器时间，用于对比
@property (nonatomic, assign, readonly) long long offsetTime;
@property (nonatomic, assign) BOOL isInstall;//是否请求过安装的接口
@property (nonatomic, copy) NSString *rsaPublic;
@property (nonatomic, copy) NSString *sid;//推广员id

+ (DataManager *)sharedDataManager;

@end
