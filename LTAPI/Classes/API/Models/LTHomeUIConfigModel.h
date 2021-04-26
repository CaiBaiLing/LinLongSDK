//
//  LTHomeUIConfigModel.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/5/13.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LTAuthType) {
    LTAuthTypeNO,//不需要验证
    LTAuthTypeYes,//需要验证可跳过
    LTAuthTypeMust,//必须验证
};

typedef NS_ENUM(NSUInteger, LTBindPhoneType) {
    LTBindPhoneTypeNO,//不需要绑定
    LTBindPhoneTypeYes,//需要绑定可跳过
    LTBindPhoneTypeMust,//必须绑定
};

@interface LTHomeUIConfigModel : BaseModel

@property (nonatomic, copy) NSString *is_auth;
@property (nonatomic, copy) NSString *is_bind;
@property (nonatomic, copy) NSString *is_fast_reg;
@property (nonatomic, copy) NSString *is_login;
@property (nonatomic, copy) NSString *is_reg;
@property (nonatomic, copy) NSString *pay_auth;

- (LTAuthType)isAuth;
- (LTBindPhoneType)isBindPhoneAuth;
- (BOOL)isFastreg;
- (BOOL)isLogin;
- (BOOL)isReg;
- (BOOL)isPay_auth;

@end

NS_ASSUME_NONNULL_END
