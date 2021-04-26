//
//  LTAHomeLoginViewController.h
//  LTAPI
//
//  Created by zuzu360 on 2019/12/25.
//  Copyright © 2019 LTSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSDK.h"
NS_ASSUME_NONNULL_BEGIN

@interface LTAHomeLoginViewController : UIViewController

@property (nonatomic, copy) LTRequestResult loginCallBack;
@property (nonatomic, assign) BOOL isAutoLogin;//是否自动登录

@end

NS_ASSUME_NONNULL_END
