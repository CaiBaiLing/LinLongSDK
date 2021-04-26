//
//  LTLTSDKUserModel.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "LTSDKUserModel.h"
#import "PrefixHeader.h"
#import "LocalData.h"
#import <objc/runtime.h>
static LTSDKUserModel *model = nil;
static dispatch_once_t LTSDKUserModel_onceToken;

static NSString *const LTSDKACCOUNTLISTKEY = @"accountList";

@implementation LTSDKUserModel
+ (instancetype)shareManger {
    dispatch_once(&LTSDKUserModel_onceToken, ^{
        if (!model) {
            model = [[LTSDKUserModel alloc] init];
        }
    });
    return model;
}

//登入后初始化数据
- (instancetype)initWithDic:(NSDictionary *)dic{
    if ([self init]) {
        if ([dic respondsToSelector:@selector(objectForKey:)]) {
            //try catch 捕获异常
            @try {
                self.uid = [NSString stringWithFormat:@"%@", dic[@"a"]];
                self.session = [NSString stringWithFormat:@"%@",dic[@"c"]];
            }
            @catch (NSException *exception) {
                BigLog(@"LTSDKUserModel exception = %@",exception);
            }
            @finally {
                
            }
        }
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        //self.acountList = [NSArray array];
    }
    return self;
}

- (NSString *)uid {
    return _uid?:@"";
}

- (NSString *)session {
    return _session?:@"";
}

- (NSArray<NSDictionary *> *)acountList {
    if (!_acountList) {
        _acountList = [[NSUserDefaults standardUserDefaults] objectForKey: LTSDKACCOUNTLISTKEY];
    }
    return _acountList;
}

- (void)addAcountToList:(NSDictionary *)acount {
    self.acountList =  [self saveLocalAccoutListWithAccount:acount.allKeys.firstObject password:acount[acount.allKeys.firstObject]];
}

- (NSArray *)saveLocalAccoutListWithAccount:(NSString *)account password:(NSString *)password {
    __block NSMutableArray<NSDictionary *> *accountList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:LTSDKACCOUNTLISTKEY]?:[NSArray array]];
    NSArray *array = [accountList copy];
    if (array.count <= 0) {
        [accountList addObject:@{account:password}];
    }else {
        __block BOOL isExsit = NO;
        [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj[account]) {
                isExsit = YES;
                *stop = YES;
                [accountList removeObjectAtIndex:idx];
                [accountList addObject:@{account:password}];
            }
            if (idx == array.count-1) {
                *stop = YES;
            }
            if (*stop && !isExsit) {
                [accountList addObject:@{account:password}];
            }
        }];
    }
    [[NSUserDefaults standardUserDefaults] setValue:accountList forKey:LTSDKACCOUNTLISTKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [accountList copy];
}

- (void)changPasswordWithPassword:(NSString *)password {
    NSMutableArray *accountArray = [NSMutableArray arrayWithArray:self.acountList];
    //NSDictionary *userDic = [LocalData getUserInfo]?:@{};
    
    [accountArray enumerateObjectsUsingBlock:^(NSDictionary  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
        if ([dic.allKeys.firstObject isEqualToString:self.uname]) {
            dic[self.uname] = password;
            accountArray[idx] = dic;
            *stop = YES;
        }
    }];
    [[NSUserDefaults standardUserDefaults] setValue:accountArray forKey:LTSDKACCOUNTLISTKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.acountList = [accountArray copy];
}

- (void)cacheModelWithUserInfo:(NSDictionary *)userInfo {
    [LTSDKUserModel shareManger].uid = userInfo[@"uid"];//用户ID
    [LTSDKUserModel shareManger].uname = userInfo[@"uname"];//用户名
    [LTSDKUserModel shareManger].session = userInfo[@"session"];//会话标识
    [LTSDKUserModel shareManger].mobile = userInfo[@"mobile"];//绑定手机号
    [LTSDKUserModel shareManger].auth = userInfo[@"auth"];//是否实名认证
    [LTSDKUserModel shareManger].idcard = userInfo[@"idcard"];//身份证号
    [LTSDKUserModel shareManger].realname = userInfo[@"realname"];//姓名
    [LTSDKUserModel shareManger].is_validate = userInfo[@"is_validate"];//是否验证实名
    [LTSDKUserModel shareManger].point = userInfo[@"point"];//豆点
}

- (void)logoutAcount {
    model = nil;
    LTSDKUserModel_onceToken = 0;
}

- (NSDictionary *)userInfoDesc {
    //LTSDKUserModel *model = [[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USERINFO"][@"model"];
    return [LTSDKUserModel dicFromObject:self];
}

+ (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        if ([name isEqualToString:@"acountList"]) {
            continue;
        }
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        if (value) {
            [dic setObject:value forKey:name];
        }
    }
    return [dic copy];
}

- (void)clearAcountList {
    self.acountList = @[];
    [[NSUserDefaults standardUserDefaults] setValue:@[] forKey:LTSDKACCOUNTLISTKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
