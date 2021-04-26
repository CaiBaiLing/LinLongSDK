//
//  LTAHomeLoginView.h
//  LTAPI
//
//  Created by zuzu360 on 2019/12/25.
//  Copyright © 2019 LTSDK. All rights reserved.
//

#import "LTABaseView.h"


NS_ASSUME_NONNULL_BEGIN

@protocol LTAHomeLoginViewDelegate <LTLoginBaseDelegate>

///忘记密码
///@param phone 手机号
- (void)forgetPasswordClickAction:(NSString *)phone;

@end


@interface LTAHomeLoginView : LTABaseView

@property (nonatomic, weak) id<LTAHomeLoginViewDelegate>delegate;

- (void)reloadAcount;

@end

NS_ASSUME_NONNULL_END
