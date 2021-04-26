//
//  LTFrogotView.m
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/26.
//

#import "LTFrogotView.h"
#import "Masonry.h"
#import "TipView.h"
#import "PrefixHeader.h"
#import "UIView+LTAPIView.h"

@interface LTFrogotView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) LTALoginTextField *phoneTF;
@property (nonatomic, strong) LTALoginTextField *codeTF;
@property (nonatomic, strong) LTALoginTextField *psdTF;
@property (nonatomic, strong) NSTimer *getCodeTimer;
@property (nonatomic, assign) NSInteger timerCount;
@property (nonatomic, strong) UIButton *psdRightBtn;
@property (nonatomic, strong) UIButton *rePsdRightBtn;

@end

@implementation LTFrogotView

- (void)dealloc {
    if (_getCodeTimer) {
        [_getCodeTimer invalidate];
         _getCodeTimer = nil;
    }
}

- (NSTimer *)getCodeTimer {
    if (!_getCodeTimer) {
        _getCodeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(getCodeTimerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_getCodeTimer forMode:NSRunLoopCommonModes];
     }
    return _getCodeTimer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //[self.getCodeBtn cornerRadi:5 rectCorner:UIRectCornerBottomRight|UIRectCornerTopRight borderColor:TEXTBorderCOLOR];
}

- (void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];
}

- (void)getCodeTimerAction:(NSTimer *)timer {
    self.timerCount--;
    if (self.timerCount<0) {
        [_getCodeTimer invalidate];
        _getCodeTimer = nil;
        self.timerCount = 60;
        self.getCodeBtn.enabled = YES;
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
         });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld S",self.timerCount] forState:UIControlStateNormal];
    });
}

- (void)initUI {
    self.title.text = @"忘记密码";
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.timerCount = 60;
    [self addSubview:self.codeTF];
    //[self addSubview:self.getCodeBtn];
    [self addSubview:self.phoneTF];
    [self addSubview:self.enterBtn];
    [self addSubview:self.psdTF];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.title.mas_bottom).offset(20);
//        make.right.equalTo(self).offset(-20);
//        make.size.mas_equalTo(CGSizeMake(120, 35));
//     }];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.title.mas_bottom).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@(LTSDKScale(40)));
     }];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF);
        make.right.equalTo(self.phoneTF);
        make.top.equalTo(self.phoneTF.mas_bottom).offset(20);
        make.height.equalTo(self.phoneTF);
    }];

    [self.psdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.codeTF);
        make.top.equalTo(self.codeTF.mas_bottom).offset(20);
     }];

    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.psdTF);
        make.top.equalTo(self.psdTF.mas_bottom).offset(20);
        make.height.equalTo(@(LTSDKScale(45)));
     }];
    
    UIButton *righQuitBtn = [[UIButton alloc] init];
    [righQuitBtn setImage:SDK_IMAGE(@"icon_wode_guanbi") forState:UIControlStateNormal];
    [righQuitBtn addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:righQuitBtn];
    [righQuitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.title);
    }];
}

- (void)rightBarButtonAction:(UIButton *)rightBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeViewAction)]) {
        [self.delegate closeViewAction];
    }
}

- (void)getCodeButtonAction:(UIButton *)btn{
    if (btn == self.getCodeBtn) {
        if (!self.phoneTF.text || self.phoneTF.text.length <= 0) {
            [TipView toast:@"手机号不能为空"];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(getPhoneCodeAction:requestHandler:)]) {
            [self endEditing:YES];
            __weak typeof(self) weakself = self;
            [self.delegate getPhoneCodeAction:self.phoneTF.text requestHandler:^(BOOL handle) {
                __strong typeof(weakself) self = weakself;
                if (handle) {
                    btn.enabled = NO;
                    [self.getCodeTimer fireDate];
                }
            }];
        }
    }else if (btn == self.enterBtn) {
        if (!self.phoneTF.text || self.phoneTF.text.length <= 0) {
            [TipView toast:@"手机号不能为空"];
            return;
        }else if (!self.codeTF.text || self.codeTF.text.length <= 0) {
            [TipView toast:@"手机验证码不能为空"];
            return;
        }else if (!self.psdTF.text || self.psdTF.text.length <= 0) {
            [TipView toast:@"密码不能为空"];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(enterBtnAction:phoneCode:password:)]) {
            [self.delegate enterBtnAction:self.phoneTF.text phoneCode:self.codeTF.text password:self.psdTF.text];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}

- (void)checkSecureTextEntry:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (self.psdRightBtn == btn) {
        self.psdTF.secureTextEntry = !self.psdTF.secureTextEntry;
    }
}

- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [[UIButton alloc] init];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:DEFAULTCOLOR forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_getCodeBtn addTarget:self action:@selector(getCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [[UIButton alloc] init];
        [_enterBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_enterBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
        [_enterBtn setTitle:@"确认修改" forState:UIControlStateNormal];
//        [_enterBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"确 认" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColor.whiteColor}] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(getCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        _enterBtn.backgroundColor = DEFAULTCOLOR;
//        _enterBtn.layer.cornerRadius = 5;
//        _enterBtn.layer.masksToBounds = YES;
    }
    return _enterBtn;
}

- (LTALoginTextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [[LTALoginTextField alloc] init];
        _phoneTF.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        _phoneTF.rectCorner = UIRectCornerBottomLeft|UIRectCornerTopLeft;
        _phoneTF.isRedius = YES;
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_denglu_wode") forState:UIControlStateNormal];
        _phoneTF.leftBtn = leftIcon;
        _phoneTF.backgroundColor = HexColor(0xF6F6F6);

    }
    return _phoneTF;
}

- (LTALoginTextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [[LTALoginTextField alloc] init];
        _codeTF.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        _codeTF.isRedius = YES;
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_denglu_yanzhenma") forState:UIControlStateNormal];
        _codeTF.leftBtn = leftIcon;
        _codeTF.keyboardType = UIKeyboardTypeNamePhonePad;
        UIView *lien = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 12)];
        lien.backgroundColor = HexColor(0x333333);
        [self.getCodeBtn addSubview:lien];
        self.getCodeBtn.frame = CGRectMake(0, 0, 100, 35);
        lien.center = CGPointMake(0, self.getCodeBtn.center.y);
        _codeTF.rightBtn = self.getCodeBtn;
        _codeTF.backgroundColor = HexColor(0xF6F6F6);
    }
    return _codeTF;
}

- (LTALoginTextField *)psdTF {
    if (!_psdTF) {
        _psdTF = [[LTALoginTextField alloc] init];
        _psdTF.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        self.psdRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self.psdRightBtn addTarget:self action:@selector(checkSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
        [self.psdRightBtn setImage:SDK_IMAGE(@"sdk_eye_close") forState:UIControlStateNormal];
        [self.psdRightBtn setImage:SDK_IMAGE(@"sdk_eye_open") forState:UIControlStateSelected];
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_denglu_mima_left") forState:UIControlStateNormal];
        _psdTF.leftBtn = leftIcon;
        _psdTF.rightBtn = self.psdRightBtn;
        _psdTF.isRedius = YES;
        _psdTF.secureTextEntry = YES;
        _psdTF.maxTextLenth = 20;
        _psdTF.backgroundColor = HexColor(0xF6F6F6);

    }
    return _psdTF;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)releaseTime {
    [self.getCodeTimer invalidate];
    self.getCodeTimer = nil;
}

@end
