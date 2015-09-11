//
//  TYGValid.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/8.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGValid.h"

@implementation TYGValid

//验证邮箱格式（可匹配多个结果）
+ (BOOL) isEmail:(NSString *)email{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    if (result) {
        NSLog(@"%@\n", [email substringWithRange:result.range]);
        return YES;
    }
    return NO;
}

/*
 * Email邮箱格式验证
 * 如：zhangsan@163.com、li-si@236.net、wan_gwu999@SEED.NET.TW
 */
+(BOOL)isValidateEmail:(NSString *)email {
    
    //\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+
    //[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?
    //^([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+(\.[a-zA-Z]{2,3})+$
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 * 手机号码格式验证
 */
+(BOOL)isTelphoneNumber:(NSString *)telNum{
    
    telNum = [telNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] == 11) {
        NSString *telNumRegex = @"^1[3-8]+\\d{9}$";
        NSPredicate *telNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telNumRegex];
        return [telNumTest evaluateWithObject:telNum];
    }
    return NO;
}

/**
 * 利用正则表达式验证是否是数字与字母的组合
 */
+(BOOL)isNumberAndChar:(NSString *)sting{
    sting = [sting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:sting];
}

/**
 * 验证是否是数字
 */
+(BOOL)isNumber:(NSString *)sting{
    //^((\+|\-)?[1-9]\d*\.?\d*)|((\+|\-)?0\.\d*)|(\.\d*)$
    sting = [sting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^([0-9]+\\d*\\.?\\d*)|(0(\\.\\d*)?)|(\\.\\d*)$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:sting];
}


/**
 * 验证是否是身份证号码
 *
 * 身份证15位编码规则：dddddd yymmdd xx p
 * dddddd：6位地区编码
 * yymmdd: 出生年(两位年)月日，如：910215
 * xx: 顺序编码，系统产生，无法确定
 * p: 性别，奇数为男，偶数为女
 *
 * 身份证18位编码规则：dddddd yyyymmdd xxx y
 * dddddd：6位地区编码
 * yyyymmdd: 出生年(四位年)月日，如：19910215
 * xxx：顺序编码，系统产生，无法确定，奇数为男，偶数为女
 * y: 校验码，该位数值可通过前17位计算获得
 *
 * 前17位号码加权因子为 Wi = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ]
 * 验证位 Y = [ 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 ]
 * 如果验证码恰好是10，为了保证身份证是十八位，那么第十八位将用X来代替
 * 校验位计算公式：Y_P = mod( ∑(Ai×Wi),11 )
 * i为身份证号码1...17 位; Y_P为校验码Y所在校验码数组位置
 */
+ (BOOL)isIDCard:(NSString *)idCardString{
    
    //^(\d{6})(\d{4})(\d{2})(\d{2})(\d{3})([0-9]|X)$
    //^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$
    idCardString = [idCardString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    
    BOOL flag = [stringTest evaluateWithObject:idCardString];
    
    if (flag == YES) {
        if (idCardString.length == 18) {
            NSArray *idCardWi = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @2];//将前17位加权因子保存在数组里
            NSArray *idCardY = @[@1, @0, @10, @9, @8, @7, @6, @5, @4, @3, @2];//这是除以11后，可能产生的11位余数、验证码，也保存成数组
            
            NSInteger idCardWiSum = 0;//用来保存前17位各自乖以加权因子后的总和
            for (int i = 0; i < 17; i++) {
                
                NSString *idCardStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
                NSNumber *num = [idCardWi objectAtIndex:i];
                
                NSInteger idCardStrInt = [idCardStr integerValue];
                NSInteger numInt = [num integerValue];
                idCardWiSum += idCardStrInt * numInt;
            }
            
            NSInteger idCardMod = idCardWiSum % 11;//计算出校验码所在数组的位置
            NSString *idCardLast = [idCardString substringWithRange:NSMakeRange(17, 1)];//得到最后一位身份证号码
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if (idCardMod == 2) {
                if ([@"X" isEqualToString:idCardLast] || [@"x" isEqualToString:idCardLast]) {
                    //通过验证
                    flag = YES;
                }
                else{
                    flag = NO;
                }
            }
            else{
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                NSNumber *modNum = [idCardY objectAtIndex:idCardMod];
                if ([idCardLast isEqualToString:[modNum stringValue]]) {
                    //通过验证
                    flag = YES;
                }
                else{
                    flag = NO;
                }
            }
        }
    }
    
    return flag;
}


/**
 * 固定电话号码格式
 * 因为固定电话格式比较复杂，情况比较多，主要验证了以下类型
 * 如：010-12345678、0912-1234567、(010)-12345678、(0912)1234567、(010)12345678、(0912)-1234567、01012345678、09121234567
 */
+(BOOL)isPhoneNumber:(NSString *)sting{
    //^(^0\d{2}-?\d{8}$)|(^0\d{3}-?\d{7}$)|(^0\d2-?\d{8}$)|(^0\d3-?\d{7}$)$
    sting = [sting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^(^0\\d{2}-?\\d{8}$)|(^0\\d{3}-?\\d{7,8}$)|(^0\\d2-?\\d{8}$)|(^0\\d3-?\\d{7,8}$)$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:sting];
}

/**
 * 只能是中文汉字
 */
+(BOOL)isChinese:(NSString *)sting{
    //^[\u4e00-\u9fa5]+$
    sting = [sting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:sting];
}


@end
