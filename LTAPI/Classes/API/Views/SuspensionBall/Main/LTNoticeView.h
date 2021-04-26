//
//  LTNoticeView.h
//  LTAPI
//
//  Created by 徐广江 on 2020/11/20.
//

#import "LTMeBaseView.h"
@class NoticeModel;
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeSelectDelegate <NSObject>

-(void)selectNoticeDetailWithModel:(NoticeModel *)model;

@end

@interface LTNoticeView : LTMeBaseView

@property (nonatomic, weak) id<NoticeSelectDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
