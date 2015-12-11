//
//  TYGEncryptDecrypt.h
//  youjiaba
//
//  Created by 谈宇刚 on 14-11-21.
//  Copyright (c) 2014年 uvct. All rights reserved.
//
/**
 *  描述：各种编码、解码 加密、解密 算法
 *  作者：谈宇刚
 *  日期：2014年11月21日
 *  版本：1.1
 */


#import <UIKit/UIKit.h>

@interface TYGEncryptDecrypt : UIView

/**
 * MD5
 */
+(NSString *)md5Hash:(NSString *)string;

/**
 * DES加密
 */
+(NSString *)DESEncrypt:(NSString *)plainText key:(NSString *)key;

/**
 * DES解密
 */
+(NSString *)DESDecrypt:(NSString *)cipherText key:(NSString *)key;



@end
