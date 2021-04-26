//
//  LTPayViewController.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPayViewController : UIViewController

@property (nonatomic, copy) NSDictionary *cakeDic;
@property (nonatomic, copy) void(^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
