//
//  LTPhoneRegiestView.m
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/27.
//

#import "LTPhoneRegiestView.h"
#import "Masonry.h"
#import "PrefixHeader.h"
#import "UIView+LTAPIView.h"
#import "NSString+StrHelper.h"

@interface LTPhoneRegiestView()

@property (nonatomic, strong) LTALoginTextField *accoutTextField;/**<手机号*/
@property (nonatomic, strong) LTALoginTextField *psdTextField;/**<密码*/
@property (nonatomic, strong) LTALoginTextField *phoneCodeField;/**<验证码*/
@property (nonatomic, strong) UIButton *psdRightBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;/**<获取验证码*/
@property (nonatomic, strong) UIButton *regiestButton;/**<注册*/
@property (nonatomic, strong) UIButton *selectProtocolButton;/**<协议阅读选择*/
@property (nonatomic, strong) UIButton *readProtocolButton;/**<协议阅读*/
@property (nonatomic, strong) UIButton *accountLoginBtton;/**<已有账号*/
@property (nonatomic, strong) UIButton *phoneRegiestButton;/**<一键注册*/
@property (nonatomic, strong) NSTimer *getCodeTimer;/**<验证码计时器*/
@property (nonatomic, assign) NSInteger timerCount;/**<倒计时 默认60秒*/

@end

@implementation LTPhoneRegiestView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
  //  [self.accoutTextField cornerRadi:5 rectCorner:UIRectCornerBottomLeft|UIRectCornerTopLeft borderColor:TEXTBorderCOLOR];
   // [self.getCodeBtn cornerRadi:5 rectCorner:UIRectCornerBottomRight|UIRectCornerTopRight borderColor:TEXTBorderCOLOR];
}

- (void)initUI {
    self.title.text = @"手机注册";
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.timerCount = 60;
    [self addSubview:self.accoutTextField];
    [self addSubview:self.phoneCodeField];
    [self addSubview:self.psdTextField];
    [self addSubview:self.regiestButton];
    [self addSubview:self.accountLoginBtton];
    [self addSubview:self.selectProtocolButton];
    [self addSubview:self.readProtocolButton];
    [self addSubview:self.phoneRegiestButton];
    //加圆角
    //[self.getCodeBtn cornerRadi:5 rectCorner:UIRectCornerTopRight|UIRectCornerBottomRight borderColor:UIColor.grayColor];

    [self.accoutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(20);
        make.left.equalTo(self).offset(LTSDKScale(20));
        make.right.equalTo(self).offset(-LTSDKScale(20));
        make.height.equalTo(@40);
    }];
        
    [self.phoneCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accoutTextField.mas_bottom).offset(15);
        make.left.right.height.equalTo(self.accoutTextField);
    }];
    
    [self.psdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneCodeField.mas_bottom).offset(15);
        make.left.right.height.equalTo(self.phoneCodeField);
    }];
    [self.selectProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.readProtocolButton);
        make.left.equalTo(self.psdTextField);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.readProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.regiestButton.mas_top).offset(3);
        make.left.equalTo(self.selectProtocolButton.mas_right);
        make.right.equalTo(self.psdTextField.mas_right);
    }];
    [self.regiestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.accountLoginBtton.mas_top).offset(0);
        make.left.equalTo(self.psdTextField );
        make.right.equalTo(self.psdTextField );
        make.height.equalTo(@35);
    }];
    
    [self.accountLoginBtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.left.equalTo(self.regiestButton);
        make.right.equalTo(self.regiestButton.mas_centerX);
    }];
    
    [self.phoneRegiestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountLoginBtton);
        make.left.equalTo(self.regiestButton.mas_centerX);
        make.right.equalTo(self.regiestButton);
    }];
}

- (void)buttonAction:(UIButton *)btn {
    if (btn == self.accountLoginBtton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(accountLoginClickAction)]) {
            [self.delegate accountLoginClickAction];
        }
    }else if (btn == self.readProtocolButton) {

//        if (self.delegate && [self.delegate respondsToSelector:@selector(phoneRegiestClickAction:)]) {
//            [self.delegate readProtocolClickAction];
//        }
    }else if (btn == self.phoneRegiestButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fastLoginClickAction)]) {
            [self.delegate fastLoginClickAction];
        }
    }else if (btn == self.selectProtocolButton) {
        self.selectProtocolButton.selected = !self.selectProtocolButton.selected;
    }else if (btn == self.getCodeBtn) {
        if (!self.accoutTextField.text || self.accoutTextField.text.length <= 0) {
            [TipView toast:@"手机号不能为空"];
            return;
        }
        if (![self.accoutTextField.text  isRegularChinaPhone]) {
            [TipView toast:@"手机号不合法"];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(getPhoneCode:regiestType:requestHandle:)]) {
            __weak typeof(self) weakself = self;
            [self.delegate getPhoneCode:self.accoutTextField.text regiestType:0 requestHandle:^(BOOL isRequestSucess) {
                __strong typeof (weakself)self = weakself;
                if (isRequestSucess) {
                    [self.getCodeTimer fireDate];
                    btn.enabled = NO;
                }
            }];
        }
    }else if (btn == self.regiestButton) {
        if (!self.selectProtocolButton.isSelected) {
            [TipView toast:@"请同意用户协议"];
            return;
        }
        if (![self.accoutTextField.text isRegularChinaPhone]){
            [TipView toast:@"请输入正确的手机号"];
            return;
        }
        else if (!self.phoneCodeField.text || self.phoneCodeField.text.length <= 0) {
            [TipView toast:@"手机验证码不能为空"];
            return;
        }else if (![self.psdTextField.text isRegularPasswd]) {
            [TipView toast:TipsPSDError];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(phoneRegiestClickAction:phoneCode:password:)]) {
            [self.delegate phoneRegiestClickAction:self.accoutTextField.text phoneCode:self.phoneCodeField.text password:self.psdTextField.text];
        }
    }
}

- (void)checkSecureTextEntry:(UIButton *)btn {
    if (self.psdRightBtn == btn) {
        self.psdRightBtn.selected = !self.psdRightBtn.isSelected;
        self.psdTextField.secureTextEntry = !self.psdTextField.secureTextEntry;
    }
}

- (LTALoginTextField *)accoutTextField {
    if (!_accoutTextField) {
        _accoutTextField = [[LTALoginTextField alloc] init];
        _accoutTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入账号/手机" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        //_accoutTextField.isRedius = YES;
        _accoutTextField.rectCorner = UIRectCornerAllCorners;
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_denglu_wode") forState:UIControlStateNormal];
        _accoutTextField.leftBtn = leftIcon;
        _accoutTextField.backgroundColor = HexColor(0xF6F6F6);
    }
    return _accoutTextField;
}

- (LTALoginTextField *)psdTextField {
    if (!_psdTextField) {
        _psdTextField = [[LTALoginTextField alloc] init];
        _psdTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        self.psdRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self.psdRightBtn addTarget:self action:@selector(checkSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
        [self.psdRightBtn setImage:SDK_IMAGE(@"sdk_eye_close") forState:UIControlStateNormal];
        [self.psdRightBtn setImage:SDK_IMAGE(@"sdk_eye_open") forState:UIControlStateSelected];

        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_denglu_mima_left") forState:UIControlStateNormal];
        _psdTextField.leftBtn = leftIcon;
        _psdTextField.rightBtn = self.psdRightBtn;
        _psdTextField.isRedius = YES;
        _psdTextField.rectCorner = UIRectCornerAllCorners;
        _psdTextField.secureTextEntry = YES;
        _psdTextField.maxTextLenth = 20;
        _psdTextField.backgroundColor = HexColor(0xF6F6F6);

    }
    return _psdTextField;
}
- (UIButton *)accountLoginBtton {
    if (!_accountLoginBtton) {
        _accountLoginBtton = [[UIButton alloc] init];
        [_accountLoginBtton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"已有账号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:TEXTNOMARLCOLOR}] forState:UIControlStateNormal];
        [_accountLoginBtton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _accountLoginBtton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _accountLoginBtton;
}

- (UIButton *)selectProtocolButton {
    if (!_selectProtocolButton) {
        _selectProtocolButton = [[UIButton alloc] init];
        //        [_selectProtocolButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@" 我已阅读并同意" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:TEXTDEFAULTCOLOR}] forState:UIControlStateNormal];
        [_selectProtocolButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectProtocolButton setImage:SDK_IMAGE(@"icon_tongyi_normal") forState:UIControlStateNormal];
        [_selectProtocolButton setImage:SDK_IMAGE(@"icon_tongyi_selected") forState:UIControlStateSelected];
        _selectProtocolButton.selected = YES;
    }
    return _selectProtocolButton;
}

- (UIButton *)readProtocolButton {
    if (!_readProtocolButton) {
        _readProtocolButton = [[UIButton alloc] init];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《用户注册服务协议》及《隐私政策》"attributes: @{NSFontAttributeName: LTSDKFont(10),NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];

        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.000000]} range:NSMakeRange(0, 7)];

        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1.000000]} range:NSMakeRange(7, 10)];

        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.000000]} range:NSMakeRange(17, 1)];

        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:139/255.0 blue:0/255.0 alpha:1.000000]} range:NSMakeRange(18, 6)];
        [_readProtocolButton setAttributedTitle:string forState:UIControlStateNormal];
        _readProtocolButton.titleLabel.numberOfLines = 0;
        _readProtocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UITapGestureRecognizer *gress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapGesture:)];
         [_readProtocolButton addGestureRecognizer:gress];

    }
    return _readProtocolButton;
}

- (void)btnTapGesture:(UITapGestureRecognizer *)gres {
    CGPoint locapoin = [gres locationInView:self.readProtocolButton];
    NSRange range = [self.readProtocolButton.currentAttributedTitle.string rangeOfString:@"用户注册服务协议"];
    CGRect rect = [ToolsHelper boundingRectForCharacterRange:range textLabel:self.readProtocolButton.titleLabel];
    NSRange range2 = [self.readProtocolButton.currentAttributedTitle.string rangeOfString:@"隐私政策"];
    CGRect rect2 = [ToolsHelper boundingRectForCharacterRange:range2 textLabel:self.readProtocolButton.titleLabel];
    if (CGRectContainsPoint(rect, locapoin)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(readProtocolClickAction)]) {
            [self.delegate readProtocolClickAction];
        }
    }else if(CGRectContainsPoint(rect2, locapoin)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(readProtocolClickAction)]) {
            [self.delegate readPrivacyPolicyClickAction];
        }
    }
    
}

- (UIButton *)phoneRegiestButton {
    if (!_phoneRegiestButton) {
        _phoneRegiestButton = [[UIButton alloc] init];
       [_phoneRegiestButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"一键注册" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:TEXTNOMARLCOLOR}] forState:UIControlStateNormal];
        [_phoneRegiestButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _phoneRegiestButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _phoneRegiestButton;
}

- (UIButton *)regiestButton {
    if (!_regiestButton) {
        _regiestButton = [[UIButton alloc] init];
        [_regiestButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"立即注册" attributes:@{NSFontAttributeName:LTSDKFont(14),NSForegroundColorAttributeName:UIColor.whiteColor}] forState:UIControlStateNormal];
        [_regiestButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_regiestButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
        [_regiestButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _regiestButton.layer.cornerRadius = 5;
        _regiestButton.layer.masksToBounds = YES;
    }
    return _regiestButton;
}

- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [[UIButton alloc] init];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:TEXTNOMARLCOLOR forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_getCodeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

- (LTALoginTextField *)phoneCodeField {
    if (!_phoneCodeField) {
        _phoneCodeField = [[LTALoginTextField alloc] init];
        _phoneCodeField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        _phoneCodeField.isRedius = YES;
        _phoneCodeField.rectCorner = UIRectCornerAllCorners;
        _phoneCodeField.keyboardType = UIKeyboardTypeNamePhonePad;
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_denglu_yanzhenma") forState:UIControlStateNormal];
        _phoneCodeField.leftBtn = leftIcon;
        _phoneCodeField.keyboardType = UIKeyboardTypeNamePhonePad;
        UIView *lien = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 12)];
        lien.backgroundColor = HexColor(0x333333);
        [self.getCodeBtn addSubview:lien];
        self.getCodeBtn.frame = CGRectMake(0, 0, 100, 35);
        lien.center = CGPointMake(0, self.getCodeBtn.center.y);
        _phoneCodeField.rightBtn = self.getCodeBtn;
        _phoneCodeField.backgroundColor = HexColor(0xF6F6F6);

    }
    return _phoneCodeField;
}

- (NSTimer *)getCodeTimer {
    if (!_getCodeTimer) {
        _getCodeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(getCodeTimerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_getCodeTimer forMode:NSRunLoopCommonModes];
     }
    return _getCodeTimer;
}

- (void)getCodeTimerAction:(NSTimer *)timer {
    self.timerCount--;
    if (self.timerCount <= 0) {
            self.getCodeBtn.enabled = YES;
            [_getCodeTimer invalidate];
            _getCodeTimer = nil;
            self.timerCount = 60;
        dispatch_async(dispatch_get_main_queue(), ^{
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

- (void)hidenFastRegiestAction {
    self.phoneRegiestButton.hidden = YES;
}

@end
