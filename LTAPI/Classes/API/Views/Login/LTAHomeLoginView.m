//
//  LTAHomeLoginView.m
//  LTAPI
//
//  Created by zuzu360 on 2019/12/25.
//  Copyright © 2019 LTSDK. All rights reserved.
//

#import "LTAHomeLoginView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import "TipView.h"
#import "NSString+StrHelper.h"
#import "DataManager.h"

@interface LTAHomeLoginView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) LTALoginTextField *accoutTextField;
@property (nonatomic, strong) LTALoginTextField *psdTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *fastLoginButton;
@property (nonatomic, strong) UIButton *forgetPsdBtton;
@property (nonatomic, strong) UIButton *phoneRegiestButton;
@property (nonatomic, strong) UIButton *psdRightBtn;
@property (nonatomic, strong) UIButton *accoutRightBtn;
@property (nonatomic, strong) UITableView *accoutTab;
@property (nonatomic, copy) NSArray<NSDictionary *> *accoutArray;
@property (nonatomic, copy) NSArray<NSDictionary *> *accoutList;

@end

@implementation LTAHomeLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.title.text = @"用户登录";
    [self addSubview:self.accoutTextField];
    [self addSubview:self.psdTextField];
    [self addSubview:self.loginButton];
    [self addSubview:self.fastLoginButton];
    [self addSubview:self.forgetPsdBtton];
    [self addSubview:self.phoneRegiestButton];
    [self addSubview:self.accoutTab];
    [self.accoutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(15);
        make.left.equalTo(self).offset(LTSDKScale(28));
        make.right.equalTo(self).offset(-LTSDKScale(28));
        make.height.equalTo(@(LTSDKScale(45)));
    }];
    [self.accoutTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accoutTextField.mas_bottom);
        make.left.right.equalTo(self.accoutTextField);
    }];

    [self.psdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accoutTextField.mas_bottom).offset(15);
        make.left.equalTo(self.accoutTextField);
        make.right.equalTo(self.accoutTextField);
        make.height.equalTo(self.accoutTextField);
    }];

    [self.forgetPsdBtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.psdTextField.mas_bottom).offset(10);
        make.right.equalTo(self.psdTextField);
    }];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetPsdBtton.mas_bottom).offset(10);
        make.left.equalTo(self.psdTextField );
        make.right.equalTo(self.psdTextField );
        make.height.equalTo(@(LTSDKScale(45)));
    }];

    [self.fastLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(10);
        make.left.equalTo(self.loginButton);
        make.right.equalTo(self.loginButton.mas_centerX);
    }];

    [self.phoneRegiestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fastLoginButton);
        make.left.equalTo(self.loginButton.mas_centerX);
        make.right.equalTo(self.loginButton);
    }];
}

- (void)buttonAction:(UIButton *)btn {
    if (btn == self.loginButton) {
        if (![self.accoutTextField.text isRegularUname]) {
            [TipView toast:TipsUserError];
            return;
        }
        if (![self.psdTextField.text isRegularPasswd]) {
            [TipView toast:TipsPSDError];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(homeLoginClickActionAccount:password:)]) {
            [self.delegate homeLoginClickActionAccount:self.accoutTextField.text password:self.psdTextField.text];
        }
    }else if (btn == self.fastLoginButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fastLoginClickAction)]) {
            [self.delegate fastLoginClickAction];
        }
    }else if (btn == self.forgetPsdBtton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(forgetPasswordClickAction:)]) {
            [self.delegate forgetPasswordClickAction:self.accoutTextField.text];
        }
    }else if (btn == self.phoneRegiestButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(phoneRegiestClickAction:)]) {
            [self.delegate phoneRegiestClickAction:self.accoutTextField.text];
        }
    }
}

- (LTALoginTextField *)accoutTextField {
    if (!_accoutTextField) {
        _accoutTextField = [[LTALoginTextField alloc] init];
        _accoutTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入账号/手机" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        self.accoutRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self.accoutRightBtn setImage:SDK_IMAGE(@"icon_denglu_xiala") forState:UIControlStateNormal];
        [self.accoutRightBtn addTarget:self action:@selector(checkSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
        _accoutTextField.rightBtn = self.accoutRightBtn;
        _accoutTextField.isRedius = YES;
        _accoutTextField.delegate = self;
        _accoutTextField.text = self.accoutList.lastObject.allKeys.lastObject;
        _accoutTextField.maxTextLenth = 16;
        UIImageView *leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 19)];
        leftImageV.image = SDK_IMAGE(@"icon_denglu_wode");
        _accoutTextField.leftBtn =leftImageV;
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
        [self.psdRightBtn setImage:SDK_IMAGE(@"icon_denglu_mima_right") forState:UIControlStateNormal];
        [self.psdRightBtn setImage:SDK_IMAGE(@"sdk_eye_open") forState:UIControlStateSelected];
        _psdTextField.rightBtn = self.psdRightBtn;
        _psdTextField.secureTextEntry = YES;
        _psdTextField.isRedius = YES;
        _psdTextField.text = self.accoutList.lastObject[self.accoutList.lastObject.allKeys.lastObject];
        _psdTextField.maxTextLenth = 16;
        UIImageView *leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 18)];
        leftImageV.image = SDK_IMAGE(@"icon_denglu_mima_left");
        _psdTextField.leftBtn =leftImageV;
        _psdTextField.backgroundColor = HexColor(0xF6F6F6);
    }
    return _psdTextField;
}

- (UIButton *)fastLoginButton {
    if (!_fastLoginButton) {
        _fastLoginButton = [[UIButton alloc] init];
        [_fastLoginButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"一键注册" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:HexColor(0x666666)}] forState:UIControlStateNormal];
        [_fastLoginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _fastLoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _fastLoginButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _fastLoginButton.layer.cornerRadius = 5;
        _fastLoginButton.layer.masksToBounds = YES;
    }
    return _fastLoginButton;
}

- (UIButton *)forgetPsdBtton {
    if (!_forgetPsdBtton) {
        _forgetPsdBtton = [[UIButton alloc] init];
        [_forgetPsdBtton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"忘记密码" attributes:@{NSFontAttributeName:LTSDKFont(13),NSForegroundColorAttributeName:TEXTDEFAULTCOLOR}] forState:UIControlStateNormal];
        [_forgetPsdBtton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPsdBtton;
}

- (UIButton *)phoneRegiestButton {
    if (!_phoneRegiestButton) {
        _phoneRegiestButton = [[UIButton alloc] init];
       [_phoneRegiestButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"手机注册" attributes:@{NSFontAttributeName:LTSDKFont(13),NSForegroundColorAttributeName:HexColor(0x666666)}] forState:UIControlStateNormal];
        [_phoneRegiestButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _phoneRegiestButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _phoneRegiestButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;

    }
    return _phoneRegiestButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
        [_loginButton setTitle:@"进入游戏" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.backgroundColor = DEFAULTCOLOR;
        _loginButton.layer.cornerRadius = 5;
        _loginButton.layer.masksToBounds = YES;
    }
    return _loginButton;
}

- (void)checkSecureTextEntry:(UIButton *)btn {
    if (self.accoutRightBtn == btn) {
        [self endEditing:YES];
        self.accoutRightBtn.selected = !self.accoutRightBtn.isSelected;
        self.accoutArray = self.accoutRightBtn.selected ?self.accoutList:@[];
        [self.accoutTab reloadData];
        self.accoutTab.hidden = self.accoutRightBtn.selected?NO:YES;
    }else if (self.psdRightBtn == btn) {
        self.psdRightBtn.selected = !self.psdRightBtn.isSelected;
        self.psdTextField.secureTextEntry = !self.psdTextField.secureTextEntry;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accoutArray.count? self.accoutArray.count + 1: self.accoutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = indexPath.row == self.accoutArray.count? @"清除历史记录":self.accoutArray[indexPath.row].allKeys.firstObject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.accoutList.count) {
        [[DataManager sharedDataManager].userInfo clearAcountList];
        [self checkSecureTextEntry:self.accoutRightBtn];
        return;
    }
    NSDictionary *dic = self.accoutArray[indexPath.row];
    self.accoutTextField.text = dic.allKeys.firstObject;
    self.psdTextField.text = dic[dic.allKeys.firstObject];
    [self checkSecureTextEntry:self.accoutRightBtn];
}

- (void)setAccoutArray:(NSArray *)accoutArray {
    _accoutArray = accoutArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.accoutTab mas_updateConstraints:^(MASConstraintMaker *make) {
            NSUInteger itemCount = accoutArray.count?accoutArray.count+1:accoutArray.count;
            make.height.mas_equalTo(@(itemCount>5? 5*35: itemCount * 35));
        }];
        [self.accoutTab reloadData];
    });

}

- (UITableView *)accoutTab {
    if (!_accoutTab) {
        _accoutTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _accoutTab.delegate = self;
        _accoutTab.dataSource = self;
        [_accoutTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _accoutTab.rowHeight = 35;
        _accoutTab.hidden = YES;
    }
    return _accoutTab;
}

- (void)showAccoutTab {
    self.accoutTab.hidden = NO;
}

- (void)hidenAccoutTab {
    self.accoutTab.hidden = YES;
}

- (NSArray<NSDictionary *> *)accoutList {
    return [DataManager sharedDataManager].userInfo.acountList;
}

- (void)reloadAcount {
    _accoutTextField.text = self.accoutList.lastObject.allKeys.lastObject;
    _psdTextField.text = self.accoutList.lastObject[self.accoutList.lastObject.allKeys.lastObject];
}

- (void)hidenFastRegiestAction {
    self.fastLoginButton.hidden = YES;
}

- (void)hidenPhoneRegiestAction {
    self.phoneRegiestButton.hidden = YES;
}

@end
