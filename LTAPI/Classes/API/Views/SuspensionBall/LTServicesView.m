//
//  LTServicesView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/17.
//

#import "LTServicesView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import "NetServers.h"

@implementation LTServicesViewItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
//    [self addSubview:self.serverIconV];
    [self addSubview:self.serverTitleLB];
    [self addSubview:self.serverTitleValueLB];
//    [self.serverIconV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.top.equalTo(self).offset(20);
//    }];
    
    [self.serverTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    [self.serverTitleValueLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.serverTitleLB);
        make.left.equalTo(self.serverTitleLB.mas_right).offset(5);
    }];
}


- (UILabel *)serverTitleLB {
    if (!_serverTitleLB) {
        _serverTitleLB = [[UILabel alloc] init];
    }
    return _serverTitleLB;
}

- (UILabel *)serverTitleValueLB {
    if (!_serverTitleValueLB) {
        _serverTitleValueLB = [[UILabel alloc] init];
    }
    return _serverTitleValueLB;
}

@end


@interface LTServicesView ()


@property (nonatomic, strong) UIButton *copyButton;
@property (nonatomic, copy) NSString *qqString;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end


@implementation LTServicesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataArr = [NSMutableArray new];
        self.qqString = @"";
        [self getData];
        self.navigationTitle = @"联系客服";
    }
    return self;
}

- (void)getData {
    [NetServers getSystemServiceCompletedHandler:^(NSInteger code, NSInteger debug, NSDictionary *infoDic, NSString *msg) {
        if (code) {
            dispatch_async(dispatch_get_main_queue(), ^{

                NSString *wStr = infoDic[@"qq"];
                NSString *eStr = infoDic[@"email"];
                NSString *mStr = infoDic[@"tel"];
                NSString *qStr = infoDic[@"qq_group"];
                NSString *tStr = infoDic[@"time"];

                if(![wStr isEqual:[NSNull null]]&&wStr.length>1){
                    self.qqString = wStr;
                    [self.dataArr addObject:@{@"qq":wStr}];
                }
                if(![eStr isEqual:[NSNull null]]&&eStr.length>1){
                    [self.dataArr addObject:@{@"email":eStr}];
                }
                if(![mStr isEqual:[NSNull null]]&&mStr.length>1){
                    [self.dataArr addObject:@{@"tel":mStr}];
                }
                if(![qStr isEqual:[NSNull null]]&&qStr.length>1){
                    [self.dataArr addObject:@{@"qq_group":qStr}];
                }
                if(![tStr isEqual:[NSNull null]]&&tStr.length>1){
                    [self.dataArr addObject:@{@"time":tStr}];
                }
                [self autoInitUI];
            });
        }
    }];
}
-(void)autoInitUI
{
    for (int i = 0; i < self.dataArr.count; i++) {
        LTServicesViewItem *item = [[LTServicesViewItem alloc] init];
        item.serverTitleLB.font = LTSDKFont(14);
        item.serverTitleLB.textColor = TEXTNOMARLCOLOR;
        NSDictionary *dic = self.dataArr[i];
        item.serverTitleLB.text = [self setTitleStrWithKey:[dic.allKeys firstObject] ];
        item.serverTitleValueLB.text =[dic.allValues firstObject];
        item.serverTitleValueLB.font = [UIFont systemFontOfSize:14];
        item.serverTitleValueLB.textColor = TEXTNOMARLCOLOR;
        [self addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(@(20+i*(20+40)));
            make.height.equalTo(@40);
        }];
        
        
        if ([item.serverTitleLB.text isEqualToString:@"微信公众号："]) {
            [self addSubview:self.copyButton];
            [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(item.serverTitleValueLB.mas_right).offset(15);
                make.centerY.equalTo(item);
                make.size.mas_equalTo(CGSizeMake(50, 25));
            }];
        }
    }
    
}
-(NSString *)setTitleStrWithKey:(NSString *)key
{
    NSString *titleStr;
    if ([key isEqualToString:@"qq"]) {
        titleStr = @"微信公众号：";
    }
    if ([key isEqualToString:@"email"]) {
        titleStr = @"电子邮件：";
    }
    if ([key isEqualToString:@"tel"]) {
        titleStr = @"联系电话：";
    }
    if ([key isEqualToString:@"qq_group"]) {
        titleStr = @"QQ群：";
    }
    if ([key isEqualToString:@"time"]) {
        titleStr = @"工作时间：";
    }
    return titleStr;
}


- (void)copyButtonAction {
    if (self.qqString.length <=0) {
        return;
    }
    [ToolsHelper saveToPasteBoard:self.qqString];
    [TipView toast:@"复制成功"];
}


- (UIButton *)copyButton {
    if (!_copyButton) {
        _copyButton = [UIButton new];
        [_copyButton setImage:SDK_IMAGE(@"button_fuzhi") forState:UIControlStateNormal];
        [_copyButton addTarget:self action:@selector(copyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyButton;
}

@end
