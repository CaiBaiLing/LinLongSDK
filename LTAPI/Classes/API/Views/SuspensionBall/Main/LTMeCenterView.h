//
//  LTMeCenterView.h
//  AFNetworking
//
//  Created by 毛红勋 on 2020/4/16.
//

#import <UIKit/UIKit.h>
#import "LTMeBaseView.h"
#import "LTAViewManger.h"
NS_ASSUME_NONNULL_BEGIN

@interface LTMeCenterView : LTMeBaseView

@property (nonatomic, copy) void (^quitActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
