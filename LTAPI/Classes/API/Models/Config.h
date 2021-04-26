//
//  Config.h
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "BaseModel.h"


@interface Config : BaseModel
@property (nonatomic, copy, readonly) NSString *mainURL;
@property (nonatomic, copy, readonly) NSString *clientKey;
@property (nonatomic, copy, readonly) NSString *clientSecret;
//@property (nonatomic, copy, readonly) NSString *channelID;
@end
