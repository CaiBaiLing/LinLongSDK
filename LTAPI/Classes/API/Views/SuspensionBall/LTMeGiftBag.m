//
//  LTMeGiftBag.m
//  AFNetworking
//
//  Created by 徐广江 on 2020/6/17.
//

#import "LTMeGiftBag.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import "ToolsHelper.h"
#import "NetServers.h"
#import "DataManager.h"
#import "LTBindPhoneView.h"

@interface GiftModel : NSObject

@property(nonatomic, copy) NSString  *giftId;/**<应用ID*/
@property(nonatomic, copy) NSString  *name;/**<礼包名称*/
@property(nonatomic, copy) NSString  *intro;/**<简介*/
@property(nonatomic, copy) NSString  *term;/**兑换期限*/
@property(nonatomic, copy) NSString  *content;/**<内容描述*/
@property(nonatomic, copy) NSString  *instr;/**<使用方法*/
@property(nonatomic, copy) NSString  *type;/**<礼包类型 0:通码礼包 1:唯一码礼包*/
@property(nonatomic, copy) NSString  *is_get;/**<1已领取，0未领取*/

@end

@implementation GiftModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.giftId = value;
    }
}

@end

@interface GiftUserModel : NSObject

@property(nonatomic, copy) NSString  *app_id;/**<应用ID*/
@property(nonatomic, copy) NSString  *app_name;/**<应用名称*/
@property(nonatomic, copy) NSString  *app_icon;/**<应用图标*/
@property(nonatomic, copy) NSString  *gift_name;/**礼包名称*/
@property(nonatomic, copy) NSString  *gift_term;/**<兑换期限*/
@property(nonatomic, copy) NSString  *gift_type;/**<0:通码礼包 1:唯一码礼包*/
@property(nonatomic, copy) NSString  *gift_code;/**<礼包码*/
@property(nonatomic, copy) NSString  *gift_intro;/**<内容描述*/
@property(nonatomic, copy) NSString  *gift_content;/**<内容描述*/
@end

@implementation GiftUserModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

@end

@interface LTMeGiftBagCell : UITableViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *itemTitle;
@property (nonatomic, strong) UILabel *itemContent;
@property (nonatomic, strong) UILabel *gitTime;
@property (nonatomic, strong) UIButton *obtainBtn;
@property (nonatomic, strong) NSString *giftType;
@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) void(^buttonClickActionBlock)(void);

@end

@implementation LTMeGiftBagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.bgView = [[UIView alloc] init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgView];
    //bgView.backgroundColor = HexAlphaColor(0xFFFFFF, 0);;
    self.backgroundColor =  HexAlphaColor(0xFFFFFF, 0);
    self.contentView.backgroundColor = HexAlphaColor(0xFFFFFF, 0);
    [self.bgView addSubview:self.itemTitle];
    [self.bgView addSubview:self.itemContent];
    [self.bgView addSubview:self.gitTime];
    [self.bgView addSubview:self.obtainBtn];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [self.itemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.itemContent.mas_top).offset(-5);
        make.left.equalTo(self.itemContent);
    }];
    [self.itemContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.obtainBtn.mas_left);
        
    }];
    [self.gitTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemContent.mas_bottom).offset(10);
        make.left.equalTo(self.itemContent);
    }];
    [self.obtainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(68, 33));
    }];
}

- (UILabel *)itemTitle {
    if (!_itemTitle) {
        _itemTitle = [[UILabel alloc] init];
        _itemTitle.font = LTSDKFont(15);
        _itemTitle.textColor = HexColor(0xFFFFFF);
    }
    return _itemTitle;
}

- (UILabel *)itemContent {
    if (!_itemContent) {
        _itemContent = [[UILabel alloc] init];
        _itemContent.font = LTSDKFont(10);
        _itemContent.textColor = HexColor(0xFFFFFF);
    }
    return _itemContent;
}

- (UILabel *)gitTime {
    if (!_gitTime) {
        _gitTime = [[UILabel alloc] init];
        _gitTime.font = LTSDKFont(10);
        _gitTime.textColor = HexColor(0xFFFFFF);
    }
    return _gitTime;
}

- (UIButton *)obtainBtn {
    if (!_obtainBtn) {
        _obtainBtn = [[UIButton alloc] init];
        [_obtainBtn addTarget:self action:@selector(obtainBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _obtainBtn;
}

- (void)setState:(NSString *)state {
    _state = state;

}

- (void)setGiftType:(NSString *)giftType {
    _giftType = giftType;
    if (![self.state isEqualToString:@"1"]) {
        self.bgView.layer.contents = [giftType intValue]?(id)SDK_IMAGE(@"bg_lipin_lan").CGImage:(id)SDK_IMAGE(@"bg_lipin_ju").CGImage;
        NSString *imageString = [NSString stringWithFormat:@"%@%@",[self.state isEqualToString:@"0"]?@"button_lingqu_":@"button_fuzhi_",[giftType intValue]?@"lan":@"ju"];
        [self.obtainBtn setBackgroundImage:SDK_IMAGE(imageString) forState:UIControlStateNormal];
        self.obtainBtn.enabled = YES;
    }else {
        self.bgView.layer.contents = [giftType intValue]?(id)SDK_IMAGE(@"bg_lipin_hui_v").CGImage:(id)SDK_IMAGE(@"bg_lipin_hui_n").CGImage;
        [self.obtainBtn setBackgroundImage:SDK_IMAGE(@"button_yilingqu") forState:UIControlStateNormal];
        self.obtainBtn.enabled = NO;
    }
}

- (void)obtainBtnAction {
    !self.buttonClickActionBlock?:self.buttonClickActionBlock();
}

@end

@interface LTMeGiftBagContetnView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *giftBag;
@property (nonatomic, copy) NSMutableArray *dateArray;
@property (nonatomic, copy) void(^buttonClickActionBlock)(NSInteger index);
@property (nonatomic, copy) void(^loadMoreDataBlock)();
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, strong) UIRefreshControl *refrshControler;

@end

@implementation LTMeGiftBagContetnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.giftBag];
    [self.giftBag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(LTSDKScale(170), LTSDKScale(120)));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.dateArray[indexPath.row];
    LTMeGiftBagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTMeGiftBagCell" forIndexPath:indexPath];
    cell.itemTitle.text = data[@"title"];
    cell.itemContent.text = data[@"subTitle"];
    cell.gitTime.text = [NSString stringWithFormat:@"有效期至:%@" ,data[@"time"]];
    cell.state = data[@"state"];
    cell.giftType = data[@"gift_type"];
    __weak typeof(self) weakSelf = self;
    cell.buttonClickActionBlock = ^{
        __strong typeof(weakSelf) self = weakSelf;
        !self.buttonClickActionBlock?:self.buttonClickActionBlock(indexPath.row);
    };
    
    return cell;
}


- (UITableView *)giftBag {
    if (!_giftBag) {
        _giftBag = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_giftBag registerClass:NSClassFromString(@"LTMeGiftBagCell") forCellReuseIdentifier:@"LTMeGiftBagCell"];
        _giftBag.delegate = self;
        _giftBag.dataSource = self;
        _giftBag.rowHeight = 120;
        _giftBag.separatorStyle = UITableViewCellSeparatorStyleNone;
        _giftBag.backgroundColor = HexAlphaColor(0xFFFFFF, 0);
    }
    return _giftBag;
}

- (void)setDateArray:(NSMutableArray *)dateArray {
    _dateArray = dateArray;
    self.emptyView.hidden = dateArray.count<=0?NO:YES;
    [self.giftBag reloadData];
}

- (void)setRefrshControler:(UIRefreshControl *)refrshControler {
    _refrshControler = refrshControler;
    self.giftBag.refreshControl = refrshControler;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.layer.contents = (id)SDK_IMAGE(@"bg_kongbai").CGImage;
    }
    return _emptyView;
}

- (void)setIsLoadMore:(BOOL)isLoadMore {
    _isLoadMore = isLoadMore;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffsetY = scrollView.contentOffset.y;
      /*self.refreshControl.isRefreshing == NO加这个条件是为了防止下面的情况发生：
      每次进入UITableView，表格都会沉降一段距离，这个时候就会导致currentOffsetY + scrollView.frame.size.height   > scrollView.contentSize.height 被触发，从而触发loadMore方法，而不会触发refresh方法。
       */
    if ( currentOffsetY + scrollView.frame.size.height  > scrollView.contentSize.height +80 && !self.isLoadMore && !self.refrshControler.isRefreshing){
        [self loadMoreData];
    }
      BigLog(@"%@ ---%f----%f",NSStringFromCGRect(scrollView.frame),currentOffsetY,scrollView.contentSize.height);
}

- (void)loadMoreData{
    !self.loadMoreDataBlock?:self.loadMoreDataBlock();
}

@end

@interface LTMeGiftBag ()

@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) LTMeGiftBagContetnView *contentView;
@property (nonatomic, strong) NSMutableArray <GiftModel *>*segmentArray;
@property (nonatomic, strong) NSMutableArray <GiftUserModel *> *segmentArray1;
@property(nonatomic, assign) NSInteger segmentpage2;/**<已领取页码*/
@property (nonatomic, strong) UIRefreshControl *refrshControler;
@property (nonatomic, strong) UILabel *noMoreTips;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, assign) BOOL isNoMore;

@end

@implementation LTMeGiftBag

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.navigationTitle = @"我的";
        [self initUI];
        [self initData];
    }
    return self;
}

- (void)initData {
    [self getGiftListData];
    [self getGiftUseListData];
}

- (void)getGiftListData {
    self.segmentArray = [NSMutableArray array];
    [NetServers getUserInfoGiftList:1 completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [self.refrshControler endRefreshing];
         if (code) {
             NSArray *arr = infoDic[@"gift_list"];
             [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 GiftModel *model = [[GiftModel alloc] init];
                 [model setValuesForKeysWithDictionary:obj];
                 if ([model.is_get isEqualToString:@"0"]) {
                     [self.segmentArray addObject:model];
                 }
                 
             }];
             [self changeViewType:self.segment];
         }
     }];
}

- (void) getGiftUseListData {
    self.isNoMore = NO;
    self.segmentpage2 = 1;
    self.segmentArray1 = [NSMutableArray array];
    [NetServers getUserInfoGiftUseList:self.segmentpage2 completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        [self.refrshControler endRefreshing];
        if (code) {
           NSArray *arr = infoDic[@"list"];
           [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               GiftUserModel *model = [[GiftUserModel alloc] init];
               [model setValuesForKeysWithDictionary:obj];
               [self.segmentArray1 addObject:model];
           }];
           [self changeViewType:self.segment];
        }else{
            [TipView toast:msg];
        }
    }];
}

- (void)initUI {
    [self addSubview:self.segment];
    [self addSubview:self.contentView];
    [self addSubview:self.noMoreTips];
    [self addSubview:self.bottomLabel];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(190, 30));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.noMoreTips.mas_top);
    }];
    [self.noMoreTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.bottomLabel);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
    }];
}

- (void)setIsNoMore:(BOOL)isNoMore {
    _isNoMore = isNoMore;
    self.noMoreTips.text =isNoMore?@"—————— 没有更多了 ——————":nil;

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

- (UILabel *)noMoreTips {
    if (!_noMoreTips) {
        _noMoreTips = [[UILabel alloc] init];
        _noMoreTips.font = LTSDKFont(10);
        _noMoreTips.textColor = HexColor(0x999999);
    }
    return _noMoreTips;
}

- (LTMeGiftBagContetnView *)contentView {
    if (!_contentView) {
        _contentView = [[LTMeGiftBagContetnView alloc] init];
        _contentView.refrshControler = self.refrshControler;
        _contentView.dateArray = self.segmentArray;
        __weak typeof(self) weakSelf = self;
        _contentView.buttonClickActionBlock = ^(NSInteger index) {
            __strong typeof(weakSelf) self = weakSelf;
            if (self.segment.selectedSegmentIndex) {
                GiftUserModel *model = self.segmentArray1[index];
                [ToolsHelper saveToPasteBoard:model.gift_code];
                [TipView toast:@"礼包码复制成功"];
            }else {
                GiftModel *model = self.segmentArray[index];
                 if ([model.is_get isEqualToString:@"0"]) {
//                     && [DataManager sharedDataManager].uiConfigModel.isBindPhoneAuth != LTBindPhoneTypeNO
                     if ([LTSDKUserModel shareManger].mobile.length <= 0 ) {
                            [LTPopBindPhoneView showBindPhoneViewIsJump:YES isAphal:NO bindSucess:^{
                                [self getGiftWithModel:model];
                            }];
                              return;
                     }
                     [self getGiftWithModel:model];
                 }
            }
        };
        _contentView.loadMoreDataBlock = ^{
            __strong typeof(weakSelf) self = weakSelf;
            if (self.segment.selectedSegmentIndex) {
                [self addMore];
            }
        };
    }
    return _contentView;
}

- (void)getGiftWithModel:(GiftModel *)model {
    [NetServers getUserInfoGetGift:model.giftId completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
      if (code) {
           [TipView toast:@"  领取成功！请到已领取菜单复制礼包码   "];
         [self initData];
      }else{
          [TipView toast:msg];
      }
   }];
}

- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"可领取",@"已领取"]];
        [_segment setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segment setBackgroundImage:[UIImage new]  forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [_segment setSelectedSegmentIndex:0];
        [_segment addTarget:self action:@selector(changeViewType:) forControlEvents:UIControlEventValueChanged];
        [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:HexColor(0x666666),NSFontAttributeName:LTSDKFont(15)} forState:UIControlStateNormal];
        [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:HexColor(0x333333),NSFontAttributeName:LTSDKFont(18)} forState:UIControlStateSelected];
    }
    return _segment;
}

- (UIRefreshControl *)refrshControler {
    if (!_refrshControler) {
        _refrshControler = [[UIRefreshControl alloc] init];
        _refrshControler.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新" attributes:@{NSFontAttributeName:LTSDKFont(14),NSForegroundColorAttributeName:HexColor(0xFF5800)}];
        [_refrshControler addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    }
    return _refrshControler;
}

- (void)refreshData {
    if (self.segment.selectedSegmentIndex) {
        [self getGiftUseListData];
    }else {
        [self getGiftListData];
    }
}

- (void)addMore {
    if (self.segment.selectedSegmentIndex) {
        if (self.isNoMore) {
            return;
        }
        self.contentView.isLoadMore = YES;
        self.segmentpage2++;
        [NetServers getUserInfoGiftUseList:self.segmentpage2 completedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
            if (code) {
               NSArray *arr = infoDic[@"list"];
                if (arr.count >0) {
                    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         GiftUserModel *model = [[GiftUserModel alloc] init];
                         [model setValuesForKeysWithDictionary:obj];
                         [self.segmentArray1 addObject:model];
                     }];
                     [self changeViewType:self.segment];
                }else {
                    self.isNoMore = YES;
                }
            }
            self.contentView.isLoadMore = NO;
        }];
    }
}

- (void)changeViewType:(UISegmentedControl *)controler {
    NSMutableArray *dataArrays = [NSMutableArray array];
    [self.refrshControler endRefreshing];
    if (controler.selectedSegmentIndex) {
        [self.segmentArray1 enumerateObjectsUsingBlock:^(GiftUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //title  标题  subTitle 内容  time 创建时间    gift_type 礼包类型   state 礼包状态（0,未领取，1 已领取  2 复制）
            NSDictionary *dic = @{@"title":obj.gift_name?:@"",@"subTitle":obj.gift_content?:@"",@"time":obj.gift_term?:@"",@"gift_type":obj.gift_type?:@"",@"state":@"2"};
            [dataArrays addObject:dic];
        }];
    }else {
        //title  标题  subTitle 内容  time 创建时间    gift_type 礼包类型   state 礼包状态（0,未领取，1 已领取  2 复制）
        [self.segmentArray enumerateObjectsUsingBlock:^(GiftModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{@"title":obj.name?:@"",@"subTitle":obj.content?:@"",@"time":obj.term?:@"",@"gift_type":obj.type?:@"",@"state":obj.is_get?:@""};
            [dataArrays addObject:dic];
        }];
    }
    self.noMoreTips.text =  controler.selectedSegmentIndex?self.isNoMore?@"—————— 没有更多了 ——————":nil:@"—————— 没有更多了 ——————";
    self.contentView.dateArray = dataArrays;
}

@end
