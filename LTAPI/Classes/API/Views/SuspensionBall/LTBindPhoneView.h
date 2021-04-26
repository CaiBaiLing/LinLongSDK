//
//  LTBindPhoneView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/20.
//

#import "LTMeBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LTBindPhoneViewType) {
    LTBindPhoneViewTypeBind,
    LTBindPhoneViewTypeReplaceBind,
};

typedef void(^ResultBlock)(BOOL isSucess);

@interface LTBindPhoneView : LTMeBaseView

@property (nonatomic, assign) LTBindPhoneViewType bindViewType;
@property (nonatomic, strong) UIColor *fieldBgColor;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *oldCode;
@property (nonatomic, copy) void(^bindPhoneSuccessBlock)(void);

- (void)releseTime;

@end

@interface LTPopBindPhoneView : LTMeBaseView

+ (void)showBindPhoneViewIsJump:(BOOL)isJump isAphal:(BOOL)isAphal bindSucess:(void(^)(void))successHandel;

+ (void)hidenBindPhoneView;

@end

NS_ASSUME_NONNULL_END
