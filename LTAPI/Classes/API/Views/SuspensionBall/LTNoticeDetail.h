//
//  LTNoticeDetail.h
//  LTAPI
//
//  Created by 徐广江 on 2020/11/20.
//

#import "LTMeBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class NoticeModel;
@interface LTNoticeDetail : LTMeBaseView
-(instancetype)initWithModel:(NoticeModel *)model;
@end

NS_ASSUME_NONNULL_END
