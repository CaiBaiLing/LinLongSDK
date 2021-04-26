//
//  ToolsHelper.m
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import "ToolsHelper.h"
//#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import "PrefixHeader.h"
#import <UIKit/UIKit.h>

@implementation ToolsHelper

//MD5加密
+(NSString *)md5EncryptWithString:(NSString *)string{
    const char * str = [string UTF8String];
    unsigned char result[16];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:16 * 2];
    for(int i = 0; i<16; i++) {
        [ret appendFormat:@"%02x",(unsigned int)(result[i])];
    }
    return ret;
}

+ (float)fitLentoCurrentScreenWithOriginLen:(float)originLen{
    CGSize screenSize = [DeviceHelper getScreenFrame].size;
    float shortSide = screenSize.width > screenSize.height ? screenSize.height : screenSize.width;
    float returnLen = originLen * shortSide / 320.0;
    return returnLen;
}

+ (CGRect)fitFrametoCurrentScreenWithOriginFrame:(CGRect)originFrame{
    CGRect fitFrame = originFrame;
    CGSize screenSize = [DeviceHelper getScreenFrame].size;
    float longSide = screenSize.width < screenSize.height ? screenSize.height : screenSize.width;
    float shortSide = screenSize.width > screenSize.height ? screenSize.height : screenSize.width;
    float mul = shortSide / 320.0;
    
    fitFrame.origin.y = fitFrame.origin.y * mul;
    fitFrame.size.width = fitFrame.size.width *mul;
    fitFrame.size.height = fitFrame.size.height * mul;
    fitFrame.origin.x = (longSide - fitFrame.size.width) /2;
    return fitFrame;
}

//获取签名
+ (NSString *)getSign:(NSDictionary *)dic{
    NSArray *keyArray = [dic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[dic objectForKey:sortString]];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    
    NSString *newStr = [signArray componentsJoinedByString:@""];
    NSString *composeStr = [NSString stringWithFormat:@"%@%@%@",CLIENT_SECRET,newStr,CLIENT_SECRET];
    //LTLog(@"签名前：{%@}",composeStr);
    NSString *sign = [self md5EncryptWithString:composeStr];
    //LTLog(@"签名结果：{%@}",sign);
    return [sign uppercaseString];
}

////DES加密
//+ (NSString *) desEncrypt:(NSString *)clearText {
//    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          [DES_ENCRYPT_KEY UTF8String],
//                                          kCCKeySizeDES,
//                                          nil,
//                                          [data bytes],
//                                          [data length],
//                                          buffer,
//                                          1024,
//                                          &numBytesEncrypted);
//    
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        plainText = [GTMBase64 stringByEncodingData:dataTemp];
//    }else{
//        BigLog(@"DES加密失败");
//    }
//    return plainText;
//}
//
////DES解密
//+ (NSString *) desDecrypt:(NSString*)cipherText {
//    // 利用 GTMBase64 解碼 Base64 字串
//    NSData* cipherData = [GTMBase64 decodeString:cipherText];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesDecrypted = 0;
//    
//    // IV 偏移量不需使用
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
//                                          [DES_ENCRYPT_KEY UTF8String],
//                                          kCCKeySizeDES,
//                                          nil,
//                                          [cipherData bytes],
//                                          [cipherData length],
//                                          buffer,
//                                          1024,
//                                          &numBytesDecrypted);
//    NSString* plainText = nil;
//    if (cryptStatus == kCCSuccess) {
//        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    return plainText;
//}

+ (UIColor *)getCurrentColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return lightColor;
            }else {
                return darkColor;
            }
        }];
    }
    return lightColor;
}

+ (UIImage *)getCurrentImageWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage new];
    UIImage *lightImage = SDK_PATHImage(imageName);
    if (@available(iOS 13.0, *)) {
        NSString *dartimageS = [NSString stringWithFormat:@"%@Dart", imageName];
        UIImage *dartimage = SDK_PATHImage(dartimageS);
        if (!dartimage) {
            return lightImage;
        }
        [image.imageAsset registerImage:lightImage withConfiguration:[[UIImageConfiguration alloc] configurationWithTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight]]];
        [image.imageAsset registerImage:dartimage withConfiguration:[[UIImageConfiguration alloc] configurationWithTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark]]];
        return image;
    }
    return lightImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();  //[UIImage imageWithCGImage:imageref];
    return image;
}

+ (CGRect)boundingRectForCharacterRange:(NSRange)range textLabel:(UILabel *)textLabel {
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[textLabel attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[textLabel bounds].size];
    textContainer.lineFragmentPadding=0;
    [layoutManager addTextContainer:textContainer];
    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    return[layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

+ (void)saveToPasteBoard:(NSString *)string {
    UIPasteboard *pas = [UIPasteboard generalPasteboard];
    [pas setString:string];
}

@end
