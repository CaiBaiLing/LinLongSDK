//
//  LTHomeUIConfigModel.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/5/13.
//

#import "LTHomeUIConfigModel.h"

@implementation LTHomeUIConfigModel

- (LTAuthType)isAuth {
    if ([self.is_auth isEqualToString:@"T"]) {
        return LTAuthTypeYes;
    }else if ([self.is_auth isEqualToString:@"Y"]) {
        return LTAuthTypeMust;
    }
    return LTAuthTypeNO;
}

- (LTBindPhoneType)isBindPhoneAuth {
    if ([self.is_bind isEqualToString:@"T"]) {
        return LTBindPhoneTypeYes;
    }else if ([self.is_bind isEqualToString:@"Y"]) {
        return LTBindPhoneTypeMust;
    }
    return LTBindPhoneTypeNO;
}

- (BOOL)isFastreg{
    return [self.is_fast_reg isEqualToString:@"Y"];
}

- (BOOL)isLogin{
    return [self.is_login isEqualToString:@"Y"];
}

- (BOOL)isReg{
    return [self.is_reg isEqualToString:@"Y"];
}

- (BOOL)isPay_auth {
    return [self.pay_auth isEqualToString:@"Y"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
