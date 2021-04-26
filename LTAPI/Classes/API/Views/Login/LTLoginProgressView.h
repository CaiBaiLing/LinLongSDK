//
//  LTLoginProgressView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTLoginProgressView : UIView

+ (void)showLoginSuccessWithUserName:(NSString *)userName changeBtnBlock:(void(^)(void))changBlock hidenBlock:(void(^)(void))hidenBlock;

+ (void)hidenLoginSuccessView;

@end

NS_ASSUME_NONNULL_END
