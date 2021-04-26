//
//  RequestHelper.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkingEngine.h"
typedef void (^RequestDicHanlder)(NSInteger code, NSInteger debug, NSDictionary *infoDic,NSString *msg);
typedef void (^RequestArrHanlder)(NSInteger code, NSInteger debug, NSArray *infoArr,NSString *msg);

@interface RequestHelper : NSObject
+ (NetworkingEngine *)requestWithParamsDic:(NSDictionary *)params httpMethod:(NSString *)httpMethod requestMethod:(NSString *)requestMethod completedHandler:(RequestDicHanlder)handler;
+ (NetworkingEngine *)requestWithDic:(NSDictionary *)params httpMethod:(NSString *)httpMethod requestMethod:(NSString *)requestMethod completedHandler:(RequestArrHanlder)handler;
@end
