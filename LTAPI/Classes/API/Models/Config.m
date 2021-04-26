//
//  Config.m
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "Config.h"
#import "PrefixHeader.h"

@implementation Config

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *sdkParamsDictionaryPlistFilePath = [[NSBundle mainBundle] pathForResource:@"LTConfig" ofType:@"plist"];
        NSDictionary *sdkParamsDictionary = [[NSDictionary alloc] initWithContentsOfFile:sdkParamsDictionaryPlistFilePath];
        [sdkParamsDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSNull class]] || [obj isEqualToString:@""]) {
                BigLog(@"\n---------配置文件LTConfig.plist:%@字段未填写---------",key);
                obj = [NSString stringWithFormat:@""];
            }
            //配置参数传入为字符类型，Model中为BOOL类型转化放入字典问题（该问题只在iPhone5（即32位系统）上出现）
            if([obj isEqualToString:@"0"]){
                [self setValue:@(0)forKey:key];
            }
            else if ([obj isEqualToString:@"1"]){
                [self setValue:@(1) forKey:key];
            }
            else{
                [self setValue:obj forKey:key];
            }
        }];
    }
    return self;
}

@end
