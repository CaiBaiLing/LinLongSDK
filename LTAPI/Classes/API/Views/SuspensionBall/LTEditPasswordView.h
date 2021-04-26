//
//  LTEditPasswordView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/20.
//

#import "LTMeBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, LTEditPasswordViewType) {
    LTEditPasswordViewTypeNoBindPhone,
    LTEditPasswordViewTypeBindPhone,
};

@interface LTEditPasswordView : LTMeBaseView

@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, assign) LTEditPasswordViewType viewType;

@end

NS_ASSUME_NONNULL_END
