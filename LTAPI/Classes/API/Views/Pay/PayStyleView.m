//
//  PayStyleView.m
//  Pods
//
//  Created by Zaoym on 2020/9/15.
//

#import "PayStyleView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
@implementation PayStyleView
-(instancetype)init
{
    if (self == [super init]) {
        [self loadUI];
    }
    return self;
    
}
-(void)loadUI
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.leftImgView = [[UIImageView alloc]init];
    [self addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    
    self.payStyleLabel = [[UILabel alloc]init];
    self.payStyleLabel.text = self.payStyleNameStr;
    self.payStyleLabel.font = LTSDKFont(16);
    self.payStyleLabel.textColor = TEXTNOMARLCOLOR;
    [self addSubview:self.payStyleLabel];
    [self.payStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgView.mas_right).offset(8);
        make.centerY.height.equalTo(self.leftImgView);
        make.width.equalTo(@100);
    }];
    
    self.rightSelectedBtn = [[UIButton alloc]init];
    [self.rightSelectedBtn setImage:SDK_IMAGE(@"payUnselected") forState:(UIControlStateNormal)];
    [self.rightSelectedBtn setImage:SDK_IMAGE(@"paySelected") forState:(UIControlStateSelected)];
//    [self.rightSelectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.rightSelectedBtn];
    [self.rightSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.leftImgView);
        make.width.height.equalTo(@16);
    }];
    UIView *lineV= [[UIView alloc]init];
    lineV.backgroundColor= HexColor(0xF2F2F2);
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-1);
        make.height.equalTo(@1);
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
