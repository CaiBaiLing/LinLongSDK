//
//  LTRoleModel.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "RoleModel.h"
#import "PrefixHeader.h"

//设定字段
NSString *const key_role_id = @"role_id";
NSString *const key_server_name = @"server_name";
NSString *const key_server_id = @"server_id";
NSString *const key_role_name = @"role_name";
NSString *const key_party_name = @"party_name";
NSString *const key_role_level = @"role_level";
NSString *const key_role_vip = @"role_vip";
NSString *const key_role_balance = @"role_balance";
NSString *const key_rolelevel_ctime = @"rolelevel_ctime";
NSString *const key_rolelevel_mtime = @"rolelevel_mtime";
NSString *const key_role_type = @"role_type";
NSString *const key_extendString = @"extend";
@implementation RoleModel

//+ (NSDictionary *)replacedKeyFromPropertyName {
//    return @{@"extendString":@"extend"};
//}

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if ([dic respondsToSelector:@selector(objectForKey:)]) {
            @try{
                self.role_id = dic[key_role_id];
                self.server_name = dic[key_role_name];
                self.server_id = dic[key_server_id];
                self.role_name = dic[key_role_name];
                self.party_name = dic[key_party_name];
                self.role_level = dic[key_role_level];
                self.role_vip = dic[key_role_vip];
                self.role_balance = dic[key_role_balance];
                self.rolelevel_ctime = dic[key_rolelevel_ctime];
                self.rolelevel_mtime = dic[key_rolelevel_mtime];
                self.role_type = dic[key_role_type];
                self.extend = dic[key_extendString];
                if (!self.role_id || [self.role_id isEqualToString:@""]) {
                    self.role_id = @"";
                }
                if (!self.server_name || [self.server_name isEqualToString:@""]) {
                    self.server_name = @"";
                }
                if (!self.server_id || [self.server_id isEqualToString:@""]) {
                    self.server_id = @"";
                }
                if (!self.role_name || [self.role_name isEqualToString:@""]) {
                    self.role_name = @"";
                }
                if (!self.party_name || [self.party_name isEqualToString:@""]) {
                    self.party_name = @"";
                }
                if (!self.role_level || [self.role_level isEqualToString:@""]) {
                    self.role_level = @"0";
                }
                if (!self.role_vip || [self.role_vip isEqualToString:@""]) {
                    self.role_vip = @"0";
                }
                if (!self.role_balance || [self.role_balance isEqualToString:@""]) {
                    self.role_balance = @"0";
                }
                
                if (!self.rolelevel_ctime || [self.rolelevel_ctime isEqualToString:@""]) {
                    self.rolelevel_ctime = @"0";
                }
                if (!self.rolelevel_mtime || [self.rolelevel_mtime isEqualToString:@""]) {
                    self.rolelevel_mtime = @"0";
                }
                if (!self.role_type || [self.role_type isEqualToString:@""]) {
                    self.role_type = @"0";
                }
                if (!self.extend || [self.extend isEqualToString:@""]) {
                    self.extend = @"";
                }
                
            }
            @catch (NSException *exception) {
                BigLog(@"----------RoleModel异常=%@----------",exception);
            }
            @finally {
                
            }
        }
    }
    return self;
}

- (NSDictionary *)getRoleinfo{
    NSMutableDictionary *roleDic = [NSMutableDictionary new];
    [roleDic setObject:self.server_id forKey:key_server_id];
    [roleDic setObject:self.role_id forKey:key_role_id];
    [roleDic setObject:self.server_name forKey:key_server_name];
    [roleDic setObject:self.role_name forKey:key_role_name];
    [roleDic setObject:self.party_name forKey:key_party_name];
    [roleDic setObject:self.role_level forKey:key_role_level];
    [roleDic setObject:self.role_vip forKey:key_role_vip];
    [roleDic setObject:self.role_balance forKey:key_role_balance];
    [roleDic setObject:self.rolelevel_ctime forKey:key_rolelevel_ctime];
    [roleDic setObject:self.rolelevel_mtime forKey:key_rolelevel_mtime];
    [roleDic setObject:self.role_type forKey:key_role_type];
    [roleDic setObject:self.extend forKey:key_extendString];
    return roleDic;
}

@end
