//
//  LTLoginProgressView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/6.
//

#import "LTLoginProgressView.h"
#import "Masonry.h"
#import "PrefixHeader.h"

@interface LTLoginProgressView ()

@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, copy) void(^changBtnBlock)(void);
@property (nonatomic, copy) NSString *userName;

@end


@implementation LTLoginProgressView


- (instancetype)initWithFrame:(CGRect)frame {
   
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {

    self.backgroundColor = HexAlphaColor(0x000000, 0.6);//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor= DEFAULTBGCOLOR;
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@(LTSDKScale(220)));
        make.width.equalTo(@(LTSDKScale(315)));
    }];
    
    [bgView addSubview:self.animationView];
    [bgView addSubview:self.titleLabel];
    [bgView addSubview:self.contentLabel];
    [bgView addSubview:self.changeBtn];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(30);
    }];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel.mas_left).offset(-10);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
         make.centerX.equalTo(self.titleLabel);
     }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(30);
        make.left.equalTo(bgView).offset(25);
        make.right.equalTo(bgView).offset(-25);
        make.height.equalTo(@(LTSDKScale(45)));
     
    }];
}

- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"icon_zhengzaidenglu")];
        [_animationView.layer addAnimation:[self startAnimation] forKey:@"startAnimation"];
        _animationView.frame = CGRectMake(0, 0, 16, 16);
        [_animationView startAnimating];
    }
    return _animationView;
}

- (CABasicAnimation *)startAnimation {
    CABasicAnimation *animatin = [CABasicAnimation animation];
    animatin.keyPath = @"transform.rotation.z";
    animatin.fromValue = @0;
    animatin.toValue = @(2*M_PI);
    animatin.duration = 0.75;
    animatin.repeatCount = CGFLOAT_MAX;
    return animatin;
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"正在登陆";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = TEXTNOMARLCOLOR;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)changeBtn {
    if (!_changeBtn ) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"切换账号" attributes:@{NSFontAttributeName:LTSDKFont(14),NSForegroundColorAttributeName:UIColor.whiteColor}] forState:UIControlStateNormal];
        [_changeBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
        [_changeBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
        [_changeBtn addTarget:self action:@selector(changeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.layer.cornerRadius = 5;
        _changeBtn.layer.masksToBounds = YES;
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _changeBtn;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 欢迎回来",userName] attributes:@{NSForegroundColorAttributeName:TEXTNOMARLCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [muta setAttributes:@{NSForegroundColorAttributeName:DEFAULTCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(0, userName.length)];
    self.contentLabel.attributedText = muta;
}

+ (void)showLoginSuccessWithUserName:(NSString *)userName changeBtnBlock:(void (^)(void))changBlock hidenBlock:(void(^)(void))hidenBlock {
    UIView *sView = [[UIApplication sharedApplication].keyWindow viewWithTag:999];
    if (sView && [sView isKindOfClass:[LTLoginProgressView class]]) {
        return;
    }
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    LTLoginProgressView *successView = [[LTLoginProgressView alloc] init];
    successView.tag = 999;
    __block int i = 0;
    successView.changBtnBlock = ^{
        !changBlock?:changBlock();
        i = 0;
        dispatch_cancel(timer);
    };
    successView.userName = userName;
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    [superView insertSubview:successView atIndex:9999];
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        i++;
        if (i == 2) {
            !hidenBlock?:hidenBlock();
            dispatch_cancel(timer);
        }
    });
    dispatch_resume(timer);
}

+ (void)hidenLoginSuccessView {
    UIView *successView = [[UIApplication sharedApplication].keyWindow viewWithTag:999];
    if (successView && [successView isKindOfClass:[LTLoginProgressView class]]) {
        [successView removeFromSuperview];
        successView = nil;
    }
}

- (void)changeBtnAction {
    !self.changBtnBlock?:self.changBtnBlock();
}

@end
