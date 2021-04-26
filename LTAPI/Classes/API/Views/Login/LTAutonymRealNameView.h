 //
//  LTAutonymRealNameView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/1/6.
//

#import <UIKit/UIKit.h>
#import "LTMeBaseView.h"
NS_ASSUME_NONNULL_BEGIN


@interface LTAutonymRealNameContentView : LTMeBaseView <UITextFieldDelegate>

@property (nonatomic, copy) void(^commitBtnBlock)(NSString *name, NSString * ids);
//@property (nonatomic, assign) BOOL isBindPhone;
//- (void)releseTime;

@end

@interface LTAutonymRealNameView :LTMeBaseView

/// 显示实名认证框
/// @param isBindPhone 是否绑定过手机
/// @param isCanSkip 是否可以跳过
/// @param nextBtnBlock 点击跳过回调
/// @param commitBtnBlock 点击提交回调
+ (void)showAutonymRealNameViewIsCanSkip:(BOOL)isCanSkip  nextBtnBlock:(void (^_Nullable)(void))nextBtnBlock commitBtnBlock:(void (^)(NSString *name,NSString *ids))commitBtnBlock;

/// 隐藏实名认证窗口
+ (void)hidenAutonymRealNameView;

@end

NS_ASSUME_NONNULL_END
