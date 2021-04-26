//
//  LTSuspensionBall.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/7.
//

#import <UIKit/UIKit.h>
#import "LTSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTSuspensionBall : UIView

///显示悬浮球
+ (void)showSuspensionBall:(LTRequestResult)receiverBlock;

///隐藏悬浮球
+ (void)hidenSuspensionBall;

@end

NS_ASSUME_NONNULL_END
