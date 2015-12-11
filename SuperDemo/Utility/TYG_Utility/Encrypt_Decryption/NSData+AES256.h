//
//  NSData+Encrypt_AES256.h
//  2013002-­2
//
//  Created by  tanyg on 13-9-12.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
/**
 *  描述：各种编码、解码 加密、解密 算法
 *  作者：谈宇刚
 *  日期：2013年09月12日
 *  版本：1.0
 */

#import <UIKit/UIKit.h>
#import "GTMBase64_tyg.h"

@interface NSData (AES256)
-(NSString *)md5Hash;//MD5
-(NSString *)sha1Hash;//SHA1
-(NSString *)RC4Hlovey:(NSString*)aKey;//RC4

-(NSData *)AES256EncryptWithKey:(NSString *)key;//AES加密
-(NSData *)AES256DecryptWithKey:(NSString *)key;//AES解密

-(NSString *)DESEncrypt:(NSString *)plainText key:(NSString *)key;//DES加密
-(NSString *)DESDecrypt:(NSString *)cipherText key:(NSString *)key;//DES解密


-(NSData*)stringToByte:(NSString*)string;//二进制转十六进制
@end
