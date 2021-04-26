//
//  LTSDKBaseViewController.m
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/9.
//

#import "LTSDKBaseViewController.h"
#import "PrefixHeader.h"

@interface LTSDKBaseViewController ()

@end

@implementation LTSDKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    //[leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:DEFAULTCOLOR forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:SDK_IMAGE(@"arrow-left") forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setImage:SDK_IMAGE(@"arrow-right") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)dismissController {
    !UserCenterDismissControllerBlock?:UserCenterDismissControllerBlock();
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)setDismissControllerBlock:(void (^)(void))dismissControllerBlock {
    _dismissControllerBlock = dismissControllerBlock;
    UserCenterDismissControllerBlock = dismissControllerBlock;
}
@end
