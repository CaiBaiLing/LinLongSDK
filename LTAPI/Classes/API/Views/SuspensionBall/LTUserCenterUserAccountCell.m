//
//  LTUserCenterUserAccountCell.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/7.
//

#import "LTUserCenterUserAccountCell.h"
#import "PrefixHeader.h"
#import "Masonry.h"

@interface LTUserCenterUserAccountCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *changeAccountBtn;
@property (nonatomic, copy) void(^buttonActionBlock) (void);

@end


@implementation LTUserCenterUserAccountCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.contentView.backgroundColor = HexAlphaColor(0xFFFFFF, 0.0);
     self.backgroundColor = HexAlphaColor(0xFFFFFF, 0.0);
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.changeAccountBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        make.left.equalTo(self.contentView).offset(20);
    }];
    [self.changeAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(2);
        make.left.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(95, 24));
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)setAccontName:(NSString *)accontName headImage:(NSString *)headImage chenageAccountBlock:(void (^)(void))changAccontBlock {
    self.titleLabel.text = accontName;
    self.headImageView.image = headImage?SDK_IMAGE(headImage):SDK_IMAGE(@"ballPic");
    self.buttonActionBlock = changAccontBlock;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = LTSDKFont(18);
        _titleLabel.textColor = HexColor(0x333333);
    }
    return _titleLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithImage:SDK_IMAGE(@"ballPic")];
    }
    return _headImageView;
}


- (UIButton *)changeAccountBtn {
    if (!_changeAccountBtn) {
        _changeAccountBtn = [[UIButton alloc] init];
        [_changeAccountBtn setImage:SDK_IMAGE(@"icon_wode_qiehuan") forState:UIControlStateNormal];
        _changeAccountBtn.titleLabel.font =LTSDKFont(13);
        [_changeAccountBtn setTitle:@" 切换账号" forState:UIControlStateNormal];
        [_changeAccountBtn setTitleColor:HexColor(0x978575) forState:UIControlStateNormal];
        _changeAccountBtn.layer.cornerRadius = 12;
        _changeAccountBtn.layer.masksToBounds = YES;
        _changeAccountBtn.backgroundColor = HexColor(0xEDE0CE);
        [ToolsHelper getCurrentColorWithLightColor:UIColor.whiteColor darkColor:HexColor(0xEDE0CE)];
        [_changeAccountBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeAccountBtn;
}

- (void)btnAction:(UIButton *)btn {
    !self.buttonActionBlock?:self.buttonActionBlock();
}

@end
