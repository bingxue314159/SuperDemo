//
//  TYGValid.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/8.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  正则的各种验证

#import <Foundation/Foundation.h>

@interface TYGValid : NSObject


/*
 * Email邮箱格式验证
 * 如：zhangsan@163.com、li-si@236.net、wan_gwu999@SEED.NET.TW
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 * 手机号码格式验证
 */
+ (BOOL)isTelphoneNumber:(NSString *)telNum;

/*
 * Email邮箱格式验证
 * 如：zhangsan@163.com、li-si@236.net、wan_gwu999@SEED.NET.TW
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 * 利用正则表达式验证是否是数字与字母的组合
 */
+ (BOOL)isNumberAndChar:(NSString *)sting;

/**
 * 验证是否是数字
 * 如：102，5.88，0.88，.88
 */
+(BOOL)isNumber:(NSString *)sting;

/**
 *  验证是否是身份证号
 */
+ (BOOL)isIDCard:(NSString *)idCardString;

/**
 * 固定电话号码格式
 * 因为固定电话格式比较复杂，情况比较多，主要验证了以下类型
 * 如：010-12345678、0912-1234567、(010)-12345678、(0912)1234567、(010)12345678、(0912)-1234567、01012345678、09121234567
 */
+(BOOL)isPhoneNumber:(NSString *)sting;

/**
 * 只能是中文汉字
 */
+(BOOL)isChinese:(NSString *)sting;

@end
