//
//  NetWorkingEngine.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQUEST_TIMEOUT_DEFAULT 30.0f

typedef void (^RequestHandler)(NSData *responseData, NSURLResponse *response, NSError *error);
typedef void (^RequestSuccessedHandler)(void);
typedef void (^RequestErrorHandler)(void);

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestType_data = 0,
    RequestType_download = 1,
    RequestType_upload = 2,
};

@interface NetworkingEngine : NSObject


//请求的数据
@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong, readonly) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSData *resultData;
@property (nonatomic, strong, readonly) NSError *error;



#pragma mark - request configuaration

/*!
 *  @abstract Add additional header
 *
 *  @discussion Add a single additional header.  See addHeaders for a full discussion.
 */
- (void)addHeader:(NSString*)key withValue:(NSString*)value;

/*!
 *  @abstract Add additional header parameters
 *
 *  @discussion
 *    If you ever need to set additional headers after creating your operation, you this method.
 *  You normally set default headers to the engine and they get added to every request you create.
 *  On specific cases where you need to set a new header parameter for just a single API call, you can use this
 */
- (void)addHeaders:(NSDictionary*)headersDictionary;


//default is 30s.
- (void)setTimeout:(NSTimeInterval)timeout;

//考虑到有可能会对data加密等各种情况，直接使用data做参数，而不是dictionary
- (void)setHttpBody:(NSData *)data;

- (void)setUploadData:(NSData *)data;

#pragma mark - response
- (void)completedWithCompletedHandler:(RequestHandler)completed;
- (NSString *)responseString;
- (NSDictionary *)responseDictionary;
- (UIImage *)responseImage;

#pragma mark - operation
- (void)taskStartWithRequestType:(RequestType)type completedHandler:(RequestHandler)handler;

- (instancetype)initWithURLString:(NSString *)aURLString httpMethod:(NSString *)method;
//重启任务
- (void)repeatTask;
//取消任务，只有在任务还未开始的时候才能取消
- (void)cancelTask;
@end
