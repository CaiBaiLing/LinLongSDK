//
//  LTUserCenterSelectItemCell.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/7.
//

#import "LTUserCenterSelectItemCell.h"
#import "PrefixHeader.h"
#import "Masonry.h"

@interface LTUserCenterSelectItemCell ()



@end

@implementation LTUserCenterSelectItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseUI];
    }
    return self;
}

- (void)initBaseUI {
    self.contentView.backgroundColor =  HexAlphaColor(0xFFFFFF, 0.0);
    self.backgroundColor = HexAlphaColor(0xFFFFFF, 0.0);
    
    [self.contentView addSubview:self.iconImageV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.accountLabel];
    [self.iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(4, 7));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageV.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIImageView *)iconImageV {
    if (!_iconImageV) {
        _iconImageV = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"icon_wode_more")];
    }
    return _iconImageV;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = LTSDKFont(15);
        _titleLabel.textColor = HexColor(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.font = LTSDKFont(12);
    }
    return _accountLabel;
}

@end
