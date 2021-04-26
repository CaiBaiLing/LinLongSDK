//
//  LTABaseView.h
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LTABaseView : UIView

@property (nonatomic, strong) UILabel *title;

- (void)hidenFastRegiestAction;
- (void)hidenPhoneRegiestAction;

@end

@interface LTALoginTextField : LTABaseView

@property (nonatomic, assign) id<UITextFieldDelegate>delegate;/**<代理*/
@property (nonatomic, strong) UIView *rightBtn;/**<右边按钮视图*/
@property (nonatomic, strong) UIView *leftBtn;/**<左边按钮视图*/
@property (nonatomic, assign) UIEdgeInsets contentInsets;/**<中间输入便宜*/
@property (nonatomic, strong) NSAttributedString *placeholderText;/**<默认提示*/
@property (nonatomic, copy) NSString *text;/**<文本*/
@property (nonatomic, assign) BOOL secureTextEntry;/**<文本*/
@property (nonatomic, assign) UIRectCorner rectCorner;/**圆角边*/
@property (nonatomic, assign) BOOL isRedius;/**是否圆角*/
@property (nonatomic, assign) NSInteger maxTextLenth;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, copy) void(^textFieldDidChange)(UITextField *tf);

@end


@protocol LTLoginBaseDelegate <NSObject>

@optional
///1. 账号输入完成回调
/// @param textField 账号输入框
- (void)homeLoginViewAccountDidChange:(UITextField *)textField;

///2. 密码输入完成回调
/// @param textField 账号输入框
- (void)homeLoginViewPasswordDidChange:(UITextField *)textField;

///3. 获取验证码
/// @param phoneNo 手机号
/// @param type 获取验证码类型0注册。1忘记密码

- (void)getPhoneCode:(NSString *)phoneNo regiestType:(NSInteger)type requestHandle:(void(^)(BOOL isRequestSucess))handle;
///4. 一键注册
- (void)fastLoginClickAction;

///5. 已有账号
- (void)accountLoginClickAction;

///6.手机注册
///@param phone 手机号
- (void)phoneRegiestClickAction:(NSString *)phone;

///7.用户协议
- (void)readProtocolClickAction;
///8.隐私政策
- (void)readPrivacyPolicyClickAction;

//9.进入游戏
- (void)homeLoginClickActionAccount:(NSString *)account password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
