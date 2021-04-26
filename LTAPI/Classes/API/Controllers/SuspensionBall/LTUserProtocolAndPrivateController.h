//
//  LTUserProtocolAndPrivateController.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/8.
//

#import "LTSDKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTUserProtocolAndPrivateController : LTSDKBaseViewController

@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *localURL;
@property (nonatomic, assign) BOOL isHidenTitle;

@end

NS_ASSUME_NONNULL_END
