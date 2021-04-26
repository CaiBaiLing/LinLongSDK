//
//  ToolsHelper.h
//  BigSDK
//
//  Created by zhengli on 2018/5/6.
//  Copyright © 2018年 zhengli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsHelper : NSObject

//MD5加密
+ (NSString *)md5EncryptWithString:(NSString *)string;

+ (float)fitLentoCurrentScreenWithOriginLen:(float)originLen;

+ (CGRect)fitFrametoCurrentScreenWithOriginFrame:(CGRect)originFrame;

//API接口签名
+ (NSString *)getSign:(NSDictionary *)dic;

////DES加密
//+ (NSString *) desEncrypt:(NSString *)clearText;
//
////DES解密
//+ (NSString *) desDecrypt:(NSString*)cipherText;


/** 获取根据当前模式返回颜色
@param lightColor 正常模式颜色
@param darkColor dark模式颜色
 */
+ (UIColor *)getCurrentColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

/** 生成对应颜色图片
 @param color 正常模式颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 获取当前文字在lLabel中的位置
 @param range 所在范围
 @param textLabel label
 */
+ (CGRect)boundingRectForCharacterRange:(NSRange)range textLabel:(UILabel *)textLabel;

+ (UIImage *)getCurrentImageWithImageName:(NSString *)imageName;

+ (void)saveToPasteBoard:(NSString *)string ;

@end
