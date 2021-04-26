//
//  LTFrogotView.h
//  AFNetworking
//
//  Created by zuzu360 on 2019/12/26.
//

#import "LTABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LTFrogotViewDelegate <NSObject>

- (void)getPhoneCodeAction:(NSString *)phoneNo requestHandler:(void(^)(BOOL))handle;
- (void)enterBtnAction:(NSString *)phoneNo phoneCode:(NSString *)phoneCode password:(NSString *)psd;
- (void)closeViewAction;

@end

@interface LTFrogotView : LTABaseView

@property (nonatomic, weak) id<LTFrogotViewDelegate>delegate;
@property (nonatomic, copy) NSString *msg;
- (void)releaseTime;

@end

NS_ASSUME_NONNULL_END
