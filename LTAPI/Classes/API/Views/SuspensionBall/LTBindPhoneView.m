//
//  LTBindPhoneView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/20.
//

#import "LTBindPhoneView.h"
#import "LTABaseView.h"
#import "Masonry.h"
#import "PrefixHeader.h"
#import "UIView+LTAPIView.h"
#import "NSString+StrHelper.h"
#import "NetServers.h"
#import "LTSDKUserModel.h"

@interface LTBindPhoneView ()

@property (nonatomic, strong) LTALoginTextField *getCodeTextField;/**<再次输入新密码*/
@property (nonatomic, strong) LTALoginTextField *accountTextField;/**<再次输入新密码*/
@property (nonatomic, strong) UIButton *enterButton;/**<确定*/
@property (nonatomic, strong) NSTimer *getCodeTimer;/**<验证码计时器*/
@property (nonatomic, assign) NSInteger timerCount;/**<倒计时 默认60秒*/
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation LTBindPhoneView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = HexAlphaColor(0XFFFFFF, 0);
    [self addSubview:self.accountTextField];
    [self addSubview:self.enterButton];
    [self addSubview:self.tipLabel];
    [self addSubview:self.getCodeTextField];
    self.bindViewType = LTBindPhoneViewTypeBind;
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@45);
    }];
    
    [self.getCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(25);
        make.left.right.height.equalTo(self.accountTextField);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.getCodeTextField);
        make.top.equalTo(self.getCodeTextField.mas_bottom).offset(10);
        make.height.equalTo(@20);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(10);
        make.left.equalTo(self.getCodeTextField );
        make.right.equalTo(self.getCodeTextField );
        make.height.equalTo(@45);
    }];
}

- (LTALoginTextField *)getCodeTextField {
    if (!_getCodeTextField) {
        _getCodeTextField = [[LTALoginTextField alloc] init];
        _getCodeTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"  请输入验证码  " attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_wode_yanzhengma") forState:UIControlStateNormal];
        _getCodeTextField.leftBtn = leftIcon;
        _getCodeTextField.rightBtn = self.getCodeBtn;
        _getCodeTextField.isRedius = YES;
        _getCodeTextField.rectCorner = UIRectCornerAllCorners;
        _getCodeTextField.maxTextLenth = 20;
        _getCodeTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _getCodeTextField;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] init];
        //[_enterButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"确 认" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:UIColor.whiteColor}] forState:UIControlStateNormal];
        [_enterButton setTitle:@"确 认" forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateNormal];
        [_enterButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(getCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_enterButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        _enterButton.backgroundColor = DEFAULTCOLOR;
//        _enterButton.layer.cornerRadius = 5;
//        _enterButton.layer.masksToBounds = YES;
    }
    return _enterButton;
}

- (LTALoginTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[LTALoginTextField alloc] init];
        _accountTextField.isRedius = YES;
        _accountTextField.rectCorner = UIRectCornerAllCorners;
        _accountTextField.placeholderText = [[NSAttributedString alloc]initWithString:@" 请输入手机号 " attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_wode_shoji") forState:UIControlStateNormal];
        _accountTextField.leftBtn = leftIcon;
        _accountTextField.maxTextLenth = 13;
    }
    return _accountTextField;
}

-(void)setBindViewType:(LTBindPhoneViewType)bindViewType {
    _bindViewType = bindViewType;
    self.accountTextField.userInteractionEnabled = bindViewType == LTBindPhoneViewTypeBind;
}

- (void)getCodeButtonAction:(UIButton *)btn{
    if (self.bindViewType == LTBindPhoneViewTypeReplaceBind) {
        if (btn == self.getCodeBtn) {
            [NetServers getChangePhoneCodCompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                [TipView toast:msg];
                if (code) {
                    [self.getCodeTimer fireDate];
                    btn.enabled = NO;
                }
            }];
            return;
        }else if (btn == self.enterButton) {
            if (self.getCodeTextField.text.length<1) {
                [TipView toast:@"请先输入验证码"];
                return;
            }
            [NetServers checkChangPhoneCode:self.getCodeTextField.text completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                [TipView toast:msg];
                if (code) {
                    [self.getCodeTimer invalidate];
                    self.getCodeTimer = nil;
                    [self.navigationBar popView];
                    [self releseTime];
                    LTBindPhoneView *view = [[LTBindPhoneView alloc] init];
                    view.accountName = @"";
                    view.oldCode = self.getCodeTextField.text;
                    //view.bindViewType = LTBindPhoneViewTypeBind;
                    view.bindPhoneSuccessBlock = self.bindPhoneSuccessBlock;
                    [self.navigationBar pushView:view];
                }
            }];
        }
    }else if(self.bindViewType == LTBindPhoneViewTypeBind){
        if (btn == self.getCodeBtn) {
            [NetServers getBindMobilerCode:self.accountTextField.text CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                [TipView toast:msg];
                if (code) {
                    [self.getCodeTimer fireDate];
                    btn.enabled = NO;
                }
            }];
            return;
        }else if (btn == self.enterButton) {
            
            if (self.accountTextField.text.length<1) {
                [TipView toast:@"请先输入手机号"];
                return;
            }else{
                if (![self.accountTextField.text isRegularChinaPhone]) {
                    [TipView toast:TipsPhoneNoError];
                    return;
                }
            }
            
            if (self.oldCode.length > 0) {
                if (self.getCodeTextField.text.length<1) {
                    [TipView toast:@"请先输入验证码"];
                    return;
                }
                [NetServers changeMobileBindPhone:self.accountTextField.text veriCode:self.getCodeTextField.text oldcode:self.oldCode completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                    if (code) {
                        [LTSDKUserModel shareManger].mobile = infoDic[@"mobile"];
                        [TipView toast:@"绑定成功"];
                        [self.navigationBar popView];
                        [self releseTime];
                        !self.bindPhoneSuccessBlock?:self.bindPhoneSuccessBlock();
                    }
                    [TipView toast:[NSString stringWithFormat:@"  %@  ",msg]];
                }];
                return;
            }
            if (self.accountTextField.text.length<0) {
                [TipView toast:@"请先输入验证码"];
                return;
            }
            [NetServers bindMobiler:self.accountTextField.text veriCode:self.getCodeTextField.text passwd:nil CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                if (code) {
                    [LTSDKUserModel shareManger].mobile = infoDic[@"mobile"];
                    [TipView toast:@"绑定成功"];
                    [self.navigationBar popView];
                    [self releseTime];
                    !self.bindPhoneSuccessBlock?:self.bindPhoneSuccessBlock();
                }
                [TipView toast:[NSString stringWithFormat:@"  %@  ",msg]];
            }];
        }
    }
}

- (void)setAccountName:(NSString *)accountName {
    _accountName = accountName;
    self.bindViewType = accountName.length > 0?LTBindPhoneViewTypeReplaceBind:LTBindPhoneViewTypeBind;
    self.accountTextField.text = accountName;
    self.navigationTitle = accountName.length?@"换绑手机号":@"绑定手机号";
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = LTSDKFont(12);
        _tipLabel.textColor = HexColor(0x000000);
        _tipLabel.text = @"*绑定手机才可领取更多游戏福利哦~";
    }
    return _tipLabel;
}

- (NSTimer *)getCodeTimer {
    if (!_getCodeTimer) {
        _getCodeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(getCodeTimerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_getCodeTimer forMode:NSRunLoopCommonModes];
        self.timerCount = 60;
    }
    return _getCodeTimer;
}

- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 12.5, 1, 10)];
       lineView.backgroundColor = HexColor(0x333333);
       _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
       [_getCodeBtn addSubview:lineView];
       [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
       [_getCodeBtn setTitleColor:themeYellowCOLOR forState:UIControlStateNormal];
       _getCodeBtn.titleLabel.font = LTSDKFont(15);
        [_getCodeBtn addTarget:self action:@selector(getCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

- (void)getCodeTimerAction:(NSTimer *)timer {
    self.timerCount--;
    if (self.timerCount <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.getCodeBtn.enabled = YES;
            [timer invalidate];
            self.getCodeTimer = nil;
            self.timerCount = 60;
            [self.getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld S",(long)self.timerCount] forState:UIControlStateNormal];
    });
}

- (void)releseTime {
    [self.getCodeTimer invalidate];
    self.getCodeTimer = nil;
}

- (void)dismissView {
    !self.bindPhoneSuccessBlock?:self.bindPhoneSuccessBlock();
}

- (void)setFieldBgColor:(UIColor *)fieldBgColor {
    _fieldBgColor = fieldBgColor;
    self.getCodeTextField.backgroundColor = fieldBgColor;
    self.accountTextField.backgroundColor = fieldBgColor;
}

@end

@implementation LTPopBindPhoneView

+ (void)showBindPhoneViewIsJump:(BOOL)isJump isAphal:(BOOL)isAphal bindSucess:(void(^)(void))successHandel {
    
    UIView *supView = [[UIApplication sharedApplication].keyWindow viewWithTag:9998];
    if (supView) {
        return;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    bgView.backgroundColor = isAphal?HexAlphaColor(0xFFFFFF, 0.0): HexAlphaColor(0x999999, 0.6);
    bgView.tag = 9998;
    LTBindPhoneView *bindPhoenView = [[LTBindPhoneView alloc] init];
    bindPhoenView.navigationTitle = @"绑定手机号";
//    bindPhoenView.tipLabel.text = @"绑定手机才可领取更多游戏福利哦~";
    LTMeCustomNavigation *navigation = [[LTMeCustomNavigation alloc] initWithRootView:bindPhoenView];
    navigation.backgroundColor= HexColor(0xFFFFFF);
    bindPhoenView.fieldBgColor = HexColor(0xF6F6F6);
//    navigation.navigationBar
    [bgView addSubview:navigation];
    bindPhoenView.bindViewType = LTBindPhoneViewTypeBind;
    if (isJump) {
        UIButton *newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [newBtn addTarget:bindPhoenView action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [newBtn setImage:SDK_IMAGE(@"icon_wode_guanbi") forState:UIControlStateNormal];
        navigation.rightBar = newBtn;
    }
    bindPhoenView.bindPhoneSuccessBlock = ^{
        !successHandel?:successHandel();
        [LTPopBindPhoneView hidenBindPhoneView];
    };
    [navigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(300, 270));
    }];
    navigation.layer.cornerRadius = 5;
    navigation.layer.masksToBounds = YES;
    [[UIApplication sharedApplication].keyWindow insertSubview:bgView atIndex:9998];
}

+ (void)hidenBindPhoneView {
    UIView *bindView = [[UIApplication sharedApplication].keyWindow viewWithTag:9998];
    if (bindView) {
        [bindView removeFromSuperview];
        bindView = nil;
    }
}

@end

