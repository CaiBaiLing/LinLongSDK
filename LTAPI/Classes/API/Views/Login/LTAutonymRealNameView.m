//
//  LTAutonymRealNameView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/6.
//

#import "LTAutonymRealNameView.h"
#import "LTABaseView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import "NSString+StrHelper.h"
#import "NetServers.h"
#import "LTSDKUserModel.h"
@interface LTAutonymRealNameContentTextItemView : LTMeBaseView

@property (nonatomic, strong) LTALoginTextField *topView;
@property (nonatomic, strong) LTALoginTextField *bottomView;

@end

@implementation LTAutonymRealNameContentTextItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIView *bgView = [[UIView alloc] init];
    [self addSubview:bgView];
    [bgView addSubview:self.topView];
    [bgView addSubview:self.bottomView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    UIView *line = [[UIView alloc] init];
    //line.backgroundColor = TEXTBorderCOLOR;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.center.equalTo(bgView);
        make.height.equalTo(@10);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(bgView);
        make.bottom.equalTo(line.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(bgView);
    }];

}

- (LTALoginTextField *)topView {
    if (!_topView) {
        _topView = [[LTALoginTextField alloc] init];
    }
    return _topView;
}

- (LTALoginTextField *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LTALoginTextField alloc] init];
    }
    return _bottomView;
}

@end

@interface LTAutonymRealNameContentView ()

@property (nonatomic, strong) UILabel *commitTipLabel;
//@property (nonatomic, strong) UILabel *contentTipLabel;
@property (nonatomic, strong) UILabel *countTip;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) LTAutonymRealNameContentTextItemView *acountItem;
//@property (nonatomic, strong) LTAutonymRealNameContentTextItemView *phoneItem;
@property (nonatomic, strong) UIScrollView *bgView;
@property (nonatomic, copy) NSAttributedString *contentTipText;
@property (nonatomic, copy) NSAttributedString *commitTipText;
//@property (nonatomic, strong) NSTimer *getCodeTimer;/**<验证码计时器*/
//@property (nonatomic, assign) NSInteger timerCount;/**<倒计时 默认60秒*/
//@property (nonatomic, strong) UIButton *getCodeBtn;

@end

@implementation LTAutonymRealNameContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

//- (void)setIsBindPhone:(BOOL)isBindPhone {
//    _isBindPhone = isBindPhone;
//    if (isBindPhone) {
//        return;
//    }
//    if (self.phoneItem.superview) {
//        [self.phoneItem removeFromSuperview];
//    }
//    [self.bgView addSubview:self.phoneItem];
//    [self.phoneItem mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.height.equalTo(self.acountItem);
//        make.top.equalTo(self.acountItem.mas_bottom).offset(10);
//    }];
//    [self.commitTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.phoneItem);
//        make.top.equalTo(self.phoneItem.mas_bottom).offset(5);
//    }];
//}

- (void)initUI {
    self.bgView = [[UIScrollView alloc] init];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.commitTipLabel];
//    [self.bgView addSubview:self.contentTipLabel];
    [self.bgView addSubview:self.commitBtn];
    [self.bgView addSubview:self.acountItem];
    [self.bgView addSubview:self.countTip];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.bottom.equalTo(self.commitBtn).offset(5);
    }];
//    [self.contentTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.right.equalTo(self).offset(-20);
//        make.top.equalTo(self.bgView).offset(3);
//    }];
    [self.acountItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.bgView).offset(5);
        make.height.equalTo(@90);
    }];
    [self.commitTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.acountItem);
        make.top.equalTo(self.acountItem.mas_bottom).offset(5);
    }];
    [self.countTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commitTipLabel);
        make.top.equalTo(self.commitTipLabel.mas_bottom).offset(5);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.countTip);
        make.top.equalTo(self.countTip.mas_bottom).offset(5);
        make.height.equalTo(@40);
    }];
}


- (LTAutonymRealNameContentTextItemView *)acountItem {
    if (!_acountItem) {
        _acountItem = [[LTAutonymRealNameContentTextItemView alloc] init];
        _acountItem.topView.placeholderText = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *topLeftView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [topLeftView setImage:SDK_IMAGE(@"icon_wode_xingming") forState:UIControlStateNormal];
        _acountItem.topView.leftBtn = topLeftView;
        _acountItem.bottomView.placeholderText = [[NSAttributedString alloc] initWithString:@"请输入18位身份证号码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftIcon setImage:SDK_IMAGE(@"icon_wode_shenfenzheng") forState:UIControlStateNormal];
        _acountItem.bottomView.leftBtn = leftIcon;
//        _acountItem.layer.cornerRadius = 5;
//        _acountItem.layer.masksToBounds = YES;
//        _acountItem.layer.borderColor = TEXTBorderCOLOR.CGColor;
//        _acountItem.layer.borderWidth = 1;
        _acountItem.bottomView.maxTextLenth = 18;
        _acountItem.topView.textFieldDidChange = ^(UITextField * _Nonnull tf) {
            
        };
        _acountItem.bottomView.textFieldDidChange = ^(UITextField * _Nonnull tf) {
            
        };
    }
    return _acountItem;
}

//- (LTAutonymRealNameContentTextItemView *)phoneItem {
//    if (!_phoneItem) {
//        _phoneItem = [[LTAutonymRealNameContentTextItemView alloc] init];
//        _phoneItem.topView.placeholderText = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
//        UIButton *phoneLeftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
//        [phoneLeftIcon setImage:SDK_IMAGE(@"icon_wode_shoji") forState:UIControlStateNormal];
//        _phoneItem.topView.leftBtn = phoneLeftIcon;
//        _phoneItem.bottomView.placeholderText = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
//        UIButton *leftIcon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
//             [leftIcon setImage:SDK_IMAGE(@"icon_wode_yanzhengma") forState:UIControlStateNormal];
//        _phoneItem.bottomView.leftBtn = leftIcon;
//        _phoneItem.bottomView.rightBtn = self.getCodeBtn;
////        _phoneItem.layer.cornerRadius = 5;
////        _phoneItem.layer.masksToBounds = YES;
////        _phoneItem.layer.borderColor = TEXTBorderCOLOR.CGColor;
////        _phoneItem.layer.borderWidth = 1;
//        _phoneItem.topView.maxTextLenth = 11;
//        _phoneItem.topView.keyboardType = UIKeyboardTypeNamePhonePad;
//    }
//    return _phoneItem;
//}

- (UILabel *)commitTipLabel {
    if (!_commitTipLabel) {
        _commitTipLabel = [[UILabel alloc] init];
        _commitTipLabel.font = [UIFont systemFontOfSize:14];
        _commitTipLabel.attributedText = self.commitTipText;
        _commitTipLabel.numberOfLines = 0;
    }
    return _commitTipLabel;
}

- (UILabel *)countTip {
    if (!_countTip) {
        _countTip = [[UILabel alloc] init];
        _countTip.font = LTSDKFont(12);
        _countTip.text = @"*注:每日限制认证3次";
        _countTip.textColor = DEFAULTCOLOR;
    }
    return _countTip;
}

//- (UILabel *)contentTipLabel {
//    if (!_contentTipLabel) {
//        _contentTipLabel = [[UILabel alloc] init];
//        _contentTipLabel.font = [UIFont systemFontOfSize:14];
//        _contentTipLabel.textColor = TEXTDEFAULTCOLOR;
//        _contentTipLabel.attributedText = self.contentTipText;
//        _contentTipLabel.numberOfLines = 0;
//    }
//    return _contentTipLabel;
//}


- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        [_commitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_commitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
//        _commitBtn.backgroundColor = DEFAULTCOLOR;
//        _commitBtn.layer.cornerRadius = 8;
//        _commitBtn.layer.masksToBounds = YES;
        [_commitBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

//- (UIButton *)getCodeBtn {
//    if (!_getCodeBtn) {
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 12.5, 1, 10)];
//        lineView.backgroundColor = HexColor(0x333333);
//        _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
//        [_getCodeBtn addSubview:lineView];
//        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [_getCodeBtn setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
//        _getCodeBtn.titleLabel.font = LTSDKFont(15);
//        [_getCodeBtn addTarget:self action:@selector(getCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _getCodeBtn;
//}

//- (NSTimer *)getCodeTimer {
//    if (!_getCodeTimer) {
//        _getCodeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(getCodeTimerAction:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_getCodeTimer forMode:NSRunLoopCommonModes];
//        self.timerCount = 60;
//    }
//    return _getCodeTimer;
//}

//- (void)getCodeTimerAction:(NSTimer *)timer {
//    self.timerCount--;
//    if (self.timerCount <= 0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.getCodeBtn.enabled = YES;
//            [timer invalidate];
//            self.getCodeTimer = nil;
//            self.timerCount = 60;
//            [self.getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
//        });
//        return;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld S",self.timerCount] forState:UIControlStateNormal];
//    });
//}

#pragma mark 点击提交按钮
- (void)changeBtnAction:(UIButton *)btn {
    if (btn == self.commitBtn) {
        if (self.acountItem.topView.text.length <= 0) {
            [TipView toast:@"  请输入真实姓名  "];
            return;
        }else if (![self.acountItem.bottomView.text isIdCard]) {
            [TipView toast:@"  请输入18位身份证号  "];
            return;
        }
//        //如果没有绑定手机号先绑定手机号再去做实名认证，否则直接实名认证
//        if (!self.isBindPhone) {
//            if (![self.phoneItem.topView.text isRegularChinaPhone]) {
//                [TipView toast:@"请输入正确的手机号" supView:self];
//                return;
//            }else if (self.phoneItem.bottomView.text.length <= 0) {
//                [TipView toast:@"请输入验证码" supView:self];
//                return;
//            }
//            [TipView ];
//            [NetServers bindMobiler:self.phoneItem.topView.text veriCode:self.phoneItem.bottomView.text passwd:nil CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
//                [TipView hidePreloader];
//                if (code) {
//                    [LTSDKUserModel shareManger].mobile = infoDic[@"mobile"];
//                    self.isBindPhone = YES;
//                    !self.commitBtnBlock?:self.commitBtnBlock(self.acountItem.topView.text,self.acountItem.bottomView.text);
//                }else {
//                    [TipView toast:msg supView:self];
//                }
//            }];
//        }else {
            !self.commitBtnBlock?:self.commitBtnBlock(self.acountItem.topView.text,self.acountItem.bottomView.text);
//        }
    }
}

- (NSAttributedString *)contentTipText {
//    if (!_contentTipText) {
//        NSString *msg = @"尊敬的游戏用户：\n您好，根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》对于移动网络游戏市场的相关规定及要求，游戏用户需要登记如下个人信息：";
//        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:msg attributes:@{NSForegroundColorAttributeName:TEXTNOMARLCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]} ];
//        NSRange range = [msg rangeOfString:@"《关于防止未成年人沉迷网络游戏的通知》"];
//        [attString setAttributes:@{NSForegroundColorAttributeName:DEFAULTCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range];
//        _contentTipText = attString;
//    }
    return _contentTipText;
}

- (NSAttributedString *)commitTipText {
    if (!_commitTipText) {
        _commitTipText = [[NSAttributedString alloc] initWithString:@"实名注册资料一旦填写确认，无法随意更改。请您填写实名制信息时谨慎操作！" attributes:@{NSForegroundColorAttributeName:TEXTDEFAULTCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]} ];
    }
    return _commitTipText;
}

//- (void)getCodeButtonAction:(UIButton *)btn{
//    if (btn == self.getCodeBtn) {
//        if (![self.phoneItem.topView.text isRegularChinaPhone]) {
//            [TipView toast:TipsPhoneNoError supView:self];
//        }
//        [TipView ];
//        [NetServers getBindMobilerCode:self.phoneItem.topView.text CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [TipView hidePreloader];
//                if (code) {
//                    [self.getCodeTimer fire];
//                    btn.enabled = NO;
//                }
//                [TipView toast:msg supView:self];
//            });
//        }];
//        return;
//    }
//}

//- (void)releseTime {
//    [self.getCodeTimer invalidate];
//    self.getCodeTimer = nil;
//}

@end


@interface LTAutonymRealNameView ()

@property (nonatomic, strong) LTAutonymRealNameContentView *contentView;
@property (nonatomic, strong) LTMeCustomNavigation *navigation;
@property (nonatomic, assign) BOOL isCanSkip;
@property (nonatomic, copy) void(^nextBtnBlock)(void);

@end

@implementation LTAutonymRealNameView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.navigation = [[LTMeCustomNavigation alloc] initWithRootView:self.contentView];
    self.isCanSkip = NO;
    self.navigation.isHidenLine = YES;
    [self addSubview:self.navigation];
    [self.navigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setIsCanSkip:(BOOL)isCanSkip {
    _isCanSkip = isCanSkip;
    if (self.isCanSkip) {
        UIButton *btn = [[UIButton alloc] init];
        UIImage *image = SDK_IMAGE(@"icon_wode_guanbi");
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backViewAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigation.rightBar = btn;
    }
}

- (LTAutonymRealNameContentView *)contentView {
    if (!_contentView) {
        _contentView = [[LTAutonymRealNameContentView alloc] init];
        _contentView.navigationTitle = @"实名认证";
    }
    return _contentView;
}

- (void)backViewAction {
    !self.nextBtnBlock?:self.nextBtnBlock();
}

+ (void)showAutonymRealNameViewIsCanSkip:(BOOL)isCanSkip  nextBtnBlock:(void (^_Nullable)(void))nextBtnBlock commitBtnBlock:(void (^)(NSString *name,NSString *ids))commitBtnBlock {
    LTABaseView *sView = [[UIApplication sharedApplication].keyWindow viewWithTag:9999];
    if (sView && [sView isKindOfClass:[LTABaseView class]]) {
        return;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    bgView.tag = 9999;
    LTAutonymRealNameView *successView = [[LTAutonymRealNameView alloc] init];
    [bgView addSubview:successView];
    successView.backgroundColor = HexColor(0xF6F6F6);
    successView.contentView.commitBtnBlock = commitBtnBlock;
    successView.isCanSkip = isCanSkip;
    successView.nextBtnBlock = ^{
        !nextBtnBlock?:nextBtnBlock();
    };
   // successView.contentView.isBindPhone = isBindPhone;
    successView.layer.cornerRadius = 5;
    successView.layer.masksToBounds = YES;
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [superView insertSubview:bgView atIndex:9999];
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(300 ,270));
    }];
}

+ (void)hidenAutonymRealNameView {
    UIView *successView = [[UIApplication sharedApplication].keyWindow viewWithTag:9999];
    if (successView) {
        //[((LTAutonymRealNameView *)successView).contentView releseTime];
        [successView removeFromSuperview];
        successView = nil;
    }
}

@end
