//
//  LTNoticeDetail.m
//  LTAPI
//
//  Created by 徐广江 on 2020/11/20.
//

#import "LTNoticeDetail.h"
#import "PrefixHeader.h"
#import "NoticeModel.h"
#import <WebKit/WebKit.h>
@interface LTNoticeDetail()
{
//    UILabel *_titleLab;
    WKWebView *_wkWeb;
}

@end

@implementation LTNoticeDetail


-(instancetype)initWithModel:(NoticeModel *)model
{
    self = [super init];
    if (self) {
        self.navigationTitle = model.title;
        [self loadUIWithModel:model];
    }
    return self;
}

-(void)loadUIWithModel:(NoticeModel *)model
{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *timeL = [[UILabel alloc]init];
    timeL.text = model.publish_time;
    timeL.textColor = TEXTDEFAULTCOLOR;
    timeL.textAlignment = NSTextAlignmentCenter;
    timeL.font = LTSDKFont(12);
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.equalTo(@15);
    }];
    
    _wkWeb = [[WKWebView alloc]init];
    _wkWeb.opaque = NO;
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    [_wkWeb loadHTMLString:[headerString stringByAppendingString:model.content] baseURL:nil];
    [self addSubview:_wkWeb];
    [_wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.equalTo(timeL.mas_bottom);
        make.right.offset(-16);
        make.bottom.offset(-20);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
