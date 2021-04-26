//
//  LTUserCenterViewController.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/7.
//

#import "LTUserCenterViewController.h"
#import "LTUserCenterUserAccountCell.h"
#import "LTUserCenterSelectItemCell.h"
#import "LTAutonymRealNameView.h"
#import "LTSuspensionBall.h"
#import "Masonry.h"
#import "PrefixHeader.h"
#import "NetServers.h"
#import "LocalData.h"
#import "LTMeCenterView.h"

static NSString *LTUserCenterViewController_userAccountCell = @"LTUserCenterUserAccountCell";
static NSString *LTUserCenterViewController_selectItemCell = @"LTUserCenterSelectItemCell";
static NSString *LTUserCenterViewController_footView = @"LTUserCenterFootView";

@interface LTUserCenterViewController ()

@property (nonatomic, strong) UITableView *userTabel;
@property (nonatomic, copy) NSArray<NSArray *> *dataArray;
@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, assign) BOOL isbindMobile;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, assign) UIDeviceOrientation orientation;

@property (nonatomic, strong) LTMeCenterView *meView;

@end

@implementation LTUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.meView = [[LTMeCenterView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.meView.quitActionBlock = ^{
        [weakSelf dismissController];
    };
    [self.view addSubview:self.meView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationOrication:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
//    NSString *deviceStr = [DeviceHelper getDeviceType];
    float left = 0;
    if (IphoneX) {
        left = LTSDKScale(30);
    }
    [self.meView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
       
        make.left.equalTo(@( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait? 0:left));
        make.size.mas_equalTo(CGSizeMake(LTSDKScale(375),([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) ?LTSDKScale(580):LTSDKScale(375)));
    }];
}

- (void)notificationOrication:(NSNotification *)faction {
    [self.meView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(@([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft? 38:0));
        make.size.mas_equalTo(CGSizeMake(LTSDKScale(375),([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) ?LTSDKScale(580):LTSDKScale(375)));
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismissController {
    !self.dismissControllerBlock?: self.dismissControllerBlock();
    [self  dismissViewControllerAnimated:NO completion:nil];
}

@end
