//
//  LTOrderModel.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "OrderModel.h"
#import "DataManager.h"
#import "PrefixHeader.h"

NSString * const key_out_trade_no = @"out_trade_no";
NSString * const key_product_price = @"product_price";
NSString * const key_product_count = @"product_count";
NSString * const key_product_id = @"product_id";
NSString * const key_product_name = @"product_name";
NSString * const key_product_desc = @"product_desc";
NSString * const key_exchange_rate = @"exchange_rate";
NSString * const key_currency_name = @"currency_name";
NSString * const key_roleID = @"role_id";//角色id
NSString * const key_serverID = @"server_id";//角色所在的服务器id
NSString * const key_serverName = @"server_name";
NSString * const key_roleName = @"role_name";

@implementation OrderModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if ([dic respondsToSelector:@selector(objectForKey:)]) {
            @try {
                self.outTradeNo = dic[key_out_trade_no];
                self.productPrice = dic[key_product_price];
                self.productCount = dic[key_product_count];
                self.productID = dic[key_product_id];
                self.productName = dic[key_product_name];
                self.productDesc = dic[key_product_desc];
                self.exchageRate = dic[key_exchange_rate];
                self.currencyName = dic[key_currency_name];
                self.roleID = dic[key_roleID];
                self.roleName = dic[key_roleName];
                self.serverName = dic[key_serverName];
                self.serverID = dic[key_serverID];
                
                if (!self.outTradeNo || [self.outTradeNo isEqualToString:@""]) {
                    self.outTradeNo = @"";
                }
                if (!self.productPrice || [self.productPrice isEqualToString:@""]) {
                    self.productPrice = @"1";
                }
                if (!self.productCount || [self.productCount isEqualToString:@""]) {
                    self.productCount = @"";
                }
                if (!self.productID || [self.productID isEqualToString:@""]) {
                    self.productID = @"";
                }
                if (!self.productName || [self.productName isEqualToString:@""]) {
                    self.productName = @"";
                }
                if (!self.productDesc || [self.productDesc isEqualToString:@""]) {
                    self.productDesc = @"";
                }
                if (!self.exchageRate || [self.exchageRate isEqualToString:@""]) {
                    self.exchageRate = @"0";
                }
                if (!self.currencyName || [self.currencyName isEqualToString:@""]) {
                    self.currencyName = @"";
                }
                
                if (!self.roleID || [self.roleID isEqualToString:@""]) {
                    self.roleID = @"";
                }
                if (!self.roleName || [self.roleName isEqualToString:@""]) {
                    self.roleName = @"";
                }
                if (!self.serverName || [self.serverName isEqualToString:@""]) {
                    self.serverName = @"";
                }
                if (!self.serverID || [self.serverID isEqualToString:@""]) {
                    self.serverID = @"";
                }
            }
            @catch(NSException *exception){
                BigLog(@"----------OrderModel异常 = %@----------",exception);
            }
            @finally{
            }
        }
    }
}

- (NSDictionary *)orderInfoDic{
    NSMutableDictionary *orderInfoDic = [NSMutableDictionary new];
    [orderInfoDic setObject:self.outTradeNo forKey:@"out_trade_no"];
    [orderInfoDic setObject:self.productPrice forKey:@"product_price"];
    [orderInfoDic setObject:self.productCount forKey:@"product_count"];
    [orderInfoDic setObject:self.productID forKey:@"product_id"];
    [orderInfoDic setObject:self.productName forKey:@"product_name"];
    [orderInfoDic setObject:self.productDesc forKey:@"product_desc"];
    [orderInfoDic setObject:self.exchageRate forKey:@"exchange_rate"];
    [orderInfoDic setObject:self.currencyName forKey:@"currency_name"];
    
    return orderInfoDic;
    
}


@end
