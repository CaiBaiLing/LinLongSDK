//
//  LoadView.h
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TipView : UIView

//显示加载器
+ (void)showPreloader;

//隐藏加载器
+ (void)hidePreloader;

//轻量提示-默认2秒后消失
+ (void)toast:(NSString *)msg supView:(UIView *)supView;

//轻量提示-默认2秒后消失
+ (void)toast:(NSString *)msg;

//alert
+(void)alert:(NSString *)msg;

@end
