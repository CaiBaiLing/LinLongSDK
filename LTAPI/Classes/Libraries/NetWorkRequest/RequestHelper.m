//
//  RequestHelper.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "RequestHelper.h"
#import "NSDictionary+TransformUntils.h"
#import "LocalData.h"
#import "PrefixHeader.h"

@implementation RequestHelper
+ (NetworkingEngine *)requestWithParamsDic:(NSDictionary *)params httpMethod:(NSString *)httpMethod requestMethod:(NSString *)requestMethod completedHandler:(RequestDicHanlder)handler{
    NSString *urlStr;
    NSString *requestParamsStr = [params toURLParamsString];
    BigLog(@"接口地址: {%@,%@,%@}",API_URL ,CLIENT_KEY ,CLIENT_SECRET);
    if (!requestParamsStr) {
        BigLog(@"\n----------%@:参数类型错误,请联系SDK管理员----------",requestMethod);
        return nil;
    }
    if ([httpMethod isEqualToString:@"GET"]) {
        urlStr = [NSString stringWithFormat:@"%@?%@", MAIN_URL, requestParamsStr];
    }
    BigLog(@"提交数据: {%@}",requestParamsStr);
    NetworkingEngine *netBean = [[NetworkingEngine alloc] initWithURLString:API_URL httpMethod:httpMethod];
    //[netBean addHeader:@"Content-Type" withValue:@"application/x-www-form-urlencoded,application/xml,text/xml,application/octet-stream,application/json"];
    NSData *bodyData = nil;
    if ([httpMethod isEqualToString:@"POST"]) {
        bodyData = [requestParamsStr dataUsingEncoding:NSUTF8StringEncoding];
        [netBean setHttpBody:bodyData];
    }
    [netBean taskStartWithRequestType:RequestType_data completedHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {
        NSDictionary *resultDic = nil;
        if (!error && responseData) {
            //然后进行解析
            NSError *pError = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&pError];
            BigLog(@"返回结果: %@",resultDic);
            if (!pError) {
               NSInteger code = [[NSString stringWithFormat:@"%@",resultDic[@"code"]] intValue];
               NSInteger debug = [[NSString stringWithFormat:@"%@",resultDic[@"debug"]] intValue];
               NSDictionary *dic = resultDic[@"info"];
               NSString *msg = resultDic[@"msg"];
               dispatch_async(dispatch_get_main_queue(), ^{
                   handler(code,debug,dic,msg);
               });
            }else {
                BigLog(@"Error:%@",pError.description);
            }
        }
   
    }];
    return netBean;
}
//活动公告
+ (NetworkingEngine *)requestWithDic:(NSDictionary *)params httpMethod:(NSString *)httpMethod requestMethod:(NSString *)requestMethod completedHandler:(RequestArrHanlder)handler{
    NSString *urlStr;
    NSString *requestParamsStr = [params toURLParamsString];
    BigLog(@"接口地址: {%@,%@,%@}",API_URL ,CLIENT_KEY ,CLIENT_SECRET);
    if (!requestParamsStr) {
        BigLog(@"\n----------%@:参数类型错误,请联系SDK管理员----------",requestMethod);
        return nil;
    }
    if ([httpMethod isEqualToString:@"GET"]) {
        urlStr = [NSString stringWithFormat:@"%@?%@", MAIN_URL, requestParamsStr];
    }
    BigLog(@"提交数据: {%@}",requestParamsStr);
    NetworkingEngine *netBean = [[NetworkingEngine alloc] initWithURLString:API_URL httpMethod:httpMethod];
    //[netBean addHeader:@"Content-Type" withValue:@"application/x-www-form-urlencoded,application/xml,text/xml,application/octet-stream,application/json"];
    NSData *bodyData = nil;
    if ([httpMethod isEqualToString:@"POST"]) {
        bodyData = [requestParamsStr dataUsingEncoding:NSUTF8StringEncoding];
        [netBean setHttpBody:bodyData];
    }
    [netBean taskStartWithRequestType:RequestType_data completedHandler:^(NSData *responseData, NSURLResponse *response, NSError *error) {
        NSDictionary *resultDic = nil;
        if (!error && responseData) {
            //然后进行解析
            NSError *pError = nil;
            resultDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&pError];
            BigLog(@"返回结果: %@",resultDic);
            if (!pError) {
               NSInteger code = [[NSString stringWithFormat:@"%@",resultDic[@"code"]] intValue];
               NSInteger debug = [[NSString stringWithFormat:@"%@",resultDic[@"debug"]] intValue];
               NSArray *arr = resultDic[@"info"];
               NSString *msg = resultDic[@"msg"];
               dispatch_async(dispatch_get_main_queue(), ^{
                   handler(code,debug,arr,msg);
               });
            }else {
                BigLog(@"Error:%@",pError.description);
            }
        }
   
    }];
    return netBean;
}
@end
