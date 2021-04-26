//
//  LTAutonymRealNameInfoView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/20.
//

#import "LTAutonymRealNameInfoView.h"
#import "LTServicesView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
//#import "LocalData.h"
#import "LTSDKUserModel.h"
@interface LTAutonymRealNameInfoView ()

@property (nonatomic, strong) LTServicesViewItem *acountItem;
@property (nonatomic, strong) LTServicesViewItem *idCardItem;
//@property (nonatomic, strong) LTServicesViewItem *bindPhoneItem;

@end

@implementation LTAutonymRealNameInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self getData];
        self.navigationTitle = @"实名认证";
    }
    return self;
}

- (void)getData {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[LocalData getUserInfo]];
    self.acountItem.serverTitleValueLB.text = [LTSDKUserModel shareManger].realname;// dic[@"realname"]?:@"";
    self.idCardItem.serverTitleValueLB.text = [LTSDKUserModel shareManger].idcard;//dic[@"idcard"]?:@"";
//    self.bindPhoneItem.serverTitleValueLB.text = [LTSDKUserModel shareManger].mobile;//dic[@"mobile"]?:@"";
    
}

- (void)initUI {
    [self addSubview:self.acountItem];
    [self addSubview:self.idCardItem];
//    [self addSubview:self.bindPhoneItem];

    [self.acountItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self);
        make.height.equalTo(@35);
    }];
    
    [self.idCardItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acountItem);
        make.top.equalTo(self.acountItem.mas_bottom).offset(20);
        make.height.equalTo(self.acountItem);
    }];
    
//    [self.bindPhoneItem mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.idCardItem);
//        make.top.equalTo(self.idCardItem.mas_bottom).offset(20);
//        make.height.equalTo(self.idCardItem);
//    }];
}

- (LTServicesViewItem *)acountItem {
    if (!_acountItem) {
        _acountItem = [[LTServicesViewItem alloc] init];
        _acountItem.serverTitleLB.font = LTSDKFont(14);
        _acountItem.serverTitleLB.textColor = HexColor(0x666666);
        _acountItem.serverTitleLB.text = @"认证姓名:";
        _acountItem.serverTitleValueLB.font =  LTSDKFont(14);
        _acountItem.serverTitleValueLB.textColor = HexColor(0x666666);;
    }
    return _acountItem;
}

- (LTServicesViewItem *)idCardItem {
    if (!_idCardItem) {
        _idCardItem = [[LTServicesViewItem alloc] init];
        _idCardItem.serverTitleLB.text = @"身份证号:";
        _idCardItem.serverTitleLB.font = LTSDKFont(14);
        _idCardItem.serverTitleLB.textColor = HexColor(0x666666);
        _idCardItem.serverTitleValueLB.textColor = HexColor(0x666666);
        _idCardItem.serverTitleValueLB.font = LTSDKFont(14);
    }
    return _idCardItem;
}

//- (LTServicesViewItem *)bindPhoneItem {
//    if (!_bindPhoneItem) {
//        _bindPhoneItem = [[LTServicesViewItem alloc] init];
//        _bindPhoneItem.serverTitleLB.text = @"绑定手机:";
//        _bindPhoneItem.serverTitleLB.font = LTSDKFont(14);
//        _bindPhoneItem.serverTitleLB.textColor = HexColor(0x666666);
//        _bindPhoneItem.serverTitleValueLB.textColor = HexColor(0x666666);
//        _bindPhoneItem.serverTitleValueLB.font = LTSDKFont(14);
//    }
//    return _bindPhoneItem;
//}

@end
