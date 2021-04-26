//
//  NSDictionary+TransformUntils.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "NSDictionary+TransformUntils.h"
#import "NSString+StrHelper.h"
#import "PrefixHeader.h"

@implementation NSDictionary (TransformUntils)
- (NSString *)toURLParamsString
{
    if (self.count <= 0) {
        return @"";
    }
    NSMutableString *paramsStr = [NSMutableString new];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            if ([obj isKindOfClass:[NSNumber class]]) {
                obj = [NSString stringWithFormat:@"%d",[obj intValue]];
            }
        }
        if (obj && ![obj isEqualToString:@""]) {
            [paramsStr appendFormat:@"%@=%@&", key, [obj URLEncodedString]];
        }
        else
        {
            [paramsStr appendFormat:@"%@=%@&", key, @""];
        }
    }];
    
    [paramsStr deleteCharactersInRange:NSMakeRange([paramsStr length]-1, 1)];
    return paramsStr;
}

- (NSString *)toJsonString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else
        return @"";
    
}

- (void)test{
    BigLog(@"dddddddddddddd");
}
@end
