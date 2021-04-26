//
//  LTPhoneRegiestView.h
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/27.
//

#import "LTABaseView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol LTPhoneRegiestViewDelegate <LTLoginBaseDelegate>

//立即注册
- (void)phoneRegiestClickAction:(NSString *)phoneNo phoneCode:(NSString *)phoneCode password:(NSString *)psd;

@end

@interface LTPhoneRegiestView : LTABaseView

@property (nonatomic, weak) id<LTPhoneRegiestViewDelegate>delegate;
- (void)releseTime;
@end

NS_ASSUME_NONNULL_END
