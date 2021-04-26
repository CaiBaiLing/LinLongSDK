//
//  ViewController.m
//  testLogin
//
//  Created by zuzu360 on 2019/12/9.
//  Copyright © 2019 zuzu360. All rights reserved.
//

#import "ViewController.h"
#import <LTAPI/LTSDK.h>
#import <LTAPI/TipView.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *payTextF;
@property (nonatomic, assign) BOOL isShowBoall;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"vgBG" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:fileString];
    self.view.layer.contents = (id)image.CGImage;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAcountNotify) name:LTSDKACOUNTQUITNOTIFYKEY object:nil];
    NSLog(@"LTSDKVersion-------%@", [LTSDK getVersion]);
}

- (void)changeAcountNotify {
    NSLog(@"************切换账号******************");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LTSDKACOUNTQUITNOTIFYKEY object:nil];
}

- (IBAction)showLogin:(id)sender {
    NSLog(@"LTAPIVersionNumber = %@",[LTSDK getVersion]);
    [LTSDK showLoginWithRequestBack:^(BOOL isSucess, NSString * _Nullable message, NSDictionary * _Nullable responseDic) {
        [TipView toast:message];
    }];
}

- (IBAction)payOder:(id)sender {
    //支付参数
    NSDictionary *paraDic = @{
        key_out_trade_no:[self getSTimestamp],//游戏订单号
        key_product_price:self.payTextF.text,//产品价格
        key_product_count:@"1",//产品数量
        key_product_id:@"mhfsl1.lt6",//注意！！！（此参数是产品的唯一标识，内购时从苹果开发者平台获取）
        key_product_name:@"60元宝",//产品名称
        key_product_desc:@"充值6元获得60元宝",//产品描述
        key_exchange_rate:@"10",//虚拟币兑换比例（例如100，表示1元购买100虚拟币） 默认为0。(目前只做记录，不参与计算支付价格)
        key_currency_name:@"元宝",//虚拟币名称（如金币、元宝）
        key_role_type:@"3",//数据类型,默认0其它，(1为进入游戏，2为创建角色，3为角色升级)默认为0
        key_server_id:@"server_02",//服务器ID
        key_server_name:@"6服-精灵之怒",//服务器名称
        key_role_id:@"role_01",//角色ID
        key_role_name:@"Amigo丶红太狼",//角色名称
        key_party_name:@"Amigo",//工会
        key_role_level:@"300",//角色等级
        key_role_vip:@"15",//玩家vip等级，如果没有，请填0。
        key_role_balance:@"3000",//玩家游戏中游戏币余额，留两位小
        key_rolelevel_ctime:@"0",//玩家创建角色的时间 时间戳(11位的整数，单位秒)，默认0
        key_rolelevel_mtime:@"0",//玩家创建角色的时间 时间戳(11位的整数，单位秒)，默认0
        key_extendString :@"",//厂商提出的extend 非必须 可以传空 @“”
    };
    //开始支付(#######只对订单请求做回调，不监听支付结果######)
    [LTSDK buy:paraDic failedBlock:^{
        [TipView toast:@"支付失败"];
    }];
}

- (IBAction)setUserInfo:(id)sender {
    //角色参数
    NSDictionary *paraDic = @{
        key_role_type:@2,//数据类型,默认0其它，(1为进入游戏，2为创建角色，3为角色升级)默认为0
        key_server_id:@"service_01", //服务器ID
        key_server_name:@"service_name",//服务器名称
        key_role_id:@"role_01", //角色ID
        key_role_name:@"role_name", //角色名称
        key_party_name:@"我是工会名称",//工会
        key_role_level:@4, //角色等级
        key_role_vip:@"100", //玩家vip等级，如果没有，请填0。
        key_role_balance:@"2131", //玩家游戏中游戏币余额，留两位小数;如果没有账户余额，请填0。
        key_rolelevel_ctime:@"1479196021", //玩家创建角色的时间 时间戳(11位的整数，单位秒)，默认0
        key_rolelevel_mtime:@"1479196736",//玩家创建角色的时间 时间戳(11位的整数，单位秒)，默认0
    };
    [LTSDK setRoleInfo:paraDic requestResult:^(BOOL isSucess, NSString * _Nullable message, NSDictionary * _Nullable responseDic) {
        if (isSucess) {
            [TipView toast:@"设置角色成功"];
        } else {
            [TipView toast:@"设置角色失败"];
        }
    }];
}

- (NSString *)getSTimestamp {
    double secondTime=[[[NSDate alloc]init]timeIntervalSince1970]*1000;
    NSString * secondTimeStr=[NSString stringWithFormat:@"%f",secondTime];
    NSRange pointRange=[secondTimeStr rangeOfString:@"."];
    NSString * MSTime=[secondTimeStr substringToIndex:pointRange.location];
    return MSTime;
}

- (IBAction)quitLogin:(id)sender {
    [LTSDK logoutWithRequestBack:^(BOOL isSucess,NSString *message,NSDictionary *responseDic) {
        ///可以处理提示信息
        [TipView toast:message];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
