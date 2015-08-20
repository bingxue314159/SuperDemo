//
//  EncryptUtil.m
//  gannicus
//
//  Created by Zhu Boxing on 13-7-15.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import "EncryptUtil.h"
#define DESKEY @"1234455436whadfgaergadvfasfg"

@implementation EncryptUtil

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt)
    {
        NSData *decryptData = [GTMBase64_tyg decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [decryptData length];
        vplainText = [decryptData bytes];
    }
    else
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];
    }

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    //const void *vkey = (const void *) [DESKEY UTF8String];
    // 24位KEY
    if (key.length != 24) {
        for (int i = 0; key.length <= 24; i++) {
            key = [key stringByAppendingString:@"0"];
        }
    }
    ccStatus = CCCrypt(encryptOperation,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       [key UTF8String],
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64_tyg stringByEncodingData:data];
    }
    
    return result;
}
/**
 使用默认密钥加密
 @param  sText 数据内容 */

+ (NSString *)encryptWithText:(NSString *)sText
{
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:@"asdgwa!$#vzdr"];
}

+ (NSString *)decryptWithText:(NSString *)sText
{
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:@"asdgwa!$#vzdr"];
}

+ (NSString *)encryptTextWithKey:(NSString *)sText key:(NSString *) key
{
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *)decryptTextWithKey:(NSString *)sText key:(NSString *) key
{
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:key];
}

@end
