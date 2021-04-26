//
//  LTRechargeView.m
//  LTAPI
//
//  Created by 徐广江 on 2020/11/20.
//

#import "LTRechargeView.h"
#import "PrefixHeader.h"
#import "NetServers.h"
#import "PayStyleView.h"
#import "LTABaseView.h"
#import "LTSDKUserModel.h"
#import "DataManager.h"
#import "LTAutonymRealNameView.h"
#import "LTAViewManger.h"
@interface LTRechargeView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UILabel *_feeLab;
    NSArray *_payArr;
    NSMutableAttributedString *_att;
    UITableView *_payStyleTableView;
    NSString *_typeStr;
    UIScrollView *_scrollBg;
}
//@property(weak,nonatomic)UITextField *textField;
@property(weak,nonatomic)UIButton *moneySelectBtn;
@property(weak,nonatomic)UIButton *chooseSelectBtn;
@property (nonatomic, strong) LTALoginTextField *accountTextField;

@end

@implementation LTRechargeView
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationTitle = @"豆点充值";
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPointData) name:@"reloadPointData" object:nil];
        [self loadUI];
        [self getPayStyle];
        
    }
    return self;
}
-(void)reloadPointData
{
    [self getPayStyle];
}
-(void)getPayStyle
{
    [TipView showPreloader];
    [NetServers getRechageTypeOCompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [TipView hidePreloader];
        if (code == 1) {
            NSString *feeStr = [NSString stringWithFormat:@"豆点余额：%@",infoDic[@"point"]];
            [LTSDKUserModel shareManger].point = infoDic[@"point"];
            //刷新我的页面豆点余额
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadPointMain" object:nil];
            
            self->_att = [[NSMutableAttributedString alloc]initWithString:feeStr attributes:@{NSForegroundColorAttributeName:themeYellowCOLOR,NSFontAttributeName:LTSDKFont(18)}];
            [self->_att addAttributes:@{NSForegroundColorAttributeName:TEXTNOMARLCOLOR} range:NSMakeRange(0, 5)];
            self->_feeLab.attributedText =self->_att;
            self->_payArr = infoDic[@"payment"];
            [self->_payStyleTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(self->_payArr.count*44));
            }];
//            LTAPI_DeviceWidth-50
            [self->_scrollBg layoutIfNeeded];
            self-> _scrollBg.contentSize = CGSizeMake(self.frame.size.width, 370+self->_payArr.count*44);
            if (!IsPortrait) {
                self->_scrollBg.contentSize = CGSizeMake(325, 370+self->_payArr.count*44);
            }
            [self->_payStyleTableView reloadData];
        }
    }];
}
-(void)loadUI{

    _scrollBg = [[UIScrollView alloc]init];
    _scrollBg.showsHorizontalScrollIndicator = NO;
    _scrollBg.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollBg];
    [_scrollBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self);
    }];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];

    [recognizer setNumberOfTapsRequired:1];

    [recognizer setNumberOfTouchesRequired:1];

    [_scrollBg addGestureRecognizer:recognizer];

    _feeLab = [UILabel new];
//    _feeLab.attributedText =_att;
    [_scrollBg addSubview:_feeLab];
    [_feeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(16);
        make.width.equalTo(self);
        make.height.equalTo(@25);
    }];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"充值金额";
    lab.font = LTSDKFont(18);
    lab.textColor = TEXTNOMARLCOLOR;
    [_scrollBg addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_feeLab.mas_bottom).offset(16);
        make.left.equalTo(_feeLab);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    UILabel *statteLab = [UILabel new];
    statteLab.text = @"充值豆点后不支持退款";
    statteLab.font = LTSDKFont(10);
    statteLab.textColor = TEXTDEFAULTCOLOR;
    [_scrollBg addSubview:statteLab];
    [statteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right).offset(4);
        make.bottom.equalTo(lab);
    }];
    
    UIButton *btn;
    CGFloat btnW = ((LTAPI_DeviceWidth-50)-16*4)/3;
    if (!IsPortrait) {
        btnW = ((325-50)-16*4)/3;
    }
    CGFloat btnH = 32;
    int row = 0;
    int col = 0;
    NSArray *titlesArr = @[@"10",@"50",@"100",@"500",@"1000",@"2000"];
    for (int i = 0; i < titlesArr.count; ++i) {
        
        row = i/3;
        col = i%3;
        
        btn = [UIButton new];
        [btn setTitle:titlesArr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:TEXTNOMARLCOLOR forState:UIControlStateNormal];
        btn.titleLabel.font = LTSDKFont(14);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 16;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [_scrollBg addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16+col*(btnW+20));
            make.top.equalTo(lab.mas_bottom).offset(16+row*(12+btnH));
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
        
    }
    
    
    _accountTextField = [[LTALoginTextField alloc] init];
    _accountTextField.layer.cornerRadius = 16;
    _accountTextField.layer.masksToBounds = YES;
    _accountTextField.delegate = self;
    _accountTextField.contentInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    _accountTextField.keyboardType =UIKeyboardTypeNumberPad;
    _accountTextField.placeholderText = [[NSAttributedString alloc]initWithString:@"请输入自定义金额" attributes:@{NSFontAttributeName:LTSDKFont(15),NSForegroundColorAttributeName:HexColor(0x999990)}];
    [_scrollBg addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab);
            make.top.equalTo(btn.mas_bottom).offset(16);
            make.right.offset(-32);
            make.height.equalTo(@32);
        }];
    
    UILabel *payTypeLab = [UILabel new];
    payTypeLab.text = @"选择充值方式";
    payTypeLab.font = LTSDKFont(18);
    payTypeLab.textColor = TEXTNOMARLCOLOR;
    [_scrollBg addSubview:payTypeLab];
    [payTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(_accountTextField.mas_bottom).offset(16);
        make.height.equalTo(@20);
    }];
    
    UILabel *insLab = [UILabel new];
    insLab.text = @"(1豆点=1人民币)";
    insLab.font = LTSDKFont(10);
    insLab.textColor = TEXTDEFAULTCOLOR;
    [_scrollBg addSubview:insLab];
    [insLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payTypeLab.mas_right).offset(4);
        make.bottom.equalTo(payTypeLab);
    }];
    
    _payStyleTableView = [[UITableView alloc]init];
    _payStyleTableView.delegate = self;
    _payStyleTableView.dataSource = self;
    _payStyleTableView.backgroundColor = [UIColor clearColor];
    _payStyleTableView.scrollEnabled = NO;
    _payStyleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollBg addSubview:_payStyleTableView];
    [_payStyleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(-10);
        make.top.equalTo(payTypeLab.mas_bottom).offset(12);
        make.height.equalTo(@(_payArr.count*44));
    }];
    
    UIButton *payBtn = [[UIButton alloc] init];
    [payBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_normal") forState:UIControlStateNormal];
    [payBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:UIControlStateHighlighted];
    [payBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    payBtn.backgroundColor = DEFAULTCOLOR;
    payBtn.layer.cornerRadius = 5;
    payBtn.layer.masksToBounds = YES;
    [_scrollBg addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(39);
        make.right.offset(-39);
//        make.bottom.offset(-34);
        make.height.equalTo(@40);
        make.top.equalTo(_payStyleTableView.mas_bottom).offset(16);
    }];
    
//    [_scrollBg layoutIfNeeded];
//    _scrollBg.contentSize = CGSizeMake(LTAPI_DeviceWidth-50, 370+_payArr.count*44);
//    if (!IsPortrait) {
//        _scrollBg.contentSize = CGSizeMake(325, 370+_payArr.count*44);
//    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _payArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
    cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"paycell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    PayStyleView *payView = [PayStyleView new];
    NSString *imageStr = @"";
    if ([_payArr[indexPath.row][@"group"] intValue] == 1) {
        //支付宝图片
        imageStr = @"alipayLogo";
    }else{
        imageStr = @"wxpay";
        
    }
    payView.leftImgView.image = SDK_IMAGE(imageStr);
    payView.payStyleLabel.text = _payArr[indexPath.row][@"name"];
    payView.rightSelectedBtn.tag = [_payArr[indexPath.row][@"type"] intValue]+100;
    [payView.rightSelectedBtn addTarget:self action:@selector(selectedClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.contentView addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.bottom.offset(0);
        make.right.offset(-16);
    }];
    if (indexPath.row == 0) {
        payView.rightSelectedBtn.selected = YES;
        _typeStr =_payArr[indexPath.row][@"type"];
        self.chooseSelectBtn = payView.rightSelectedBtn;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *sender = [cell.contentView viewWithTag:[_payArr[indexPath.row][@"type"] intValue]+100];
    sender.selected = YES;
    [self selectedClick:sender];
}
-(void)selectedClick:(UIButton *)sender
{

    if (self.chooseSelectBtn!=sender) {
        self.chooseSelectBtn.selected = NO;
        sender.selected = YES;
        self.chooseSelectBtn = sender;
        _typeStr = [NSString stringWithFormat:@"%d",sender.tag-100];
    }
}
-(void)btnClick:(UIButton *)sender{
    if (self.moneySelectBtn!=sender) {
        self.moneySelectBtn.selected = NO;
        self.moneySelectBtn.backgroundColor = [UIColor whiteColor];
        sender.selected = YES;
        sender.backgroundColor = themeYellowCOLOR;
        self.moneySelectBtn = sender;
//        self.textField.text = [NSString stringWithFormat:@"   %@",sender.currentTitle];
        _accountTextField.text = [NSString stringWithFormat:@"   %@",sender.currentTitle];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![_accountTextField.text isEqualToString:self.moneySelectBtn.currentTitle]) {
        self.moneySelectBtn.selected = NO;
        self.moneySelectBtn.backgroundColor = [UIColor whiteColor];
    }
    return YES;
}
-(void)payClick
{
    if ([DataManager sharedDataManager].uiConfigModel.isPay_auth && ![[LTSDKUserModel shareManger].auth boolValue]) {
//        [LTAViewManger showSuspensionBallView:^(BOOL isSucess, NSString * _Nullable message, NSDictionary * _Nullable responseDic) {
//            NSLog(@"---------展示悬浮球%@,DIC:%@",message,responseDic);
//        }];
//         [[self getViewController] dismissViewControllerAnimated:YES completion:nil];
        [LTAutonymRealNameView showAutonymRealNameViewIsCanSkip:YES  nextBtnBlock:^{
            [LTAutonymRealNameView hidenAutonymRealNameView];
        } commitBtnBlock:^(NSString * _Nonnull name, NSString * _Nonnull ids) {
            [TipView showPreloader];
            [NetServers userAuthWithName:name ids:ids CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
                [TipView hidePreloader];
                if (code) {
                    [LTSDKUserModel shareManger].auth = @(YES);
                    [LTSDKUserModel shareManger].idcard = infoDic[@"idcard"];
                    [LTSDKUserModel shareManger].realname = infoDic[@"realname"];
                    [LTAutonymRealNameView hidenAutonymRealNameView];
                    
                }else {
                    [TipView toast:msg];
                }
            }];
        }];
        return;
    }else{
        [self rechageClick];
    }
    
    
}
-(void)rechageClick
{
    if ([_accountTextField.text containsString:@" "]) {
        _accountTextField.text = [_accountTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (_accountTextField.text.length<1) {
        [TipView toast:@"请先输入支付金额"];
        return;
    }
    if ([_typeStr isEqualToString:@""]) {
        [TipView toast:@"请先选择支付方式"];
        return;
    }
    
    [TipView showPreloader];
    [NetServers rechageECoinWithType:_typeStr payFee:_accountTextField.text completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [TipView hidePreloader];
        if (code == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:infoDic[@"pay_url"]]];
        }
        else{
            [TipView toast:[NSString stringWithFormat:@"    %@     ",msg]];
        }
    }];
}
//获取当前控制器的方法
- (UIViewController *)getViewController {
    UIView *view = self.superview;
    while(view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
    }
    return nil;
}
- (void)touchScrollView
{
    [_accountTextField endEditing:YES];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
