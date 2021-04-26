//
//  LTSDKBaseViewController.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static void(^UserCenterDismissControllerBlock)(void);

@interface LTSDKBaseViewController : UIViewController

@property (nonatomic, copy) void(^dismissControllerBlock)(void);

@end

NS_ASSUME_NONNULL_END
