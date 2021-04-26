//
//  NetWorkingEngine.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "NetWorkingEngine.h"

@interface NetworkingEngine ()
@property (nonatomic, copy) NSData *uploadData;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;//既可以上传，又可以下载的任务
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask; //上传任务
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask; //下载任务
@property (nonatomic, copy) RequestHandler resultHandler;
@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSData *resultData;
@property (nonatomic, strong) NSError *error;
@end

@implementation NetworkingEngine

#pragma mark - init functions
- (instancetype)initWithURLString:(NSString *)aURLString httpMethod:(NSString *)method{
    self = [super init];
    if (self) {
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aURLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:REQUEST_TIMEOUT_DEFAULT];
        [_request setHTTPMethod:method];
        [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    }
    return self;
}

#pragma mark - request configuaration

/*!
 *  @abstract Add additional header
 *
 *  @discussion Add a single additional header.  See addHeaders for a full discussion.
 */
- (void)addHeader:(NSString*)key withValue:(NSString*)value{
    if (_request) {
        [_request addValue:value forHTTPHeaderField:key];
    }
}

/*!
 *  @abstract Add additional header parameters
 *
 *  @discussion
 *    If you ever need to set additional headers after creating your operation, you this method.
 *  You normally set default headers to the engine and they get added to every request you create.
 *  On specific cases where you need to set a new header parameter for just a single API call, you can use this
 */
- (void)addHeaders:(NSDictionary*)headersDictionary{
    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.request addValue:obj forHTTPHeaderField:key];
    }];
}


//default is 30s.
- (void)setTimeout:(NSTimeInterval)timeout{
    
    if (_request) {
        [_request setTimeoutInterval:timeout];
    }
}
//考虑到有可能会对data加密等各种情况，直接使用data做参数，而不是dictionary
- (void)setHttpBody:(NSData *)data{
    if (_request) {
        [_request setHTTPBody:data];
    }
    
}

- (void)setUploadData:(NSData *)data{
    self.uploadData = data;
}

#pragma mark - response
- (NSString *)responseString{
    NSString *responseStr = nil;
    responseStr = [[NSString alloc] initWithData:_resultData encoding:NSUTF8StringEncoding];
    return responseStr;
}
- (NSDictionary *)responseDictionary{
    NSDictionary *responseDic = nil;
    NSError * dicError = nil;
    responseDic = [NSJSONSerialization JSONObjectWithData:_resultData options:NSJSONReadingMutableLeaves error:&dicError];
    return responseDic;
}
- (UIImage *)responseImage{
    UIImage *image = nil;
    image = [UIImage imageWithData:_resultData];
    return image;
}

#pragma mark - request functions
- (void)dataTaskRequest{
    self.dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:_request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self setResponseWithData:data response:response error:error];
    }];
    [_dataTask resume];
}

- (void)downloadTaskRequest{
    self.downloadTask = [[NSURLSession sharedSession] downloadTaskWithRequest:_request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self setResponseWithData:nil response:response error:error];
    }];
    [_downloadTask resume];
}

- (void)uploadTaskRequest{
    self.uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:_request fromData:_uploadData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self setResponseWithData:data response:response error:error];
    }];
    [_uploadTask resume];
}

- (void)setResponseWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error{
    self.resultData = data;
    self.response = response;
    self.error = error;
    
    if (_resultHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultHandler(data, response, error);
        });
    }
    
    
}

- (void)completedWithCompletedHandler:(RequestHandler)completed{
    self.resultHandler = completed;
}

- (void)taskStartWithRequestType:(RequestType)type completedHandler:(RequestHandler)handler{
    self.resultHandler = handler;
    self.requestType = type;
    switch (type) {
        case RequestType_data:
            [self dataTaskRequest];
            break;
        case RequestType_download:
            [self downloadTaskRequest];
            break;
        case RequestType_upload:
            [self uploadTaskRequest];
            break;
        default:
            break;
    }
}

- (void)repeatTask{
    switch (_requestType) {
        case RequestType_data:
            [self dataTaskRequest];
            break;
        case RequestType_download:
            [self downloadTaskRequest];
            break;
        case RequestType_upload:
            [self uploadTaskRequest];
            break;
        default:
            break;
    }
}

- (void)cancelTask{
    if (_dataTask) {
        [_dataTask cancel];
    }
    if (_downloadTask) {
        [_downloadTask cancel];
    }
    if (_uploadTask) {
        [_uploadTask cancel];
    }
    if (_resultHandler) {
        
        self.resultHandler = nil;
    }
}
@end

