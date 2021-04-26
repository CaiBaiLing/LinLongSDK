//
//  LTFastRegiestView.h
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/27.
//

#import "LTABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LTFastRegiestViewDelegate <LTLoginBaseDelegate>

//4.点击登录
- (void)fastRegiestClickActionAccount:(NSString *)account password:(NSString *)password;

@end

@interface LTFastRegiestView : LTABaseView

@property (nonatomic, weak) id<LTFastRegiestViewDelegate>delegate;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *psd;

@end

NS_ASSUME_NONNULL_END
