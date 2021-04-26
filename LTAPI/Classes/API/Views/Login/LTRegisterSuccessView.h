//
//  LTRegisterSuccessView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/6.
//

#import "LTABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTRegisterSuccessView : LTABaseView

- (void)setUserName:(NSString *)userName psd:(NSString *)psd loginBlock:(void(^)(void))loginBLock;

@end

NS_ASSUME_NONNULL_END
