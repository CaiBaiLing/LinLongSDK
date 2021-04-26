//
//  LTMeBaseView.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/16.
//

#import "LTMeBaseView.h"
#import "PrefixHeader.h"
#import "Masonry.h"
#import <objc/runtime.h>

static NSString *navigationTitleKey = @"navigationTitleKey";
static NSString *navigationBarKey = @"navigationBarKey";

@implementation UIView(LTMeCustomNavigation)

- (void)setNavigationTitle:(NSString *)navigationTitle {
    objc_setAssociatedObject(self, &navigationTitleKey, navigationTitle, OBJC_ASSOCIATION_COPY);
}

- (NSString *)navigationTitle {
    return objc_getAssociatedObject(self, &navigationTitleKey);
}

- (void)setNavigationBar:(LTMeCustomNavigation *)navigationBar {
    objc_setAssociatedObject(self, &navigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN);
}

- (LTMeCustomNavigation *)navigationBar {
    return objc_getAssociatedObject(self, &navigationBarKey);
}

@end

@interface LTMeCustomNavigation()

@property (nonatomic, strong) NSMutableArray <UIView *>*subViews;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *topTitle;
//@property (nonatomic, strong) UIView *line;

@end

@implementation LTMeCustomNavigation

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithRootView:(UIView *)rootView {
    LTMeCustomNavigation *na = [self init];
    na.rootView = rootView;
    na.navigationTitle = rootView.navigationTitle;
    return na;
}

- (void)initUI {
    self.subViews = [NSMutableArray array];
   // self.frame = CGRectMake(0, 0,LTSDKScale(325) ,LTSDKScale(375));
    self.topView = [[UIView alloc] init];
    //self.topView.backgroundColor = DEFAULTBGCOLOR;
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(55));
    }];
    self.titleView = [[UIView alloc] init];
    [self.topView addSubview:self.titleView];
    self.topTitle = [[UILabel alloc] init];
    self.topTitle.font = LTSDKFont(18);
    self.topTitle.numberOfLines = 0;
    self.topTitle.textAlignment = NSTextAlignmentCenter;
    self.topTitle.textColor = TEXTNOMARLCOLOR;
    [self.titleView addSubview:self.topTitle];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
//        make.size.equalTo(self.topTitle);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.equalTo(self.topView);
        
    }];
    
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.titleView);
        make.left.right.height.equalTo(self.titleView);
    }];

    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:SDK_IMAGE(@"icon_wode_back") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.hidden = YES;
    self.leftBar = leftBtn;
    [self.topView addSubview:self.leftBar];
    [self.leftBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(10);
    }];
//    self.line = [[UIView alloc] init];
//    self.line.backgroundColor = TEXTBorderCOLOR;
//    [self.topView addSubview:self.line];
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self.topView);
//        make.height.equalTo(@1);
//    }];
}

- (void)setRightBar:(UIView *)rightBar {
    if (self.rightBar.superview) {
        [self.rightBar removeFromSuperview];
    }
    _rightBar = rightBar;
    [self.topView addSubview:rightBar];
    [rightBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.centerY.equalTo(self.topView);
    }];
}

- (void)setRootView:(UIView *)rootView {
    [self.subViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.subViews removeAllObjects];
    self.leftBar.hidden = YES;
    _rootView = rootView;
    _rootView.hidden = NO;
    [self addSubview:rootView];
    [self.subViews addObject:rootView];
    rootView.navigationBar = self;
    self.navigationTitle = rootView.navigationTitle;
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)pushView:(LTMeBaseView *)view {
    UIView *lastView = self.subViews.lastObject;
    lastView.hidden = YES;
    [self.subViews addObject:view];
    if (self.subViews.count > 1) {
        self.leftBar.hidden = NO;
    }
    view.navigationBar = self;
    self.navigationTitle = view.navigationTitle;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    [self pushAnimation];
}

- (void)popView {
    if (self.subViews.count > 1) {
        UIView *popView = self.subViews.lastObject;
        [self.subViews removeLastObject];
        [popView removeFromSuperview];
        popView = nil;
        self.subViews.lastObject.hidden = NO;
    }
    if (self.subViews.count <=1 ) {
        self.leftBar.hidden = YES;
    }
  
    UIView *customView = self.subViews.lastObject;
    self.navigationTitle = customView.navigationTitle;
    [self popAnimation];
}

- (void)pushAnimation {
    
}

- (void)popAnimation {
    
}

- (void)setTitleView:(UIView *)titleView {
    if (self.topTitle.superview) {
        [self.topTitle removeFromSuperview];
    }
    _titleView = titleView;
}

- (void)setNavigationTitle:(NSString *)navigationTitle {
    self.topTitle.text = navigationTitle;
}

- (void)setIsHidenLine:(BOOL)isHidenLine {
    _isHidenLine = isHidenLine;
   // self.line.backgroundColor = isHidenLine?self.backgroundColor:TEXTBorderCOLOR;
}

@end

@interface LTMeBaseView ()

@end

@implementation LTMeBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HexAlphaColor(0xFFFFFF, 0.0);
    }
    return self;
}

- (void)dealloc {
    BigLog(@"-------dealloc-----%@",NSStringFromClass([self class]));
}

@end
