//
//  LTFastRegiestView.m
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/27.
//

#import "LTFastRegiestView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import "NSString+StrHelper.h"
@interface LTFastRegiestView ()

@property (nonatomic, strong) LTALoginTextField *accoutTextField;
@property (nonatomic, strong) LTALoginTextField *psdTextField;

@property (nonatomic, strong) UIButton *regiestButton;
@property (nonatomic, strong) UIButton *selectProtocolButton;
@property (nonatomic, strong) UIButton *readProtocolButton;
@property (nonatomic, strong) UIButton *accountLoginBtton;
@property (nonatomic, strong) UIButton *phoneRegiestButton;

@end

@implementation LTFastRegiestView

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

- (void)layoutSubviews {
    [super layoutSubviews];
    //加圆角
    [self.accoutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(15);
        make.left.equalTo(self).offset(LTSDKScale(20));
        make.right.equalTo(self).offset(-LTSDKScale(20));
        make.height.equalTo(@(LTSDKScale(40)));
    }];
       
    [self.psdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accoutTextField.mas_bottom).offset(15);
        make.left.right.height.equalTo(self.accoutTextField);
    }];
    
    [self.selectProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.readProtocolButton);
        make.left.equalTo(self.psdTextField);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.readProtocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.psdTextField.mas_bottom).offset(10);
        make.left.equalTo(self.selectProtocolButton.mas_right);
        make.right.equalTo(self.psdTextField.mas_right);
    }];
    [self.regiestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.readProtocolButton.mas_bottom).offset(10);
        make.left.equalTo(self.psdTextField );
        make.right.equalTo(self.psdTextField );
        make.height.equalTo(@(LTSDKScale(40)));
    }];
    
    [self.accountLoginBtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.regiestButton.mas_bottom).offset(15);
       make.left.equalTo(self.regiestButton);
       make.right.equalTo(self.regiestButton.mas_centerX);
    }];
    
    [self.phoneRegiestButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.accountLoginBtton);
       make.left.equalTo(self.regiestButton.mas_centerX);
       make.right.equalTo(self.regiestButton);
    }];
}

- (void)initUI {
    self.title.text = @"账号注册";
    [self addSubview:self.accoutTextField];
    [self addSubview:self.psdTextField];
    [self addSubview:self.regiestButton];
    [self addSubview:self.accountLoginBtton];
    [self addSubview:self.selectProtocolButton];
    [self addSubview:self.readProtocolButton];
    [self addSubview:self.phoneRegiestButton];
}

- (void)buttonAction:(UIButton *)btn {
    if (btn == self.regiestButton) {
        if (!self.selectProtocolButton.isSelected) {
            [TipView toast:@"请同意用户协议"];
            return;
        }else if (![self.accoutTextField.text isRegularUname]){
            [TipView toast:TipsUserError];
            return;
        }else if (![self.psdTextField.text isRegularPasswd]){
            [TipView toast:TipsPSDError];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(fastRegiestClickActionAccount:password:)]) {
            [self.delegate fastRegiestClickActionAccount:self.accoutTextField.text password:self.psdTextField.text];
        }
    }else if (btn == self.accountLoginBtton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(accountLoginClickAction)]) {
            [self.delegate accountLoginClickAction];
        }
    }else if (btn == self.readProtocolButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(readProtocolClickAction)]) {
           // [self.delegate readProtocolClickAction];
        }
    }else if (btn == self.phoneRegiestButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(phoneRegiestClickAction:)]) {
            [self.delegate phoneRegiestClickAction:self.accoutTextField.text];
        }
    }else if (btn == self.selectProtocolButton) {
        self.selectProtocolButton.selected = !self.selectProtocolButton.selected;
    }
}

- (LTALoginTextField *)accoutTextField {
    if (!_accoutTextField) {
        _accoutTextField = [[LTALoginTextField alloc] init];
        _accoutTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入账号/手机" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn setTitle:@"账号:" forState:UIControlStateNormal];
        [leftBtn setTitleColor:TEXTNOMARLCOLOR forState:UIControlStateNormal];
        _accoutTextField.leftBtn = leftBtn;
        _accoutTextField.isRedius = YES;
        _accoutTextField.backgroundColor = HexColor(0xF6F6F6);

    }
    return _accoutTextField;
}

- (LTALoginTextField *)psdTextField {
    if (!_psdTextField) {
        _psdTextField = [[LTALoginTextField alloc] init];
        _psdTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
        [leftBtn setTitle:@"密码:" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn setTitleColor:TEXTNOMARLCOLOR forState:UIControlStateNormal];
        _psdTextField.leftBtn = leftBtn;
        _psdTextField.isRedius = YES;
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
       [_phoneRegiestButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"手机注册" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:TEXTNOMARLCOLOR}] forState:UIControlStateNormal];
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

- (void)setAccount:(NSString *)account {
    _account = account;
    self.accoutTextField.text = account;
}

- (void)setPsd:(NSString *)psd {
    _psd = psd;
    self.psdTextField.text = psd;
}

@end
