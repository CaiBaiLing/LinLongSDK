//
//  LoadView.m
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "TipView.h"
#import "PrefixHeader.h"
#import "UIViewController+LTPresentViewController.h"
#import "Masonry.h"
//#define SG_BOX_LENGTH (100.0f)
//#define SG_BOX_EDGE (20.0f)

static TipView *tipView = nil;
static dispatch_once_t onceToken;

typedef NS_ENUM(NSUInteger, TipViewToastType) {
    TipViewToastTypeToast,
    TipViewToastTypeIndicator,
};

@interface TipView()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, assign) TipViewToastType type;

@end

@implementation TipView

//- (instancetype)initWithMessage:(NSString *)message {
////    return [self initWithMessage:message center:CGPointZero];
//}

+ (instancetype)shareTipView {
    dispatch_once(&onceToken, ^{
        if (!tipView) {
            tipView = [[TipView alloc] init];
        }
    });
    return tipView;
}

+(void)distoryTipView{
    tipView = nil;
    onceToken = 0;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    self.backgroundColor = HexAlphaColor(0x000000, 0.3);
    [self addSubview:self.backGroundView];
    [self.backGroundView addSubview:self.indicatorImageView];
    [self.backGroundView addSubview:self.messageLabel];
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backGroundView);
    }];
    
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.messageLabel.mas_top).offset(-5);
        make.centerX.equalTo(self.backGroundView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.backgroundColor = HexColor(0x333333);
        _backGroundView.layer.cornerRadius = 5;
        _backGroundView.layer.masksToBounds = YES;
    }
    return _backGroundView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel =[[UILabel alloc] init];
        _messageLabel.textColor = HexColor(0xFFFFFF);
        _messageLabel.font = LTSDKFont(14);
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UIImageView *)indicatorImageView {
    if (!_indicatorImageView) {
        _indicatorImageView = [[UIImageView alloc] initWithImage:[SDK_IMAGE(@"icon_zhengzaidenglu") imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] ];
        [_indicatorImageView.layer addAnimation:[self startAnimation] forKey:@"startAnimation"];
        [_indicatorImageView setTintColor:[UIColor whiteColor]];
        _indicatorImageView.frame = CGRectMake(0, 0, 16, 16);
        ;
        [_indicatorImageView startAnimating];
    }
    return _indicatorImageView;
}

- (CABasicAnimation *)startAnimation {
    CABasicAnimation *animatin = [CABasicAnimation animation];
    animatin.keyPath = @"transform.rotation.z";
    animatin.fromValue = @0;
    animatin.toValue = @(2*M_PI);
    animatin.duration = 0.75;
    animatin.removedOnCompletion = NO;
    animatin.repeatCount = CGFLOAT_MAX;
    return animatin;
    
}

- (void)setType:(TipViewToastType)type {
    _type = type;
    if (type == TipViewToastTypeToast) {
        [self.indicatorImageView stopAnimating];
        self.indicatorImageView.hidden = YES;
        CGSize textSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake(9999, 9999) options:NSStringDrawingUsesFontLeading attributes:nil context:nil].size;
        CGSize offetSize = CGSizeMake(textSize.width + 25, textSize.height+10);
        [self.backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(offetSize);
        }];
    }else {
        self.indicatorImageView.hidden = NO;
        [self.indicatorImageView startAnimating];
       [self.backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(CGSizeMake(100, 100));
       }];
    }
}

//显示加载器
+ (void)showPreloader {
    UIView *supView = [UIApplication sharedApplication].keyWindow;
    [self showPreloaderWithSupView:supView];
}

+ (void)showPreloaderWithSupView:(UIView *)supView {
    if (supView == nil) {
        return;
    }
    if ([TipView shareTipView].superview) {
        [tipView removeFromSuperview];
    }
    tipView.messageLabel.text = nil;
    tipView.type = TipViewToastTypeIndicator;
    [supView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(supView);
     }];
    
}

//隐藏加载器
+ (void)hidePreloader {
    [tipView removeFromSuperview];
}

//轻量提示-默认2秒后消失
+ (void)toast:(NSString *)msg supView:(UIView *)supView {
    if ([TipView shareTipView].superview) {
        [tipView removeFromSuperview];
    }
    tipView.messageLabel.text = msg;
    tipView.type = TipViewToastTypeToast;
    [supView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(supView);
    }];
    [tipView performSelector:@selector(hidenView) withObject:nil afterDelay:1];
}

- (void)hidenView {
    if (tipView.superview) {
        [tipView removeFromSuperview];
    }
}

//轻量提示-默认2秒后消失
+ (void)toast:(NSString *)msg {
    UIView *supView = [UIApplication sharedApplication].keyWindow;
    [self toast:msg supView:supView];
}


//初始化方法
//- (instancetype)initWithMessage:(NSString *)message center:(CGPoint)center;
//{
//    self = [super init];
//    if (self) {
//        CGSize screenSize = UIScreen.mainScreen.bounds.size;
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//        self.layer.cornerRadius = 7;
//        blackView = [[UIView alloc]init];
//        [self addSubview:blackView];
//        //加载器
//        if (message && ![message isEqualToString:@""]) {
//            UIFont *messageFont = [UIFont fontWithName:FONTARIAL size:isPad?25:17];
//            CGRect labelBounds = [message boundingRectWithSize:CGSizeMake(320.0 - SG_BOX_EDGE, 320.0 - SG_BOX_EDGE)    options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:messageFont} context:nil];
//            self.frame = CGRectMake(0, 0, labelBounds.size.width + SG_BOX_EDGE, labelBounds.size.height + SG_BOX_EDGE);
//            self.center = CGPointEqualToPoint(center, CGPointZero)? CGPointMake(screenSize.width/2, screenSize.height/2):center;
//            _messageLabel = [[UILabel alloc] init];
//            [blackView addSubview:_messageLabel];
//            blackView.frame = CGRectMake(0, 0, labelBounds.size.width + SG_BOX_EDGE, labelBounds.size.height + SG_BOX_EDGE);
//            blackView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//            _messageLabel.numberOfLines = 0;
//            _messageLabel.frame = CGRectMake(SG_BOX_EDGE/2, SG_BOX_EDGE/2, labelBounds.size.width, labelBounds.size.height);
//            _messageLabel.center = CGPointMake(blackView.bounds.size.width/2, blackView.bounds.size.height/2);;
//            _messageLabel.font = messageFont;
//            _messageLabel.text = message;
//            _messageLabel.textColor = [UIColor whiteColor];
//        }
//        else {//菊花加载转圈
//            //遮罩
//           blackView.frame = CGRectMake(0, 0, SG_BOX_LENGTH, SG_BOX_LENGTH);
//           blackView.center = CGPointMake(screenSize.width/2, screenSize.height/2);
//            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//            [indicator setCenter:blackView.center];// CGPointMake(screenSize.width/2, screenSize.height/2)];
//            [self addSubview:indicator];
//            [indicator startAnimating];
//        }
//
//    }
//    return self;
//}

////显示加载器
//+ (void)
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (!tipView) {
//            tipView = [[TipView alloc] initWithMessage:nil];
//            [[self topViewController].view.subviews.lastObject addSubview:tipView];
//        }
//    });
//}
//
////隐藏加载器
//+ (void)hidePreloader
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (tipView) {
//            [tipView removeFromSuperview];
//            tipView = nil;
//        }
//    });
//}

//+ (void)toast:(NSString *)msg supView:(UIView *)supView{
//    __block UIView *supBlocView = supView;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (!supBlocView) {
//            supBlocView = UIApplication.sharedApplication.keyWindow;
//        }
//        CGPoint center = CGPointMake(supBlocView.bounds.size.width/2, supBlocView.bounds.size.height/2);
//        if (!tipView) {
//            tipView = [[TipView alloc] initWithMessage:msg center:center];
//            [supBlocView insertSubview:tipView atIndex:99999];
//            [NSTimer scheduledTimerWithTimeInterval:2.0f target:[tipView class] selector:@selector(fadeOutBox) userInfo:nil repeats:NO];
//        }
//        else {
//            [tipView removeFromSuperview];
//            tipView = nil;
//            tipView = [[TipView alloc] initWithMessage:msg center:center];
//            [supBlocView insertSubview:tipView atIndex:99999];
//            [NSTimer scheduledTimerWithTimeInterval:2.0f target:[tipView class] selector:@selector(fadeOutBox) userInfo:nil repeats:NO];
//        }
//    });
//}
//
////轻量提示-默认2秒后消失
//+ (void)toast:(NSString *)msg {
//    [self toast:msg supView:nil];
//}
//
////轻量提示-设定消失时间
//+ (void)toast:(NSString *)msg duration:(double)duration
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (!tipView) {
//            tipView = [[TipView alloc] initWithMessage:msg];
//            [[self topViewController].view addSubview:tipView];
//            [NSTimer scheduledTimerWithTimeInterval:duration target:[tipView class] selector:@selector(fadeOutBox) userInfo:nil repeats:NO];
//        }
//        else {
//            [tipView removeFromSuperview];
//            tipView = nil;
//            tipView = [[TipView alloc] initWithMessage:msg];
//            [[self topViewController].view addSubview:tipView];
//            [NSTimer scheduledTimerWithTimeInterval:duration target:[tipView class] selector:@selector(fadeOutBox) userInfo:nil repeats:NO];
//        }
//
//    });
//}
//
////让提示框消失
//+ (void)fadeOutBox
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:1.0f animations:^{
//            if (tipView) {
//                tipView.alpha = 0.f;
//            }
//        } completion:^(BOOL finished) {
//            if (tipView) {
//                [tipView removeFromSuperview];
//                tipView = nil;
//            }
//        }];
//    });
//}
//
////alert
+(void)alert:(NSString *)msg
{
    UIViewController *viewC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAcion = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:sureAcion];
    [viewC presentViewController:alertController animated:YES completion:nil];
}

+ (UIViewController *)topViewController {
    UIViewController *topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVc.presentedViewController) {
        topVc = topVc.presentedViewController;
    }
    if ([topVc isKindOfClass:[UINavigationController class]]) {
        topVc = topVc.childViewControllers.lastObject;
    }else if ([topVc isKindOfClass:[UITabBarController class]]) {
        topVc = ((UITabBarController *)topVc).selectedViewController;
        if ([topVc isKindOfClass:[UINavigationController class]]) {
              topVc = topVc.childViewControllers.lastObject;
        }
        while (topVc.presentedViewController) {
             topVc = topVc.presentedViewController;
        }
    }
    return topVc;
}
//
//+ (void) {
//
//}
//
//+ (void)hidePreloader {
//
//}

@end
