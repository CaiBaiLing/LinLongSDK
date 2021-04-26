//
//  LTUserModel.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "BaseModel.h"


@interface LTSDKUserModel : BaseModel
@property (nonatomic, copy) NSString *uid;//用户ID
@property (nonatomic, copy) NSString *uname;//用户名
@property (nonatomic, copy) NSString *session;//会话标识
@property (nonatomic, copy) NSString *mobile;//绑定手机号
@property (nonatomic, strong) NSNumber *auth;//是否实名认证
@property (nonatomic, copy) NSString *idcard;//身份证号
@property (nonatomic, copy) NSString *realname;//姓名
@property (nonatomic, strong) NSNumber *is_validate;//是否验证实名
@property (nonatomic, copy) NSString *point;//e点余额
@property (nonatomic, copy) NSArray<NSDictionary *> *acountList;//是否验证实名

+ (instancetype)shareManger;

- (void)addAcountToList:(NSDictionary *)acount;

- (void)changPasswordWithPassword:(NSString *)password;

- (void)cacheModelWithUserInfo:(NSDictionary *)userInfo;

- (NSDictionary *)userInfoDesc;

- (void)logoutAcount;

- (void)clearAcountList;

@end
