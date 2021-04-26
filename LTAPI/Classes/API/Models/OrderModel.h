//
//  LTOrderModel.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "BaseModel.h"


@interface OrderModel : BaseModel

@property (nonatomic, copy) NSString *outTradeNo;
@property (nonatomic, copy) NSString *productPrice;
@property (nonatomic, copy) NSString *productCount;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productDesc;
@property (nonatomic, copy) NSString *exchageRate;
@property (nonatomic, copy) NSString *currencyName; //货币名称 默认为金币

@property (nonatomic, copy)NSString *roleID;
@property (nonatomic, copy)NSString *serverID;
@property (nonatomic, copy)NSString *roleName;
@property (nonatomic, copy)NSString *serverName;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (NSDictionary *)orderInfoDic;
@end
