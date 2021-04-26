//
//  LTSuspensionBall.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/7.
//

#import "LTSuspensionBall.h"
#import "LTUserCenterViewController.h"
#import "LTAViewManger.h"
#import "PrefixHeader.h"
#import "UIViewController+LTPresentViewController.h"
#import "LTSDK.h"
#define LTsuspensionBallSupViewSize self.superview.bounds.size
#define LTsuspensionBallViewTag 99999
#define LTSuspensionBallDefaluAlpha 0.6f

@interface LTSuspensionBall()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) BOOL isHangUp;//悬浮球是否挂起
@property (nonatomic, strong) UITapGestureRecognizer *tapGress;
@property (nonatomic, strong) UITapGestureRecognizer *showGress;
@property (nonatomic, strong) NSNumber *showtimer;//悬浮球点击后显示的时间
@property (nonatomic, strong) LTRequestResult LTUserLoginRequestBlock;

@end

@implementation LTSuspensionBall

- (instancetype)init {
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIPanGestureRecognizer *gerse = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    self.tapGress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    self.showGress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    self.tapGress.enabled = NO;
    gerse.delegate = self;
    [self addGestureRecognizer:gerse];
    [self addGestureRecognizer:self.showGress];
    [self addGestureRecognizer:self.tapGress];
    self.layer.contents = (id)SDK_IMAGE(@"ballPic").CGImage;
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.backgroundColor = backColor;
}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)gres {
    if (gres == self.showGress) {
        self.isHangUp = YES;
        self.showGress.enabled = NO;
        self.tapGress.enabled = YES;
        self.showtimer = @2;
    }else {
        LTUserCenterViewController *userVC = [[LTUserCenterViewController alloc] init];
        userVC.dismissControllerBlock = ^{
            [LTSuspensionBall showSuspensionBall:self.LTUserLoginRequestBlock];
        };
//        LTCustomNavigationController *navi = [[LTCustomNavigationController alloc] initWithRootViewController:userVC];
//        navi.modalPresentationStyle = UIModalPresentationFullScreen;
//        [[LTSuspensionBall topViewController] presentViewController:navi animated:YES completion:nil];
        userVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [[LTSuspensionBall topViewController] presentViewController:userVC animated:YES completion:nil];
        self.showGress.enabled = YES;
        self.tapGress.enabled = NO;
        [LTSuspensionBall hidenSuspensionBall];
    }
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)gres {
    if(gres.state== UIGestureRecognizerStateChanged|| gres.state== UIGestureRecognizerStateEnded) {
        self.alpha = 1;
        _isHangUp = YES;
        self.showGress.enabled = NO;
        self.tapGress.enabled = YES;
        //translationInView：获取到的是手指移动后，在相对坐标中的偏移量
        CGPoint offset = [gres translationInView:self.superview];
        __block CGPoint center = CGPointMake(self.center.x+offset.x, self.center.y+offset.y);
        //判断横坐标是否超出屏幕
        if(center.x <= self.bounds.size.width/2) {
            center.x= self.bounds.size.width/2;
        } else if(center.x >= LTsuspensionBallSupViewSize.width) {
            center.x= LTsuspensionBallSupViewSize.width;
        }
        //判断纵坐标是否超出屏幕
        if(center.y <= self.bounds.size.height/2) {
            center.y = self.bounds.size.height/2;
        } else if(center.y >= LTsuspensionBallSupViewSize.height - self.bounds.size.height/2) {
            center.y= LTsuspensionBallSupViewSize.height - self.bounds.size.height/2;
        }
        if (gres.state == UIGestureRecognizerStateEnded) {
            if (center.x < LTsuspensionBallSupViewSize.width/2 && center.x >0 ) {
//                [UIView animateWithDuration:0.25 animations:^{
                     center.x = self.bounds.size.width/2;
                     self.center = center;
                    [gres setTranslation:CGPointZero inView:self.superview];
//                }];
            }else {
//                [UIView animateWithDuration:0.25 animations:^{
                      center.x = LTsuspensionBallSupViewSize.width - self.bounds.size.width/2;;
                      self.center = center;
                     [gres setTranslation:CGPointZero inView:self.superview];
//                }];
            }
            self.showtimer = @2;
            return;
        }
        self.center = center;
        [gres setTranslation:CGPointZero inView:self.superview];
    }
}

+ (void)showSuspensionBall:(LTRequestResult)receiverBlock {
    UIView *ballView = [[UIApplication sharedApplication].keyWindow viewWithTag:LTsuspensionBallViewTag];
    if (ballView) {
        ballView.hidden = NO;
        return;
    }
    NSAssert([UIApplication sharedApplication].keyWindow != nil, @"Windows 暂未创建，请在Window初始化后调用");
    CGFloat width = 60;
    ballView = [[LTSuspensionBall alloc] initWithFrame:CGRectMake(-width/2, 20, width, width)];
    ballView.layer.cornerRadius = width/2;
    ballView.layer.masksToBounds = YES;
    ballView.alpha = LTSuspensionBallDefaluAlpha;
    ballView.tag = LTsuspensionBallViewTag;
    [[UIApplication sharedApplication].keyWindow insertSubview:ballView atIndex:9999];
}

- (void)hangUpView {
    self.isHangUp = YES;
}

- (void)setIsHangUp:(BOOL)isHangUp {
    if (_isHangUp == isHangUp) {
        return;
    }
    _isHangUp = isHangUp;
    __block CGPoint center = self.center;
    [UIView animateWithDuration:0.25 animations:^{
        if (isHangUp) {
            center.x = (center.x >= LTsuspensionBallSupViewSize.width/2)? center.x - self.bounds.size.width/2: center.x + self.bounds.size.width/2;
        }else {
            center.x = (center.x >= LTsuspensionBallSupViewSize.width/2)? center.x + self.bounds.size.width/2: center.x - self.bounds.size.width/2;
        }
        self.center = center;
    }];
    self.alpha = isHangUp?1:LTSuspensionBallDefaluAlpha;
    self.showGress.enabled = !isHangUp;
    self.tapGress.enabled = isHangUp;
}

- (void)setShowtimer:(NSNumber *)showtimer {
    _showtimer = showtimer;
    CGFloat time = [showtimer floatValue];
    if (time > 0) {
        [self performSelector:@selector(setShowtimer:) withObject:@(time-0.25) afterDelay:0.25];
    }else {
        [self setIsHangUp:NO];
    }
}

+ (void)hidenSuspensionBall {
      UIView *ballView = [[UIApplication sharedApplication].keyWindow viewWithTag:LTsuspensionBallViewTag];
     if (ballView) {
         ballView.hidden = YES;
     }
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

@end
