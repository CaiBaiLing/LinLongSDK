//
//  LTMeMainView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/17.
//

#import "LTMeMainView.h"
#import "LocalData.h"
#import "NetServers.h"
#import "PrefixHeader.h"
#import "LTUserCenterSelectItemCell.h"
#import "Masonry.h"
#import "LTSDKUserModel.h"
#import "LTUserCenterUserAccountCell.h"

static NSString *LTUserCenterViewController_selectItemCell = @"LTUserCenterSelectItemCell";
static NSString *LTUserCenterViewController_AccountCell = @"LTUserCenterUserAccountCell";

@implementation LTMeItemModel

@end


@interface LTMeMainView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) NSMutableArray<NSArray<LTMeItemModel *> *> *itemArray;
@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, assign) BOOL isbindMobile;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userMobile;
@property (nonatomic, copy) NSString *coinString;
@end


@implementation LTMeMainView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"reloadPointMain" object:nil];
        [self initUI];
        //self.navigationTitle = @"我的";
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.tabel];
    [self addSubview:self.bottomLabel];

    [self.tabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.centerX.equalTo(self);
    }];
    
    [self getdata];
}

- (void)reloadData {
    [self getdata];
}

- (void)getdata {
    self.itemArray = [NSMutableArray array];
    self.backgroundColor = HexAlphaColor(0xFFFFFF, 0.0);
    //NSDictionary *userInfo = [LocalData getUserInfo];//[NSUserDefaults standardUserDefaults] objectForKey:@"KEY_USERINFO"];
    self.isAuth = [[LTSDKUserModel shareManger].auth boolValue];// [userInfo[@"auth"] boolValue];
    self.userMobile = [LTSDKUserModel shareManger].mobile;//userInfo[@"mobile"]?:@"";
    self.isbindMobile = self.userMobile.length > 0;
    self.userName = [LTSDKUserModel shareManger].uname;//userInfo[@"uname"]?:@"";
    self.coinString =[LTSDKUserModel shareManger].point;
    LTMeItemModel *model = [[LTMeItemModel alloc] init];
    model.valueString = self.userName;
    model.sel = @selector(changeUserAcount);
    
    LTMeItemModel *authModel = [[LTMeItemModel alloc] init];
    authModel.valueString = @"实名认证";
    authModel.docmentString = self.isAuth?@"已认证":@"未认证";
    authModel.docmentColor = self.isAuth?HexColor(0x666666):themeYellowCOLOR;
    authModel.sel = self.isAuth?@selector(getAuthRealNameInfoView):@selector(showAuthRealNameView:);
    authModel.selObjfirst = @(self.isbindMobile);
    
    LTMeItemModel *bindPhoneModel = [[LTMeItemModel alloc] init];
    bindPhoneModel.valueString = @"绑定手机";
    bindPhoneModel.docmentString = self.isbindMobile?self.userMobile:@"未绑定";
    bindPhoneModel.docmentColor = themeYellowCOLOR;
    bindPhoneModel.sel = @selector(bindOrReplaceBindPhoneNo:);
    bindPhoneModel.selObjfirst = self.userMobile;//self.userMobile;
    
    LTMeItemModel *editPsdModel = [[LTMeItemModel alloc] init];
    editPsdModel.valueString = @"修改密码";
    editPsdModel.docmentString = @"";
    editPsdModel.sel = @selector(editPasswordView:isBindPhone:);
    editPsdModel.selObjfirst = self.isbindMobile?self.userMobile:self.userName;
    editPsdModel.selObjsecond = @(self.isbindMobile);
    [self.itemArray addObject:@[model,authModel,bindPhoneModel,editPsdModel]];
    
    LTMeItemModel *serversModel = [[LTMeItemModel alloc] init];
    serversModel.valueString = @"客服信息";
    serversModel.docmentString = @"";
    serversModel.sel = @selector(getServicesView);
    
    
    LTMeItemModel *coinModel = [[LTMeItemModel alloc] init];
    coinModel.valueString = @"豆点余额";
    coinModel.docmentColor = HexColor(0xFF8500);
    [self.itemArray addObject:@[serversModel,coinModel]];
    [self.tabel reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 60;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sessionArrya = self.itemArray[indexPath.section];
    LTMeItemModel *itemDic = sessionArrya[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        LTUserCenterUserAccountCell *headCell = [tableView dequeueReusableCellWithIdentifier:LTUserCenterViewController_AccountCell forIndexPath:indexPath];
        __weak typeof (self)weakSelf = self;
        [headCell setAccontName:itemDic.valueString headImage:nil chenageAccountBlock:^{
            __strong typeof (weakSelf) self = weakSelf;
            [self doSomethingWithSel:itemDic];
        }];
        return headCell;
    }
    LTUserCenterSelectItemCell *cell = [tableView dequeueReusableCellWithIdentifier:LTUserCenterViewController_selectItemCell forIndexPath:indexPath];
    cell.titleLabel.text = itemDic.valueString;
    cell.accountLabel.text = itemDic.docmentString;
    cell.accountLabel.textColor = itemDic.docmentColor;
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.accountLabel.text = self.coinString?:@"";
        cell.iconImageV.hidden = YES;
        [cell.accountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15).priorityLow;
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *sessionArrya = self.itemArray[indexPath.section];
    LTMeItemModel *itemDic = sessionArrya[indexPath.row];
    [self doSomethingWithSel:itemDic];
}

- (void)doSomethingWithSel:(LTMeItemModel *)itemDic {
    if (self.delegate && [self.delegate respondsToSelector:itemDic.sel]) {
        if (itemDic.selObjfirst && itemDic.selObjsecond) {
            [self.delegate performSelector:itemDic.sel withObject:itemDic.selObjfirst withObject:itemDic.selObjsecond];
        }else if (itemDic.selObjfirst) {
            [self.delegate performSelector:itemDic.sel withObject:itemDic.selObjfirst ];
        }else {
            [self.delegate performSelector:itemDic.sel];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
       if (section == self.itemArray.count-1 ) {
           UIView *bottmView = [[UIView alloc] init];
           UIView *lineView = [[UIView alloc] init];
           lineView.backgroundColor = HexColor(0xCCCCCC);
           [bottmView addSubview:lineView];
           [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.height.bottom.right.equalTo(bottmView);
               make.left.equalTo(bottmView).offset(20);
           }];
           return bottmView;
       }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.itemArray.count-1 ) {
        return 1;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableView *)tabel {
    if (!_tabel) {
        _tabel = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabel.delegate = self;
        _tabel.dataSource = self;
        [_tabel registerClass:NSClassFromString(LTUserCenterViewController_selectItemCell)  forCellReuseIdentifier:LTUserCenterViewController_selectItemCell];
        [_tabel registerClass:NSClassFromString(LTUserCenterViewController_AccountCell) forCellReuseIdentifier:LTUserCenterViewController_AccountCell];
        _tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabel.scrollEnabled = NO;
        _tabel.backgroundColor = HexAlphaColor(0xFFFFFF, 0.0);
    }
    return _tabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = LTSDKFont(10);
        _bottomLabel.textColor = HexColor(0x999999);
        _bottomLabel.text = LTSDKVERSION;
    }
    return _bottomLabel;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
