//
//  NSDictionary+TransformUntils.h
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TransformUntils)
- (NSString *)toURLParamsString;

- (NSString *)toJsonString;

- (void)test;
@end
