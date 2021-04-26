//
//  LTMeMainView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/17.
//

#import "LTMeBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTMeItemModel : NSObject

@property (nonatomic, copy) NSString *valueString;
@property (nonatomic, copy) NSString *docmentString;
@property (nonatomic, strong) UIColor *docmentColor;
@property (nonatomic, assign) SEL sel;
@property (nonatomic, assign) id selObjfirst;
@property (nonatomic, assign) id selObjsecond;

@end

@protocol LTMeMainViewDelegate <NSObject>
//查看客服信息
- (void)getServicesView;
//修改密码

/// 修改密码
/// @param account 账号
/// @param isBindPhone 是否绑定手机号(如果绑定手机号根据验证码修改 ，否则根据原密码修改)
- (void)editPasswordView:(NSString *)account isBindPhone:(id)isBindPhone;

/// 绑定或者换绑手机号
/// @param phoneNo 手机号(当手机号为空时执行绑定操作，否则执行换绑操作 先验证原手机再绑定新手机)
- (void)bindOrReplaceBindPhoneNo:(NSString *)phoneNo;

//查看实名认证信息
- (void)getAuthRealNameInfoView;

//显示实名认证窗口
- (void)showAuthRealNameView:(id)isBindPhone;

//显示实名认证窗口
- (void)changeUserAcount;

@end

@interface LTMeMainView : LTMeBaseView

@property (nonatomic, weak) id<LTMeMainViewDelegate> delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
