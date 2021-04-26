//
//  ActivityAlertView.m
//  AFNetworking
//
//  Created by 徐广江 on 2020/11/19.
//

#import "ActivityAlertView.h"
#import "Masonry.h"
#import "NetServers.h"
#import "TipView.h"
#import "NoticeModel.h"
#import "PrefixHeader.h"
#import <WebKit/WebKit.h>

@interface ActivityAlertView()
{
    NSMutableArray *_dataArr;
    UIButton *_selectBtn;
    UILabel *_titleLab;
    WKWebView *_wkWeb;
}
@end

@implementation ActivityAlertView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}
-(void)initData
{
    _dataArr = [[NSMutableArray alloc]init];
    [TipView showPreloader];
    [NetServers getActivityListWithCompletedHandler:^(NSInteger code, NSInteger debug, NSArray *infoArr, NSString *msg) {
        [TipView hidePreloader];
        if (code == 1) {
            if (infoArr.count>0) {
                NSArray *arr = [NSArray arrayWithArray:infoArr];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx<5) {
                        NoticeModel *model = [[NoticeModel alloc]initWithDic:arr[idx]];
                        [self->_dataArr addObject:model];
                    }
                    
                }];
                [self loadUI];
            }else{
                [self closeViewClick];
                
            }
            
        }else{
            [TipView toast:msg supView:nil];
        }
    }];
    
    
}

-(void)loadUI
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UIView *activityView =  [[UIView alloc] init];
    activityView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [bgView addSubview:activityView];
    activityView.layer.cornerRadius = 20;
    activityView.layer.masksToBounds = YES;
    activityView.userInteractionEnabled = YES;
    CGFloat btnHeight;
    if (IsPortrait) {
           //竖屏
        [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.offset(0);
            make.right.offset(0);
            make.top.offset(160);
        }];
        btnHeight = 88;
    }else{
        [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.offset(0);
            make.right.offset(-200);
        }];
        btnHeight = 375/_dataArr.count;
    }
    
    UIView *leftBgV = [UIView new];
    leftBgV.backgroundColor = [UIColor whiteColor];
    [activityView addSubview:leftBgV];
    [leftBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(activityView);
        make.width.equalTo(@66);
    }];
    
    for (int i = 0; i<_dataArr.count; i++) {
        NoticeModel *model = _dataArr[i];
        UIButton *leftBtn = [UIButton new];
        [leftBtn addTarget:self action:@selector(noticeClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftBgV addSubview:leftBtn];
        leftBtn.titleLabel.font =LTSDKFont(12);
        leftBtn.titleLabel.numberOfLines = 0;
        leftBtn.tag = i;
        leftBtn.backgroundColor = [UIColor whiteColor];
        [leftBtn setTitle:model.title forState:(UIControlStateNormal)];
        [leftBtn setTitleColor:TEXTNOMARLCOLOR forState:UIControlStateNormal];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.width.equalTo(@66);
            make.height.equalTo(@(btnHeight));
            make.top.offset(i*btnHeight);
        }];
        if (i == 0) {
            leftBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1.0];;
            [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _selectBtn = leftBtn;
        }
        
    }
    
    NoticeModel *model = _dataArr[0];
    _titleLab = [[UILabel alloc]init];
    _titleLab.text =model.title;
    _titleLab.textColor =TEXTNOMARLCOLOR;
    _titleLab.font = [UIFont systemFontOfSize:18 weight:1];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [activityView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectBtn.mas_right);
        make.top.offset(10);
        make.right.offset(-40);
        make.height.equalTo(@25);
    }];
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setImage:SDK_IMAGE(@"icon_wode_guanbi") forState:(UIControlStateNormal)];
    [activityView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeViewClick) forControlEvents:(UIControlEventTouchUpInside)];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.right.offset(-15);
        make.width.height.equalTo(@16);
    }];
    
    _wkWeb = [[WKWebView alloc]init];
    _wkWeb.opaque = NO;
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    [_wkWeb loadHTMLString:[headerString stringByAppendingString:model.content] baseURL:nil];
    [activityView addSubview:_wkWeb];
    [_wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBgV.mas_right).offset(0);
        make.top.equalTo(_titleLab.mas_bottom).offset(25);
        make.right.offset(0);
        make.bottom.offset(-40);
    }];
    
    UIButton *todaySelectBtn = [[UIButton alloc]init];
    [todaySelectBtn setImage:SDK_IMAGE(@"today_show_normal") forState:(UIControlStateNormal)];
    [todaySelectBtn setImage:SDK_IMAGE(@"today_show_selected") forState:(UIControlStateSelected)];
    [activityView addSubview:todaySelectBtn];
    [todaySelectBtn addTarget:self action:@selector(todayClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [todaySelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-18);
        make.centerX.offset(-20);
        make.width.height.equalTo(@13);
    }];
    UILabel *textLab = [UILabel new];
    textLab.text = @"今日不再提醒";
    textLab.textColor = TEXTNOMARLCOLOR;
    textLab.font = LTSDKFont(12);
    [activityView addSubview:textLab];
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(todaySelectBtn);
        make.left.equalTo(todaySelectBtn.mas_right).offset(8);
        make.width.equalTo(@90);
        make.height.equalTo(@17);
    }];
    
}

-(void)noticeClick:(UIButton *)sender
{
    NoticeModel *model = _dataArr[sender.tag];
    _titleLab.text = model.title;
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    [_wkWeb loadHTMLString:[headerString stringByAppendingString:model.content] baseURL:nil];
    sender.selected = !sender.selected;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor =[UIColor colorWithRed:255/255.0 green:133/255.0 blue:0/255.0 alpha:1.0];
    _selectBtn.backgroundColor = [UIColor whiteColor];
    [_selectBtn setTitleColor:TEXTNOMARLCOLOR forState:UIControlStateNormal];
    _selectBtn = sender;
}
-(void)todayClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *str = [formatter stringFromDate:date];
    
    if (sender.selected) {
        
        [[NSUserDefaults standardUserDefaults]setValue:str forKey:@"isTodayHiddenNotice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isTodayHiddenNotice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
}
+ (void)showAlertViewWithagreeBlock:(void (^)(void))agreeBlock readPrivacyPolicyBlock:(void(^)(void))readPrivacyPolicyBlock readProtocolBlock:(void(^)(void))readProtocolBlock {
    UIView *sView = [[UIApplication sharedApplication].keyWindow viewWithTag:1111];
    if (sView && [sView isKindOfClass:[ActivityAlertView class]]) {
        return;
    }
    ActivityAlertView *accountsSelectV = [[ActivityAlertView alloc] init];
    accountsSelectV.tag = 1111;
//    accountsSelectV.agreeBlock = ^{
//        !agreeBlock?:agreeBlock();
//    };
//    accountsSelectV.privacyBlock = ^{
//        !readPrivacyPolicyBlock?:readPrivacyPolicyBlock();
//    };
//    accountsSelectV.protocolBlock = ^{
//        !readProtocolBlock?:readProtocolBlock();
//    };
//    NSString *deviceStr = [DeviceHelper getDeviceType];
    float left = 0;
    if (IphoneX) {
        left = LTSDKScale(30);
    }
    
    UIView *superView = [UIApplication sharedApplication].keyWindow ;
    [superView insertSubview:accountsSelectV atIndex:9999];
    [accountsSelectV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(superView);
        make.top.width.height.equalTo(superView);
        make.left.equalTo(@( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait? 0:left));
    }];
}
-(void)closeViewClick
{
    UIView *successView = [[UIApplication sharedApplication].keyWindow viewWithTag:1111];
    if (successView && [successView isKindOfClass:[ActivityAlertView class]]) {
        [successView removeFromSuperview];
        successView = nil;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
