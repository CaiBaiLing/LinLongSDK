//
//  LTPayViewController.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/9.
//

#import "LTPayViewController.h"
#import "CakeView.h"
#import "Masonry.h"
#import "LTSuspensionBall.h"
#import "PrefixHeader.h"

@interface LTPayViewController ()

@property (nonatomic, strong) CakeView *cakeView;

@end

@implementation LTPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cakeView];
    NSArray *arr = self.cakeDic[@"payment"];
    if (!IsPortrait) {
        CGFloat height = 290+32*arr.count;
        if ([self.cakeDic[@"pay_fee"] floatValue] == 0.00) {
            height = 290;
        }
        if (height>LTAPI_DeviceHeight) {
            height = LTAPI_DeviceHeight;
        }
        
        //横屏
        [self.cakeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(LTSDKScale(149)));
            make.center.equalTo(self.view);
            make.right.equalTo(@(LTSDKScale(-149)));
            make.height.equalTo(@(LTSDKScale(height)));
//            make.top.bottom.offset(0);
        }];
    }else{
        //竖屏
        CGFloat height = 290+32*arr.count;
        if ([self.cakeDic[@"pay_fee"] floatValue] == 0.00) {
            height = 290;
        }
        //竖屏UI
        [self.cakeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@(LTSDKScale(48)));
            make.center.equalTo(self.view);
            make.right.equalTo(@(LTSDKScale(-48)));
            make.height.equalTo(@(LTSDKScale(height+10)));
        }];
        
    }
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissController) name:@"NOTI_CLOSE_CAKE_WINDOW" object:nil];
}

- (CakeView *)cakeView {
    if (!_cakeView) {
        _cakeView = [[CakeView alloc] initWithCakeView:self.cakeDic];
    }
    return _cakeView;
}

- (void)dismissController {
    !_dismissBlock?:_dismissBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration

{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        // 横屏
        [self isPortrait];
    } else {
        //竖屏
        [self isLandscape];
    }

}
-(void)isLandscape
{
    //竖屏UI
    [self.cakeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(LTSDKScale(48)));
        make.center.equalTo(self.view);
        make.right.equalTo(@(LTSDKScale(-48)));
        make.height.equalTo(@(LTSDKScale(500)));
    }];
}
-(void)isPortrait
{
    
    //横屏
    [self.cakeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(LTSDKScale(149)));
        make.center.equalTo(self.view);
        make.right.equalTo(@(LTSDKScale(-149)));
        make.height.equalTo(@(LTSDKScale(301)));
    }];
}
@end
