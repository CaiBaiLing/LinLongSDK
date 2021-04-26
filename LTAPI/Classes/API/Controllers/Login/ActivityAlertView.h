//
//  ActivityAlertView.h
//  AFNetworking
//
//  Created by 徐广江 on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityAlertView : UIView

+ (void)showAlertViewWithagreeBlock:(void (^)(void))agreeBlock readPrivacyPolicyBlock:(void(^)(void))readPrivacyPolicyBlock readProtocolBlock:(void(^)(void))readProtocolBlock;

@end

NS_ASSUME_NONNULL_END
