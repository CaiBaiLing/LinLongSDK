//
//  NoticeModel.m
//  AFNetworking
//
//  Created by 徐广江 on 2020/11/19.
//

#import "NoticeModel.h"

NSString * const noticeId = @"id";
NSString * const title = @"title";
NSString * const content = @"content";
NSString * const publish_time = @"publish_time";

@implementation NoticeModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if ([dic respondsToSelector:@selector(objectForKey:)]) {
            self.noticeId = dic[noticeId];
            self.title = dic[title];
            self.content = dic[content];
            self.publish_time = dic[publish_time];
            
            
            if (!self.noticeId || [self.noticeId isEqualToString:@""]) {
                self.noticeId = @"";
            }
            if (!self.title || [self.title isEqualToString:@""]) {
                self.title = @"1";
            }
            if (!self.content || [self.content isEqualToString:@""]) {
                self.content = @"";
            }
            if (!self.publish_time || [self.publish_time isEqualToString:@""]) {
                self.publish_time = @"";
            }
        }
    }
    return self;
}


@end
