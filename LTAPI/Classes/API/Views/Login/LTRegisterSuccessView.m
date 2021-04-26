//
//  LTRegisterSuccessView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/6.
//

#import "LTRegisterSuccessView.h"
#import "PrefixHeader.h"
#import "Masonry.h"

@interface LTRegisterSuccessView ()

@property (nonatomic, strong) LTALoginTextField *accoutTextField;
@property (nonatomic, strong) LTALoginTextField *psdTextField;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *loginGameButton;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *psd;
@property (nonatomic, copy) void(^loginBtnBlock)(void);

@end

@implementation LTRegisterSuccessView

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

- (void)initUI {
    self.title.text = @"注册成功";
    [self addSubview:self.accoutTextField];
    [self addSubview:self.psdTextField];
    [self addSubview:self.loginGameButton];
    [self addSubview:self.tipLabel];
    [self.accoutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(15);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@(LTSDKScale(40)));
    }];
      
    [self.psdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accoutTextField.mas_bottom).offset(15);
        make.left.equalTo(self.accoutTextField);
        make.right.equalTo(self.accoutTextField);
        make.height.equalTo(self.accoutTextField);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.psdTextField.mas_bottom).offset(15);
        make.left.equalTo(self.psdTextField);
        make.right.equalTo(self.psdTextField);
        make.height.equalTo(self.psdTextField);
    }];
    
    [self.loginGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.psdTextField);
        make.right.equalTo(self.psdTextField);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.height.equalTo(@(LTSDKScale(40)));
     }];
}

- (LTALoginTextField *)accoutTextField {
    if (!_accoutTextField) {
        _accoutTextField = [[LTALoginTextField alloc] init];
        _accoutTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入账号/手机" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
        [leftBtn setTitle:@"账号:" forState:UIControlStateNormal];
        [leftBtn setTitleColor:TEXTDEFAULTCOLOR forState:UIControlStateNormal];
        _accoutTextField.leftBtn = leftBtn;
        _accoutTextField.isRedius = YES;
        _accoutTextField.userInteractionEnabled = NO;
        _accoutTextField.backgroundColor = HexColor(0xF6F6F6);
    }
    return _accoutTextField;
}

- (LTALoginTextField *)psdTextField {
    if (!_psdTextField) {
        _psdTextField = [[LTALoginTextField alloc] init];
        _psdTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
        [leftBtn setTitle:@"密码:" forState:UIControlStateNormal];
        [leftBtn setTitleColor:TEXTDEFAULTCOLOR forState:UIControlStateNormal];
        _psdTextField.leftBtn = leftBtn;
        _psdTextField.isRedius = YES;
        _psdTextField.userInteractionEnabled = NO;
        _psdTextField.backgroundColor = HexColor(0xF6F6F6);
    }
    return _psdTextField;
}

- (UIButton *)loginGameButton {
    if (!_loginGameButton) {
        _loginGameButton = [[UIButton alloc] init];
          [_loginGameButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"进入游戏" attributes:@{NSFontAttributeName:LTSDKFont(14),NSForegroundColorAttributeName:UIColor.whiteColor}] forState:UIControlStateNormal];
        [_loginGameButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_loginGameButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
        [_loginGameButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginGameButton.layer.cornerRadius = 5;
        _loginGameButton.layer.masksToBounds = YES;
    }
    return _loginGameButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"账号密码已截图保存到手机相册，请妥善保管";
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = TEXTNOMARLCOLOR;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (void)buttonAction:(UIButton *)btn {
    if (btn == self.loginGameButton) {
        !self.loginBtnBlock?:self.loginBtnBlock();
        
    }
    [self removeFromSuperview];
}

- (void)setPsd:(NSString *)psd {
    _psd = psd;
    self.psdTextField.text = _psd;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.accoutTextField.text = userName;
}

- (void)setUserName:(NSString *)userName psd:(NSString *)psd loginBlock:(void(^)(void))loginBLock {
    self.userName = userName;
    self.psd = psd;
    self.loginBtnBlock = loginBLock;
}

@end
