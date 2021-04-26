//
//  NoticeModel.h
//  AFNetworking
//
//  Created by 徐广江 on 2020/11/19.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeModel : BaseModel

@property (nonatomic, copy) NSString *noticeId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *publish_time;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
