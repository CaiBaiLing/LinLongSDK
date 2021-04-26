//
//  LTDataManager.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "DataManager.h"
#import "LocalData.h"
#import "PrefixHeader.h"

static DataManager *dataManager = nil;

@interface DataManager ()
@property (nonatomic, assign) long long offsetTime;
@end

@implementation DataManager

+ (DataManager *)sharedDataManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DataManager alloc] init];
    });
    
    return dataManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self) {
        if (dataManager == nil) {
            dataManager = [super allocWithZone:zone];
            return dataManager;
        }
    }
    return nil;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isReviewed = NO;
        self.configParams = [[Config alloc] init];
        [self addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        //self.handler = [HBRSAHandler new];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"time"]){
        long long currentTime = [[DeviceHelper getSTimestamp] longLongValue];
        long long serverTime = [_time longLongValue];
        self.offsetTime = serverTime - currentTime;
    }
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"time"];
}

- (void)setRsaPublic:(NSString *)rsaPublic{
    _rsaPublic = [rsaPublic copy];
    [LocalData recordRsapub:_rsaPublic];
}

- (LTSDKUserModel *)userInfo {
    return [LTSDKUserModel shareManger];
}

@end
