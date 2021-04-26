//
//  LTMeBaseView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/16.
//

#import <UIKit/UIKit.h>
#import "LTABaseView.h"
NS_ASSUME_NONNULL_BEGIN

@class LTMeCustomNavigation;

@interface UIView(LTMeCustomNavigation)

@property (nonatomic, strong) LTMeCustomNavigation *navigationBar;
@property (nonatomic, copy) NSString *navigationTitle;

@end

@interface LTMeBaseView : LTABaseView

@end

@interface LTMeCustomNavigation : UIView

@property (nonatomic, copy) NSArray *leftBarItemArray;
@property (nonatomic, copy) NSArray *rightBarItemArray;
@property (nonatomic, strong) UIView *leftBar;
@property (nonatomic, strong) UIView *rightBar;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, assign) BOOL isHidenLine;

- (instancetype)initWithRootView:(UIView *)rootView;

- (void)popView;

- (void)pushView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
