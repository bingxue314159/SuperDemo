//
//  EncryptUtil.h
//  gannicus
//
//  Created by Zhu Boxing on 13-7-15.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64_tyg.h"

@interface EncryptUtil : NSObject
/**
 使用默认密钥加密
 @param  sText 数据内容 */
+ (NSString *)encryptWithText:(NSString *)sText;
/**
 使用默认密钥解密
 @param  sText 数据内容 */
+ (NSString *)decryptWithText:(NSString *)sText;
/**
 使用自定义密钥加密
 @param  sText 数据内容
 @param  key 自定义密钥(少于24位末尾自动补零) */
+ (NSString *)encryptTextWithKey:(NSString *)sText key:(NSString *) key;
/**
 使用自定义密钥解密
 @param  sText 数据内容
 @param  key 自定义密钥(少于24位末尾自动补零) */
+ (NSString *)decryptTextWithKey:(NSString *)sText key:(NSString *) key;

@end
