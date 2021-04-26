//
//  LTRoleModel.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "BaseModel.h"


@interface RoleModel : BaseModel

@property (nonatomic, copy)NSString *role_id;
@property (nonatomic, copy)NSString *server_name;
@property (nonatomic, copy)NSString *server_id;
@property (nonatomic, copy)NSString *role_name;
@property (nonatomic, copy)NSString *party_name;
@property (nonatomic, copy)NSString *role_level;
@property (nonatomic, copy)NSString *role_vip;
@property (nonatomic, copy)NSString *role_balance;
@property (nonatomic, copy)NSString *rolelevel_ctime;
@property (nonatomic, copy)NSString *rolelevel_mtime;
@property (nonatomic, copy)NSString *role_type;
//厂商需求 添加extendString
@property (nonatomic, copy)NSString *extend;
- (instancetype)initWithDic:(NSDictionary *)dic;

- (NSDictionary *)getRoleinfo;

@end
