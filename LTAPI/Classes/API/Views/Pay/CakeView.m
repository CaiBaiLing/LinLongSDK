//
//  LTPView.m
//  LTSDK
//
//  Created by zhengli on 2018/4/26.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "CakeView.h"
#import "LocalData.h"
#import "OrderModel.h"
#import "NetServers.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import "PayStyleView.h"

@interface CakeView()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *order_code;
    NSString *coinStr;
    NSArray *_payArr;
    UIButton *_payBtn;
    UIScrollView *_scrollBg;
    UILabel *_payStyleLabel;
}
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *PBLabel;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UIView *payItemView;
@property (nonatomic, copy) NSDictionary *cakeDic;
@property (nonatomic,strong)NSArray *orderItemArr;
@property (nonatomic, copy)NSString *typeStr;//支付方式
@property (nonatomic,strong) UITableView *goodsTableView;
@property (nonatomic,strong) UITableView *payStyleTableView;
@property (nonatomic, copy) NSString *totalFee;//商品金额
@property (nonatomic, copy) NSString *rebate;//会员专享打折
@property (nonatomic, copy) NSString *payed_fee;//打折后的价格
@property (nonatomic,copy)NSString *descName;
@property(weak,nonatomic)UIButton *chooseSelectBtn;

@end

//类View
@implementation CakeView

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"订单支付";
        _titleLabel.font = LTSDKFont(20);
    }
    return _titleLabel;
}


- (UILabel *)PBLabel {
    if (!_PBLabel) {
        _PBLabel = [[UILabel alloc]init];
        _PBLabel.textColor = [UIColor orangeColor];
        _PBLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _PBLabel;
}

- (UIButton *)quitButton {
    if (!_quitButton) {
        _quitButton = [[UIButton alloc] init];//关闭按钮--显示用
        [_quitButton setImage:SDK_IMAGE(@"icon_wode_guanbi") forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}

- (UIView *)payItemView {
    if (!_payItemView) {
        _payItemView = [[UIView alloc] init];
    }
    return _payItemView;
}
-(UITableView *)goodsTableView
{
    if (!_goodsTableView) {
        _goodsTableView = [[UITableView alloc]init];
        _goodsTableView.delegate = self;
        _goodsTableView.dataSource = self;
        _goodsTableView.backgroundColor = [UIColor clearColor];
        _goodsTableView.scrollEnabled = NO;
        _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _goodsTableView;
}
-(UITableView *)payStyleTableView
{
    if (!_payStyleTableView) {
        _payStyleTableView = [[UITableView alloc]init];
        _payStyleTableView.delegate = self;
        _payStyleTableView.dataSource = self;
        _payStyleTableView.scrollEnabled = NO;
        _payStyleTableView.backgroundColor = [UIColor whiteColor];
        _payStyleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _payStyleTableView;
}
//释放通知内存
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithCakeView:(NSDictionary *)cakeDic{
    self = [super init];
    if (self) {
        self.orderItemArr = @[@"购买商品",@"商品金额",@"豆点支付",@"实付金额"];
        _payArr = @[];
        self.typeStr = @"";
        [self initUI];
        self.cakeDic = cakeDic;
    }
    return self;
}
- (void)initUI {
     self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;// FUNC_FITLEN(5.0);
        self.layer.masksToBounds = YES;
    
    _scrollBg = [UIScrollView new];
    _scrollBg.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollBg];
    [_scrollBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.offset(0);
    }];
    
        [_scrollBg addSubview:self.titleLabel];
        [_scrollBg addSubview:self.quitButton];

        [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(LTSDKScale(16)));
            make.left.right.equalTo(self);
            make.height.equalTo(@20);
        }];
        [_scrollBg addSubview:self.goodsTableView];
        
        UIImageView *tableBgImgView = [[UIImageView alloc]initWithImage:SDK_IMAGE(@"orderPayBg")];
        self.goodsTableView.backgroundView = tableBgImgView;
        
        _payStyleLabel = [[UILabel alloc]init];
        _payStyleLabel.text = @"选择支付方式：";
        _payStyleLabel.font = [UIFont systemFontOfSize:16];
        _payStyleLabel.textColor = HexColor(0x333333);
        [self addSubview:_payStyleLabel];
        
        [_scrollBg addSubview:self.payStyleTableView];
        
        _payBtn = [[UIButton alloc]init];
        [_payBtn setBackgroundImage:SDK_IMAGE(@"ios_denglu_selected") forState:(UIControlStateNormal)];
        [_payBtn setTitle:@"确认购买" forState:(UIControlStateNormal)];
        [_payBtn addTarget:self action:@selector(cakeAction) forControlEvents:(UIControlEventTouchUpInside)];
        _payBtn.titleLabel.font = LTSDKFont(16);
        [_payBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_scrollBg addSubview:_payBtn];
        
//        if (!IsPortrait) {
            
            [self.goodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.right.equalTo(self);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
                make.height.equalTo(@125);
                
            }];
            
            [_payStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(13);
                make.right.offset(-24);
                make.top.equalTo(self.goodsTableView.mas_bottom).offset(5);
                make.height.equalTo(@40);
            }];
            
            [self.payStyleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.right.equalTo(self.goodsTableView);
                            make.top.equalTo(_payStyleLabel.mas_bottom);
                make.height.equalTo(@(_payArr.count*32));
//                            make.bottom.equalTo(_payBtn.mas_top).offset(-10);
              }];
            
            [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.mas_bottom).offset(-5);
                make.top.equalTo(self.payStyleTableView.mas_bottom).offset(16);
                make.centerX.equalTo(self);
                make.height.equalTo(@40);
                make.width.equalTo(@240);
            }];
            
            
            
//        }else{
//            //竖屏
//
//            [self.goodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.offset(0);
//                make.right.offset(0);
//                make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
//                make.height.equalTo(@125);
//
//            }];
//            [payStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.offset(13);
//                make.right.offset(-24);
//                make.top.equalTo(self.goodsTableView.mas_bottom).offset(10);
//                make.height.equalTo(@40);
//            }];
//
//            [self.payStyleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.offset(0);
//                make.right.offset(0);
//                make.top.equalTo(payStyleLabel.mas_bottom);
//                make.height.equalTo(@136);
//            }];
//
//            [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.mas_bottom).offset(-10);
//                make.centerX.equalTo(self);
//                make.height.equalTo(@40);
//                make.width.equalTo(@230);
//            }];
//        }
    
}

- (void)setCakeDic:(NSDictionary *)cakeDic {
    _cakeDic = cakeDic;
    self.descName = cakeDic[@"desc"];
    self.totalFee = [NSString stringWithFormat:@"%@",cakeDic[@"total_fee"]];
    order_code = cakeDic[@"order_code"];
    self.payed_fee = [NSString stringWithFormat:@"%@",cakeDic[@"pay_fee"]];
    coinStr = [NSString stringWithFormat:@"%@",cakeDic[@"point"]];
    
    _payArr = cakeDic[@"payment"];
   
    [self.payStyleTableView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(@(_payArr.count*32+10));
    }];
    
    if ([self.payed_fee floatValue] == 0.00) {
        [_payStyleLabel removeFromSuperview];
        [self.payStyleTableView removeFromSuperview];
        [_payBtn setTitle:@"豆点支付" forState:(UIControlStateNormal)];
        [_payBtn mas_updateConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.goodsTableView.mas_bottom).offset(32);
                        
         }];
    }
    
    [_scrollBg layoutIfNeeded];
    _scrollBg.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(_payBtn.frame)+20);
    
    [self.goodsTableView reloadData];
    [self.payStyleTableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.goodsTableView]) {
        return self.orderItemArr.count;
    }else{
        return _payArr.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.goodsTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.orderItemArr[indexPath.row];
        cell.textLabel.font = LTSDKFont(16);
        cell.textLabel.textColor = TEXTNOMARLCOLOR;
        cell.detailTextLabel.font = LTSDKFont(16);
        cell.detailTextLabel.textColor =TEXTNOMARLCOLOR;
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.descName];
        }
        if(indexPath.row == 1){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",self.totalFee];
        }
        if(indexPath.row == 2){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"-￥%@",coinStr];
        }
        if(indexPath.row == 3){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.payed_fee];
            cell.detailTextLabel.textColor =themeYellowCOLOR;
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paycell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"paycell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
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
            self.chooseSelectBtn = payView.rightSelectedBtn;
            self.typeStr=_payArr[indexPath.row][@"type"];
        }
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.payStyleTableView]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *sender = [cell.contentView viewWithTag:[_payArr[indexPath.row][@"type"] intValue]+100];
        sender.selected = YES;
        [self selectedClick:sender];
    }

}

-(void)selectedClick:(UIButton *)sender
{
    
    if (self.chooseSelectBtn!=sender) {
        self.chooseSelectBtn.selected = NO;
        sender.selected = YES;
        self.chooseSelectBtn = sender;
        self.typeStr = [NSString stringWithFormat:@"%ld",sender.tag-100];
    }
}


- (void)cakeAction{
    if ([self.payed_fee floatValue] == 0.00) {
        self.typeStr = @"0";
    }else if (self.chooseSelectBtn.selected == NO) {
        [TipView toast:@"请先选择支付方式"];
        return;
    }
    [TipView showPreloader];
    [NetServers getOrderWithIOP:@{@"order_code":order_code,@"type":self.typeStr} ompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [TipView hidePreloader];
        if (code) {
            if (![self.typeStr isEqualToString:@"0"]) {
                [LocalData setIop:@"1"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:infoDic[@"iop"]]];
            }else{
                [TipView toast:@"支付成功"];
                [self closeWindow];
            }
        }else{
             [TipView toast:msg];
        }
        
        
    }];
}

//关闭窗口
- (void)closeWindow{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_CLOSE_CAKE_WINDOW" object:nil];
}

@end
