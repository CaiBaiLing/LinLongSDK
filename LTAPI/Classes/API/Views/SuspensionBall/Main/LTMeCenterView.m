//
//  LTMeCenterView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/16.
//

#import "LTMeCenterView.h"
#import "LTMeBaseView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import "LTMeMainView.h"
#import "LTServicesView.h"
#import "LTEditPasswordView.h"
#import "LTMeBaseView.h"
#import "LTBindPhoneView.h"
#import "LTAutonymRealNameInfoView.h"
#import "LTAutonymRealNameView.h"
#import "NetServers.h"
#import "LTSDKUserModel.h"
#import "LTMeGiftBag.h"
#import "LTNoticeView.h"
#import "LTRechargeView.h"
#import "LTNoticeDetail.h"

@interface LeftViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageIcon;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIImageView *headImageV;
@property (nonatomic, strong) UILabel *titleb;
@end

@implementation LeftViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
        UIView *itemView = [[UIView alloc] init];
        [self addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@55);
        }];
    
        self.headImageV = [[UIImageView alloc] init];
        [itemView addSubview:self.headImageV];
        [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(itemView);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
       self.titleb = [[UILabel alloc] init];
        self.titleb.text = @"我的";
        self.titleb.font = LTSDKFont(10);
        self.titleb.textColor = DEFAULTCOLOR;
        [itemView addSubview:self.titleb];
        [self.titleb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageV.mas_bottom).offset(3);
            make.centerX.equalTo(itemView);
        }];
}

- (void)setImageIcon:(NSString *)imageIcon {
    _imageIcon = imageIcon;
    self.headImageV.image =  SDK_IMAGE(imageIcon);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleb.text = title;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    NSRange mackRange;
    if ( [self.imageIcon hasSuffix:@"normal"]) {
        mackRange =[self.imageIcon rangeOfString:@"normal"];
    }else{
        mackRange = [self.imageIcon rangeOfString:@"selected"];
     }
    NSString *imageName = [self.imageIcon stringByReplacingCharactersInRange:mackRange withString:!isSelect?@"normal":@"selected"];
    self.imageIcon = imageName;
    self.titleb.textColor = isSelect?HexColor(0xFF8500):HexColor(0x958575);
}

@end

@interface LTMeLeftView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, copy) NSArray *collectionArray;
@property (nonatomic, weak) id subViewDelegate;
@property (nonatomic, copy) void (^ChangeRootView)(NSInteger index);

@property (nonatomic, assign) NSInteger currentSelectItem;

@end

@implementation LTMeLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.collectionView registerClass:NSClassFromString(@"LeftViewCollectionViewCell") forCellWithReuseIdentifier:@"LeftViewCollectionViewCell"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *loyout = [[UICollectionViewFlowLayout alloc] init];
           loyout.estimatedItemSize = CGSizeMake(49, 75);
           loyout.minimumLineSpacing = 1.f;
           loyout.minimumInteritemSpacing = 5.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:loyout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentOffset = CGPointMake(0, 40);
        _collectionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
        _collectionView.backgroundColor = DEFAULTBGCOLOR;

    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LeftViewCollectionViewCell" forIndexPath:indexPath];
    cell.imageIcon = self.collectionArray[indexPath.item][@"image"];
    cell.title = self.collectionArray[indexPath.item][@"title"];
    
    if (indexPath.item == self.currentSelectItem) {
        cell.isSelect = YES;
    }else {
        cell.isSelect = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.currentSelectItem) {
        return;
    }
    self.currentSelectItem = indexPath.item;
    [self.collectionView reloadData];
    !self.ChangeRootView?:self.ChangeRootView(indexPath.item);
}


- (NSArray *)collectionArray {
    if (!_collectionArray) {
        UIView *bgview = [[UIView alloc] init];
        bgview.backgroundColor = UIColor.blueColor;
        _collectionArray = @[@{@"image":@"icon_gonggao_normal",@"title":@"公告"},@{@"isSelect":@NO ,@"image":@"icon_liwu_normal",@"title":@"礼包"},@{@"isSelect":@NO ,@"image":@"icon_chongzhi_normal",@"title":@"充值"},@{@"isSelect":@NO ,@"image":@"icon_wode_normal",@"title":@"我的"}];
    }
    return _collectionArray;
}


- (void)setSubViewDelegate:(id)subViewDelegate {
    _subViewDelegate = subViewDelegate;
}

@end

@interface LTMeCenterView ()<LTMeMainViewDelegate,NoticeSelectDelegate>

@property (nonatomic, strong) LTMeLeftView *leftView;
@property (nonatomic, strong) LTMeCustomNavigation *rightView;
@property (nonatomic, strong) LTMeMainView *mainView;
@property (nonatomic, weak) LTMeGiftBag *giftBagView;
@property (nonatomic, weak) LTNoticeView *noticeView;
@property (nonatomic, weak) LTRechargeView *rechargeView;
@end

@implementation LTMeCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
//        self.layer.cornerRadius = 5;
//        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    self.backgroundColor = MECHENTERBGCOLOR;
    //self.backgroundColor = DEFAULTBGCOLOR;
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(LTSDKScale(50)));
    }];
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = TEXTBorderCOLOR;
//    [self addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftView.mas_right);
//        make.bottom.top.equalTo(self.leftView);
//        make.width.equalTo(@1);
//    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right);
        make.top.equalTo(self.leftView);
        make.bottom.right.equalTo(self);
    }];
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:SDK_IMAGE(@"icon_wode_guanbi") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backViewAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightView.rightBar = btn;
}

#pragma mark LTMeMainViewDelegate首页代理
- (void)getServicesView {
    LTServicesView *serviceView = [[LTServicesView alloc] init];
    [self.rightView pushView:serviceView];
}

- (void)editPasswordView:(NSString *)account isBindPhone:(id)isBindPhone {
    LTEditPasswordView *editView = [[LTEditPasswordView alloc] init];
    editView.accountName = account;
    editView.viewType = [isBindPhone boolValue]?LTEditPasswordViewTypeBindPhone:LTEditPasswordViewTypeNoBindPhone;
    [self.rightView pushView:editView];
}

- (void)bindOrReplaceBindPhoneNo:(NSString *)phoneNo {
    LTBindPhoneView *bindPhoneView = [[LTBindPhoneView alloc] init];
    bindPhoneView.accountName = phoneNo;
    __weak typeof(self) weakSelf = self;
    bindPhoneView.bindPhoneSuccessBlock = ^{
        [weakSelf.mainView reloadData];
    };
    [self.rightView pushView:bindPhoneView];
}

- (void)getAuthRealNameInfoView {
    LTAutonymRealNameInfoView *realNameInfoView = [[LTAutonymRealNameInfoView alloc] init];
    [self.rightView pushView:realNameInfoView];
}

- (void)showAuthRealNameView:(id)isBindPhone {
    LTAutonymRealNameContentView *realnameView = [[LTAutonymRealNameContentView alloc] init];
    realnameView.navigationTitle = @"实名认证";
    //realnameView.isBindPhone = [isBindPhone boolValue];
    [self.rightView pushView:realnameView];
    __weak typeof (self) weakSelf = self;
    __weak typeof(LTAutonymRealNameContentView *)weakrealnameView = realnameView;
    realnameView.commitBtnBlock = ^(NSString * name, NSString * idCard) {
        [TipView showPreloader];
        [NetServers userAuthWithName:name ids:idCard CompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
            [TipView hidePreloader];
            __strong typeof (weakSelf) self = weakSelf;
            if (code) {
                [LTSDKUserModel shareManger].auth = @(YES);
                [LTSDKUserModel shareManger].idcard = infoDic[@"idcard"];
                [LTSDKUserModel shareManger].realname = infoDic[@"realname"];
                //[weakrealnameView releseTime];
                [weakrealnameView.navigationBar popView];
                [self.mainView reloadData];
            }else {
                [TipView toast:msg];
            }
        }];
    };
}

- (void)changeUserAcount {
    [self backViewAction];
    [[LTAViewManger manage] logoutWithCallBack:^(BOOL isSucess,NSString *message, NSDictionary *responseDic) {
        [[LTAViewManger manage] loginViewSuccessCallBack:LTAcountLoginBlock isAutoLogin:NO];
    }];
}
-(void)selectNoticeDetailWithModel:(NoticeModel *)model
{
    LTNoticeDetail *detail = [[LTNoticeDetail alloc]initWithModel:model];
    [self.rightView pushView:detail];
}
- (void)backViewAction {
    !self.quitActionBlock?:self.quitActionBlock();
}


- (LTMeLeftView *)leftView {
    if (!_leftView) {
        _leftView = [[LTMeLeftView alloc] init];
        _leftView.subViewDelegate = self;
        __weak typeof(self) weakSelf = self;
        _leftView.ChangeRootView = ^(NSInteger index) {
            __strong typeof(weakSelf) self = weakSelf;
            if (index == 3) {
                [self.rightView setRootView:self.mainView];
            }else if (index == 1) {
                [self.rightView setRootView:self.giftBagView];
            }else if (index == 0) {
                [self.rightView setRootView:self.noticeView];
            }else if (index == 2) {
                [self.rightView setRootView:self.rechargeView];
            }
        };
    }
    return _leftView;
}

- (LTMeCustomNavigation *)rightView {
    if (!_rightView) {
        _rightView = [[LTMeCustomNavigation alloc] initWithRootView:self.noticeView];
    }
    return _rightView;
}

- (LTMeMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LTMeMainView alloc] init];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (LTMeGiftBag *)giftBagView {
    if (!_giftBagView) {
        _giftBagView = [[LTMeGiftBag alloc] init];
    }
    return _giftBagView;;
}
- (LTNoticeView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[LTNoticeView alloc] init];
        _noticeView.delegate = self;
        
    }
    return _noticeView;;
}
- (LTRechargeView *)rechargeView {
    if (!_rechargeView) {
        _rechargeView = [[LTRechargeView alloc] init];
    }
    return _rechargeView;;
}

@end

