//
//  NSString+StrHelper.m
//  LTSDK
//
//  Created by zhengli on 2018/4/25.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "NSString+StrHelper.h"
#import <CommonCrypto/CommonCrypto.h>
#import "PrefixHeader.h"

@implementation NSString (StrHelper)
- (NSString *)getMD5Str
{
    const char * cString = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cString, (CC_LONG)strlen((const char *)cString), result);
    NSString *sign= [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    return [sign lowercaseString];
}

- (BOOL)isRegularEmail
{
    NSString *regulationStr = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        
        //        [SeaGameAlertView showAlertViewWithMessage:[LocalizedStringReader getLocalizedStringForKey:@"emailError"] andActivityView:NO];
        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularEmailWithoutAlert
{
    NSString *regulationStr = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularUname
{//
    NSString *regulationStr =@"^[A-Za-z\\d]{6,16}$";
    //NSString *regulationStr = @"^[a-zA-Z0-9]{6,15}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularChinaPhone{
    NSString *regulationStr = @"^1\[3-9]\\d{9}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isRegularPasswd{
    NSString *regulationStr = @"^\\S{8,16}$"; //@"^.{6,15}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isIdCard{
    NSString *regulationStr = @"^([1-6][1-9]|50)\\d{4}(19|20)\\d{2}((0[1-9])|10|11|12)(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$"; //@"^.{6,15}$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulationStr options:0 error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (!result) {
        return NO;
    }
    
    return YES;
}

- (NSDictionary*)parseURL{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        params[kv[0]] = val;
    }
    return params;
}

- (NSString *)urlParamsToMD5{
    NSDictionary *paramsDic = [self parseURL];
    
    NSArray *allParams = [paramsDic allValues];
    
    NSMutableString *paramsStr = [[NSMutableString alloc] initWithCapacity:10.0];
    
    for (NSString *param in allParams) {
        if ([param isEqualToString:@""]) {
            [paramsStr appendString:@"&"];
        }
        else
        {
            [paramsStr appendString:param];
        }
        
    }
    
    NSString *md5Str = [paramsStr getMD5Str];
    
    return md5Str;
}

- (NSString *)URLEncodedString{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)timestrToTimeformat{
    NSDate *date = [[NSDate date] initWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter stringFromDate:date];
}

- (NSData *)dataWithBase64Encoded
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        unichar _char = [self characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char    *cString = [subString UTF8String];
        //判断是否为英文和数字
        if ((0x4e00 < _char  && _char < 0x9fff) || strlen(cString) == 3){
            return YES;
        }
    }
    return NO;
}
- (NSString *) utf8ToUnicode
{
    NSUInteger length = [self length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        unichar _char = [self characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char    *cString = [subString UTF8String];
        //判断是否为英文和数字
        if ((0x4e00 < _char  && _char < 0x9fff) || strlen(cString) >= 3)
        {
            unsigned short asciiCode = 92;
            [s appendFormat:@"%cu%x",asciiCode,[self characterAtIndex:i]];
            
        }
        else if (strlen(cString) == 2)
        {
            unsigned short asciiCode = 92;
            [s appendFormat:@"%cu00%x",asciiCode,[self characterAtIndex:i]];
            
        }
        else
        {
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i, 1)]];
        }
        
    }
    return s;
}

/**
 随机生成指定长度用户名(字符串以字母开头)
 */
+ (NSString *)getRoundAccountWihtLenth:(NSInteger)lenth {
    NSArray *string = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"g",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    NSArray *numberArray =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableString *randomStirng = [NSMutableString string];
    //1.随机字母
    uint32_t index = arc4random() % 24;
    NSString *enString = string[index];
    for (int i = 0; i < lenth - 1; i++) {
        uint32_t index = arc4random() % 10;
        [randomStirng appendString:numberArray[index]];
    }
    //BOOL isHex = arc4random()%2 > 0.5;
    [randomStirng insertString:enString atIndex:randomStirng.length];
    return randomStirng;
}

+ (NSString *)getRoundPsswordWihtLenth:(NSInteger)lenth {
    NSArray<NSString *> *stringArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"g",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    NSMutableString *randomStirng = [NSMutableString string];
    //1.随机第一个字符
        uint32_t index = arc4random() % 35;
        for (int i = 0; i < lenth;index = arc4random() % 35, i++) {
            [randomStirng appendString:stringArray[index]];
        }
    return randomStirng;
}

//+ (NSString *)getRoundStringWihtLenth:(NSInteger)lenth isHasPrefixEN:(BOOL)isHasPrefixEn {
//    //NSArray<NSString *> *stringArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"g",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
//    //NSMutableString *randomStirng = [NSMutableString string];
//    //1.随机第一个字符
////    uint32_t index = arc4random() % 35;
////    for (int i = 0; i < lenth;index = arc4random() % 35, i++) {
////        if (i == 0 && index < 10) {
////            i --;
////            continue;
////        }
////        if (index > 10) {
////            BOOL isupLoad = arc4random()%2 > 0.5;
////            if (isupLoad) {
////                [randomStirng appendString:[stringArray[index] uppercaseString]];
////                continue;
////            }
////        }
////        [randomStirng appendString:stringArray[index]];
////    }
//
//    NSArray *string = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"g",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
//    NSArray *numberArray =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
//    NSMutableString *randomStirng = [NSMutableString string];
//    //1.随机字母
//    uint32_t index = arc4random() % 24;
//    NSString *enString = string[index];
//    for (int i = 0; i < lenth - 1; i++) {
//        uint32_t index = arc4random() % 10;
//        [randomStirng appendString:numberArray[index]];
//    }
//    //BOOL isHex = arc4random()%2 > 0.5;
//    [randomStirng insertString:enString atIndex:isHasPrefixEn?0:randomStirng.length];
//    return randomStirng;
//}
@end
