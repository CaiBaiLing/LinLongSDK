//
//  LTEditPasswordView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/20.
//

#import "LTEditPasswordView.h"
#import "LTABaseView.h"
#import "Masonry.h"
#import "PrefixHeader.h"
#import "UIView+LTAPIView.h"
#import "NSString+StrHelper.h"
#import "NetServers.h"
#import "LTSDKUserModel.h"
#import "LTAViewManger.h"
@interface LTEditPasswordView ()

@property (nonatomic, strong) LTALoginTextField *originPsdTextField;/**<原密码*/
@property (nonatomic, strong) LTALoginTextField *newPsdTextField;/**<新密码*/
@property (nonatomic, strong) LTALoginTextField *getCodeTextField;/**<再次输入新密码*/
@property (nonatomic, strong) LTALoginTextField *accountTextField;/**<再次输入新密码*/
@property (nonatomic, strong) UIView *fixView;/**<占位*/
@property (nonatomic, strong) UIButton *enterButton;/**<确定*/
@property (nonatomic, strong) NSTimer *getCodeTimer;/**<验证码计时器*/
@property (nonatomic, assign) NSInteger timerCount;/**<倒计时 默认60秒*/
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UIButton *oriPsdRightBtn;
@property (nonatomic, strong) UIButton *psdRightBtn;

@end

@implementation LTEditPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        self.navigationTitle = @"修改密码";
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = HexAlphaColor(0XFFFFFF, 0);
    [self addSubview:self.fixView];
    [self addSubview:self.newPsdTextField];
    [self addSubview:self.accountTextField];
    [self addSubview:self.enterButton];
    [self.fixView addSubview:self.getCodeTextField];
    [self.fixView addSubview:self.originPsdTextField];
    self.viewType = LTEditPasswordViewTypeNoBindPhone;
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@40);
    }];
    
    [self.fixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.accountTextField);
//        make.height.equalTo(self.accountTextField).offset(5);
    }];
    
    [self.originPsdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fixView);
    }];
    
    [self.newPsdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fixView.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.fixView);
    }];
    
    [self.getCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fixView);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.newPsdTextField.mas_bottom).offset(10);
        make.left.equalTo(self.newPsdTextField );
        make.right.equalTo(self.newPsdTextField );
        make.height.equalTo(@35);
    }];
}

- (LTALoginTextField *)originPsdTextField {
    if (!_originPsdTextField) {
        _originPsdTextField = [[LTALoginTextField alloc] init];
        _originPsdTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入原密码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        _originPsdTextField.rectCorner = UIRectCornerTopLeft|UIRectCornerBottomLeft;
        _originPsdTextField.isRedius = YES;
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_wode_mima") forState:UIControlStateNormal];
        _originPsdTextField.leftBtn = leftIcon;
        _originPsdTextField.secureTextEntry = YES;
        _originPsdTextField.maxTextLenth = 16;
        self.oriPsdRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self.oriPsdRightBtn addTarget:self action:@selector(checkSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
        [self.oriPsdRightBtn setImage:SDK_IMAGE(@"sdk_eye_close") forState:UIControlStateNormal];
        [self.oriPsdRightBtn setImage:SDK_IMAGE(@"sdk_eye_open") forState:UIControlStateSelected];
        _originPsdTextField.rightBtn = self.oriPsdRightBtn;
    }
    return _originPsdTextField;
}

- (LTALoginTextField *)getCodeTextField {
    if (!_getCodeTextField) {
        _getCodeTextField = [[LTALoginTextField alloc] init];
        _getCodeTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_wode_yanzhengma") forState:UIControlStateNormal];
        _getCodeTextField.leftBtn = leftIcon;
        _getCodeTextField.rightBtn = self.getCodeBtn;
        _getCodeTextField.isRedius = YES;
        _getCodeTextField.rectCorner = UIRectCornerAllCorners;
        _getCodeTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _getCodeTextField;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] init];
//        [_enterButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"确 认" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:UIColor.whiteColor}] forState:UIControlStateNormal];
        [_enterButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_enterButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
        [_enterButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(getCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        _enterButton.backgroundColor = DEFAULTCOLOR;
//        _enterButton.layer.cornerRadius = 5;
//        _enterButton.layer.masksToBounds = YES;
    }
    return _enterButton;
}

- (LTALoginTextField *)newPsdTextField {
    if (!_newPsdTextField) {
        _newPsdTextField = [[LTALoginTextField alloc] init];
        _newPsdTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入新密码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        _newPsdTextField.isRedius = YES;
        _newPsdTextField.rectCorner = UIRectCornerAllCorners;
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_wode_mima") forState:UIControlStateNormal];
        _newPsdTextField.leftBtn = leftIcon;
        _newPsdTextField.secureTextEntry = YES;
        _newPsdTextField.maxTextLenth = 16;
        self.psdRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self.psdRightBtn addTarget:self action:@selector(checkSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
        [self.psdRightBtn setImage:SDK_IMAGE(@"sdk_eye_close") forState:UIControlStateNormal];
        [self.psdRightBtn setImage:SDK_IMAGE(@"sdk_eye_open") forState:UIControlStateSelected];
        _newPsdTextField.rightBtn = self.psdRightBtn;
    }
    return _newPsdTextField;
}

- (LTALoginTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[LTALoginTextField alloc] init];
        _accountTextField.isRedius = YES;
        _accountTextField.rectCorner = UIRectCornerAllCorners;
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _accountTextField.leftBtn = rightBtn;
        _accountTextField.maxTextLenth = 16;
    }
    return _accountTextField;
}

-(void)setViewType:(LTEditPasswordViewType)viewType {
    [(UIButton *)self.accountTextField.leftBtn setImage:SDK_IMAGE(viewType == LTEditPasswordViewTypeBindPhone?@"icon_wode_shoji":@"icon_wode_xingming") forState:UIControlStateNormal];
    self.originPsdTextField.hidden = viewType == LTEditPasswordViewTypeBindPhone;
    self.getCodeTextField.hidden = !self.originPsdTextField.hidden;
    _viewType = viewType;
}

- (UIView *)fixView {
    if (!_fixView) {
        _fixView = [[UIView alloc] init];
    }
    return _fixView;
}

- (void)getCodeButtonAction:(UIButton *)btn{
    if (btn == self.getCodeBtn) {
        [NetServers getChangePasswordCodCompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
            if (code) {
                self.getCodeBtn.enabled = NO;
                [self.getCodeTimer fire];
            }
            [TipView toast:msg];
        }];
        return;
    }
    if (self.viewType == LTEditPasswordViewTypeNoBindPhone) {

        if (![self.newPsdTextField.text isRegularPasswd]){
            [TipView toast:TipsPSDError];
            return;
        }
        [TipView showPreloader];
        [NetServers resetPassword:self.originPsdTextField.text newPsd:self.newPsdTextField.text CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TipView hidePreloader];
                [TipView toast:msg];
                if (code) {
                    [[LTSDKUserModel shareManger] changPasswordWithPassword:self.newPsdTextField.text];
                    [[self getViewController] dismissViewControllerAnimated:YES completion:nil];
                    [[LTAViewManger manage] logoutWithCallBack:^(BOOL isSucess,NSString *message, NSDictionary *responseDic) {
                        [[LTAViewManger manage] loginViewSuccessCallBack:LTAcountLoginBlock isAutoLogin:NO];
                    }];
                    [self.navigationBar popView];
                }
            });
        }];
    }else {
        if (![self.newPsdTextField.text isRegularPasswd]){
            [TipView toast:@" 密码需以字母开头6-18位字母和数字的组合      "];
            return;
        }else if (self.getCodeTextField.text.length <= 0 ||[self.getCodeTextField.text isEqualToString:@""]) {
            [TipView toast:@" 验证码不能为空    "];
            return;
        }
        [NetServers changePasswordForPhoneCode:self.getCodeTextField.text password:self.newPsdTextField.text completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TipView hidePreloader];
                [TipView toast:msg];
                if (code ==1) {
                    [[LTSDKUserModel shareManger] changPasswordWithPassword:self.newPsdTextField.text];
                    
                    [[self getViewController] dismissViewControllerAnimated:YES completion:nil];
                    [[LTAViewManger manage] logoutWithCallBack:^(BOOL isSucess,NSString *message, NSDictionary *responseDic) {
                        [[LTAViewManger manage] loginViewSuccessCallBack:LTAcountLoginBlock isAutoLogin:NO];
                    }];
                    [self.navigationBar popView];
                }
            });
        }];
    }
}
//获取当前控制器的方法
- (UIViewController *)getViewController {
    UIView *view = self.superview;
    while(view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
    }
    return nil;
}
- (void)setAccountName:(NSString *)accountName {
    _accountName = accountName;
    self.accountTextField.text = accountName;
}

- (void)newPsdChangeInputStatus:(UIButton *)btn {
    self.newPsdTextField.secureTextEntry = btn.selected;
    btn.selected = !btn.isSelected;
}

- (void)reNewPsdChangeInputStatus:(UIButton *)btn {
//    self.originPsdTextField.secureTextEntry = btn.selected;
//    btn.selected = !btn.isSelected;
}

- (void)originPsdChangeInputStatus:(UIButton *)btn {
    self.originPsdTextField.secureTextEntry = btn.selected;
    btn.selected = !btn.isSelected;
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
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 1, 25)];
        lineView.backgroundColor = TEXTBorderCOLOR;
        _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
        [_getCodeBtn addSubview:lineView];
        [_getCodeBtn setTitle:@" 获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:DEFAULTCOLOR forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld S",self.timerCount] forState:UIControlStateNormal];
    });
}

- (void)releseTime {
    [self.getCodeTimer invalidate];
    self.getCodeTimer = nil;
}

- (void)checkSecureTextEntry:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.oriPsdRightBtn == btn) {
        self.originPsdTextField.secureTextEntry = !btn.selected;
    }else if (self.psdRightBtn == btn) {
        self.newPsdTextField.secureTextEntry = !btn.selected;
    }
}
     
@end
