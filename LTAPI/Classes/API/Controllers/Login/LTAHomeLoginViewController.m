//
//  LTAHomeLoginViewController.m
//  LTAPI
//
//  Created by zuzu360 on 2019/12/25.
//  Copyright © 2019 LTSDK. All rights reserved.
//

#import "LTAHomeLoginViewController.h"
//#import "LTAForgetPasswordViewController.h"
#import "LTAViewManger.h"
#import "LTAHomeLoginView.h"
#import "LTFastRegiestView.h"
#import "LTPhoneRegiestView.h"
#import "PrefixHeader.h"
#import "NetServers.h"
#import "Masonry.h"
#import "LocalData.h"
//#import "IAPServers.h"
#import "DataManager.h"
#import "NSString+StrHelper.h"
#import "LTRegisterSuccessView.h"
#import "LTLoginProgressView.h"
#import <Photos/Photos.h>
#import "LTAutonymRealNameView.h"
#import "LTSuspensionBall.h"
#import "LTUserProtocolAndPrivateController.h"
#import "LTFrogotView.h"
#import "LTAViewManger.h"
#import "LTBindPhoneView.h"
#import "ActivityAlertView.h"

#define subViewHeight  LTSDKScale(300)

@interface LTAHomeLoginViewController ()<LTAHomeLoginViewDelegate, LTFastRegiestViewDelegate,LTPhoneRegiestViewDelegate,LTFrogotViewDelegate>

@property (nonatomic, strong) LTAHomeLoginView *loginView;
@property (nonatomic, strong) LTFastRegiestView *fastRegiestView;
@property (nonatomic, strong) LTPhoneRegiestView *phoneRegiestView;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, copy) NSString *phoneNo;
@property (nonatomic, strong) LTFrogotView *forgotView;
@end

@implementation LTAHomeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取sid  设置给单例
    DataManager.sharedDataManager.sid = [NetServers getPageSid];
    
    [self getHomeConfig];
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.fastRegiestView];
    [self.view addSubview:self.phoneRegiestView];
    [self.view addSubview:self.forgotView];
    self.currentView = self.loginView;
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(LTAPI_SubViewWidth));
        make.height.equalTo(@(subViewHeight));
    }];
    [self.fastRegiestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(LTAPI_SubViewWidth));
        make.height.equalTo(@(subViewHeight));
        make.centerY.equalTo(self.view).offset(UIScreen.mainScreen.bounds.size.height + 400);
    }];
    [self.phoneRegiestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(LTAPI_SubViewWidth));
        make.height.equalTo(@(subViewHeight));
        make.centerY.equalTo(self.view).offset(UIScreen.mainScreen.bounds.size.height + 400);
    }];
    [self.forgotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(LTAPI_SubViewWidth));
        make.height.equalTo(@(subViewHeight));
        make.centerY.equalTo(self.view).offset(UIScreen.mainScreen.bounds.size.height + 400);
    }];
    self.title = @"用户登录";
}

- (void)getHomeConfig{
    if (![[DataManager sharedDataManager].uiConfigModel isReg]) {
        [self.loginView hidenFastRegiestAction];
        [self.loginView hidenPhoneRegiestAction];
    }else {
        if (![[DataManager sharedDataManager].uiConfigModel isFastreg]) {
            [self.phoneRegiestView hidenFastRegiestAction];
            [self.loginView hidenFastRegiestAction];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //自动登录
    NSArray *userArray = [DataManager sharedDataManager].userInfo.acountList;
    if (userArray.count >0 && self.isAutoLogin) {
        NSDictionary *lastDic = userArray.lastObject;
        [self homeLoginClickActionAccount:lastDic.allKeys.firstObject password:lastDic.allValues.firstObject];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - -----------PubLicDelegate--------------
///3.获取验证码
-(void)getPhoneCode:(NSString *)phoneNo regiestType:(NSInteger)type requestHandle:(nonnull void (^)(BOOL))handle {
    [TipView showPreloader];
    if (type == 0) {
        [NetServers sendSmscodeWithPhoneNo:phoneNo completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TipView hidePreloader];
                [TipView toast:msg];
                if (handle) {
                    handle(code);
                }
            });
        }];
    }
}

///4. 一键注册按钮
- (void)fastLoginClickAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.fastRegiestView.account = [NSString getRoundAccountWihtLenth:8];
        self.fastRegiestView.psd = [NSString getRoundPsswordWihtLenth:8];
        [self startAnimationView:self.fastRegiestView];
    });
}

///5. 已有账号按钮
- (void)accountLoginClickAction {
    [self startAnimationView:self.loginView];
}

///6.手机注册按钮
///@param phone 手机号
- (void)phoneRegiestClickAction:(NSString *)phone {
    [self startAnimationView:self.phoneRegiestView];
}

- (void)readPrivacyPolicyClickAction {
    LTUserProtocolAndPrivateController *protocol = [[LTUserProtocolAndPrivateController alloc] init];
    protocol.webURL = LTSDPolicyURL;
    [self.navigationController pushViewController:protocol animated:YES];
}

///7.阅读协议
- (void)readProtocolClickAction {
    LTUserProtocolAndPrivateController *protocol = [[LTUserProtocolAndPrivateController alloc] init];
    protocol.webURL = LTSDKAgreementURL;
    [self.navigationController pushViewController:protocol animated:YES];
}

#pragma mark - -----------homeLoginViewDelegate--------------
//忘记密码
- (void)forgetPasswordClickAction:(NSString *)phone {
    [self startAnimationView:self.forgotView];
}

//账号登录
- (void)homeLoginClickActionAccount:(NSString *)account password:(NSString *)password {
    [self.view endEditing:YES];
    //开始API验证账号密码
    
    [LTLoginProgressView showLoginSuccessWithUserName:account changeBtnBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isAutoLogin = NO;
            [self startAnimationView:self.loginView];
        });
        [LTLoginProgressView hidenLoginSuccessView];
    } hidenBlock:^{
        [NetServers loginWithAccount:account psd:password completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
            [LTLoginProgressView hidenLoginSuccessView];
            if (code == 1) {
                [[LTSDKUserModel shareManger] addAcountToList:@{account:password}];
                [self loginSucessWithInfo:infoDic];
                return;
            }
            [TipView toast:msg];
        }];
    }];
}

//保存用户名到本地


#pragma mark - -----------fastRegiestViewDelegate--------------
//一键注册
- (void)fastRegiestClickActionAccount:(NSString *)account password:(NSString *)password {
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        if ([PHPhotoLibrary authorizationStatus]  == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self fastRegiestClickActionAccount:account password:password];
            }];
        }else {
            UIAlertController *alerControler = [UIAlertController alertControllerWithTitle:@"提示" message:@"相册权限暂未授权！！\n请去设置中授权!!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alerControler addAction:enterAction];
            alerControler.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController presentViewController:alerControler animated:YES completion:nil];
        }
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [TipView showPreloader];
    });
    
    [NetServers userRegistWithUserName:account psd:password completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (code) {
                [[LTSDKUserModel shareManger] cacheModelWithUserInfo:infoDic];
                [self showSucessView:account psd:password];
                BigLog(@"用户信息 = %@",[[LTSDKUserModel shareManger] userInfoDesc]);
                [TipView toast:@"注册成功"];
                return;
                //[IAPServers verifyWithCakeTrasaction];//检查内购验单
            }
            [TipView toast:msg];
        });
    }];
}
#pragma mark - -----------phoneRegiestViewDelegate--------------
//立即注册
- (void)phoneRegiestClickAction:(NSString *)phoneNo phoneCode:(NSString *)phoneCode password:(NSString *)psd {
    [TipView showPreloader];
    [NetServers mobileRegistPhoneNo:phoneNo passwd:psd vercode:phoneCode completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [TipView hidePreloader];
        if (code == 1) {
            [self.phoneRegiestView releseTime];
            [DataManager sharedDataManager].userInfo.uname = phoneNo;
            [[LTSDKUserModel shareManger] addAcountToList:@{phoneNo:psd}];
            [self loginSucessWithInfo:infoDic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [TipView toast:msg];
        });
    }];
}

#pragma mark - -----------get&&Set--------------
- (LTAHomeLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[LTAHomeLoginView alloc] init];
        _loginView.delegate = self;
    }
    return _loginView;
}
- (LTFastRegiestView *)fastRegiestView {
    if (!_fastRegiestView) {
        _fastRegiestView = [[LTFastRegiestView alloc] init];
        _fastRegiestView.delegate = self;
        _fastRegiestView.alpha = 0;
    }
    return _fastRegiestView;
}
- (LTPhoneRegiestView *)phoneRegiestView {
    if (!_phoneRegiestView) {
        _phoneRegiestView = [[LTPhoneRegiestView alloc] init];
        _phoneRegiestView.delegate = self;
        _phoneRegiestView.alpha = 0;
    }
    return _phoneRegiestView;
}

- (LTFrogotView *)forgotView {
    if (!_forgotView) {
        _forgotView = [[LTFrogotView alloc] init];
        _forgotView.delegate = self;
    }
    return _forgotView;
}

#pragma mark - -----------homeLoginViewDelegate--------------
- (void)dealloc {
    NSLog(@"  %@ 释放了  ",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)startAnimationView:(UIView *)view {
    if (self.currentView == view) {
        return;
    }
    [self.view insertSubview:view aboveSubview:self.currentView];
    //[self.currentView removeFromSuperview];
    UIView *oldView = self.currentView;
    self.currentView = view;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(UIScreen.mainScreen.bounds.size.height + 400);
    }];
    /**动画部分 开启需注释***/
    oldView.alpha = 0;
    self.currentView.alpha = 1;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
    }];
}
//展示实名认证 view
- (void)loginSucessWithInfo:(NSDictionary *)info {
    self.view.hidden = YES;
    [[LTSDKUserModel shareManger] cacheModelWithUserInfo:info];
    //[IAPServers verifyWithCakeTrasaction];//检查内购验单
//    __weak typeof(self) weakSelf = self;
    self.phoneNo = info[@"mobile"];
    
    //实名认证
    if (![info[@"auth"] boolValue] && [DataManager sharedDataManager].uiConfigModel.isAuth != LTAuthTypeNO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LTAutonymRealNameView showAutonymRealNameViewIsCanSkip:[DataManager sharedDataManager].uiConfigModel.isAuth == LTAuthTypeYes nextBtnBlock:^{
                [LTAutonymRealNameView hidenAutonymRealNameView];
                //取消认证
                [self loginSuccessBindPhone];
            } commitBtnBlock:^(NSString * _Nonnull name, NSString * _Nonnull ids) {
                //点击认证
                [TipView showPreloader];
                [NetServers userAuthWithName:name ids:ids CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                    [TipView hidePreloader];
                    NSLog(@" msg = %@",msg);
                    [TipView toast:msg];
                    if (code) {
                        [LTSDKUserModel shareManger].auth = @(YES);
                        [LTSDKUserModel shareManger].idcard = infoDic[@"idcard"];
                        [LTSDKUserModel shareManger].realname = infoDic[@"realname"];
                        [LTAutonymRealNameView hidenAutonymRealNameView];
                        [self loginSuccessBindPhone];
                        return;
                    }
                    [TipView toast:msg];
                }];
            }];
        });
        return;
    }
    [self loginSuccessBindPhone];
}
-(void)loginSuccessBindPhone
{
    BOOL isBindPhone = self.phoneNo.length > 0;
    //绑定手机
    if (!isBindPhone && [DataManager sharedDataManager].uiConfigModel.isBindPhoneAuth != LTBindPhoneTypeNO) {
        [LTPopBindPhoneView showBindPhoneViewIsJump:[DataManager sharedDataManager].uiConfigModel.isBindPhoneAuth == LTBindPhoneTypeYes isAphal:YES bindSucess:^{
            [self loginSuccess];
        }];
        return;
    }
    [self loginSuccess];
}
#pragma mark - 保存View到相册 -
- (void)loginSuccess {
    if(![DataManager sharedDataManager].uiConfigModel.isLogin) {
        [TipView toast:@"该游戏暂未开启登录功能"];
        //没有开启登录功能清除uid session
        [LTSDKUserModel shareManger].session = nil;
        [LTSDKUserModel shareManger].uid = nil;
        return ;
    }
    if (self.loginCallBack) {
        self.loginCallBack(YES,@"登录成功",[[LTSDKUserModel shareManger] userInfoDesc]);
    }
    [LTAutonymRealNameView hidenAutonymRealNameView];
    //公告弹窗
    //活动公告
    [ActivityAlertView showAlertViewWithagreeBlock:^{
        
    } readPrivacyPolicyBlock:^{
        
    } readProtocolBlock:^{
        
    }];
    
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
// 展示注册成功 view
- (void)showSucessView:(NSString *)account psd:(NSString *)psd {
    LTRegisterSuccessView *sv = [[LTRegisterSuccessView alloc] init];
    __weak typeof(self) weakSelf = self;
    [sv setUserName:account psd:psd loginBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LTSDKUserModel shareManger] addAcountToList:@{account:psd}];
            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
            [weakSelf loginSucessWithInfo: [DataManager.sharedDataManager.userInfo userInfoDesc]];
        });
    }];
    [self.view insertSubview:sv atIndex:99];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fastRegiestView);
    }];
    [self.view layoutIfNeeded];
    [self saveImageForPhotoLibWithView:sv];
    
}

#pragma mark - 保存View到相册 -
- (void)saveImageForPhotoLibWithView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);//把图片保存在本地
}

#pragma mark - LTFrogotViewDelegate忘记密码代理 -
- (void)getPhoneCodeAction:(NSString *)phoneNo requestHandler:(nonnull void (^)(BOOL))handle{
    [TipView showPreloader];
    [NetServers sendFotgotSmscodeWithPhoneNo:phoneNo completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TipView hidePreloader];
            [TipView toast:msg];
            if (handle) {
                handle(code);
            }
        });
    }];
}

- (void)enterBtnAction:(NSString *)phoneNo phoneCode:(NSString *)phoneCode password:(NSString *)psd {
    [TipView showPreloader];
    [NetServers mobileRepasswdWithPhoneNo:phoneNo passwd:psd vercode:phoneCode completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TipView hidePreloader];
            [TipView toast:msg];
            if (code == 1) {
                [TipView alert:msg];
                [self startAnimationView:self.loginView];
                [self.forgotView releaseTime];
                [[LTSDKUserModel shareManger] changPasswordWithPassword:psd];
                [self.loginView reloadAcount];
            }
        });
    }];
}

- (void)closeViewAction {
    [self startAnimationView:self.loginView];
}

@end
