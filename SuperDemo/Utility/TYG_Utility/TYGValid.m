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
    if ([telNum length] != 11) {
        return NO;
    }
    
    /**
     * 规则 -- 更新日期 2017-03-30
     * 手机号码: 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     *
     * [数据卡]: 14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147,中国电信的是149等等。
     * [虚拟运营商]: 170[1700/1701/1702(电信)、1703/1705/1706(移动)、1704/1707/1708/1709(联通)]、171（联通）
     * [卫星通信]: 1349
     */
//    NSString *MOBILE = @"^(13[0-9]|14[579]|15[0-3,5-9]|17[0135678]|18[0-9])\\d{8}$";
//    NSPredicate *pred_mobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    return [pred_mobile evaluateWithObject:phoneNum];

    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147(数据卡),150,151,152,157,158,159,170[5],178,182,183,184,187,188
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[8])|(18[2-4,7-8]))\\d{8}|(170[5])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145(数据卡),155,156,170[4,7-9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[156])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149(数据卡),153,170[0-2],173,177,180,181,189
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNum];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNum];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNum];
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}

/**
 * 固定电话号码格式
 * 因为固定电话格式比较复杂，情况比较多，主要验证了以下类型
 * 如：010-12345678、0912-1234567、(010)-12345678、(0912)1234567、(010)12345678、(0912)-1234567、01012345678、09121234567
 */
+(BOOL)isHomePhoneNumber:(NSString *)sting{
    //^(^0\d{2}-?\d{8}$)|(^0\d{3}-?\d{7}$)|(^0\d2-?\d{8}$)|(^0\d3-?\d{7}$)$
    sting = [sting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^(^0\\d{2}-?\\d{8}$)|(^0\\d{3}-?\\d{7,8}$)|(^0\\d2-?\\d{8}$)|(^0\\d3-?\\d{7,8}$)$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:sting];
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
 * 只能是中文汉字
 */
+(BOOL)isChinese:(NSString *)string{

    for (NSInteger i = 0; i < [string length]; i++) {
        int a = [string characterAtIndex:i];
        if (a < 0x4e00 || a > 0x9fa5) {
            return NO;
        }
    }
    return YES;
}

/**
 * 是否含有中文汉字
 */
+ (BOOL)isHaveChineseInString:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:string];
}

/**
 *  验证银行卡号（13位 到 19位）
 *  @param bankIdCardNum 银行卡卡号
 *  @return BOOL
 */
+ (BOOL)isBankCardNum:(NSString *)bankCardNum{
    
    /*
     前六位是：发行者标识代码 Issuer Identification Number (IIN)。
     中间的位数是：个人账号标识(从卡号第七位开始)
     最后一位位数是校验位,采用Luhn算法
     */
    
    
    BOOL flag = NO;
    if (bankCardNum.length >= 13 && bankCardNum.length <= 19) {
        
        flag = [TYGValid isLuhnAlgorithm:bankCardNum];
    }
    
    return flag;
}

/**
 *  验证数字是否符合Luhn算法
 *  @param anNumStr 纯数字字符串
 *  @return BOOL
 */
+ (BOOL)isLuhnAlgorithm:(NSString *)anNumStr{
    /*
     LUHN算法，主要用来计算信用卡等证件号码的合法性。
     1、从卡号最后一位数字开始,偶数位乘以2,如果乘以2的结果是两位数，将两个位上数字相加保存。
     2、把所有数字相加,得到总和。
     3、如果信用卡号码是合法的，总和可以被10整除。
     */
    
    BOOL flag = NO;
    if (anNumStr.length > 0) {
        //验证是否为数字
        anNumStr = [anNumStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *stringRegex = @"^[0-9]+$";
        NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL isNumStr = [stringTest evaluateWithObject:anNumStr];
        if (isNumStr) {
            
            //拆解,数字分割成数组
            NSMutableString *numMStr = [NSMutableString stringWithString:anNumStr];
            NSInteger lastNum = [[numMStr substringFromIndex:(anNumStr.length - 1)] integerValue];
            NSInteger countNum = 0;//求和
            NSInteger count = 0;//计数器
            for (NSInteger i = (numMStr.length - 1); i >= 0; i--) {
                
                count += 1;
                if (count == 1) {
                    //卡号最后一位数字，根据校验位前的数字计算得到
                    continue;
                }
                
                NSInteger tempNum = [[numMStr substringWithRange:NSMakeRange(i, 1)] integerValue];
                if (count%2 == 0) {
                    //取偶数位
                    tempNum = tempNum*2;
                    if (tempNum >= 10) {
                        tempNum = tempNum%10 + 1;
                    }
                }
                countNum += tempNum;
            }

            NSInteger checkdDigit = (countNum*9)%10;//得出真实的校验码
            if (lastNum == checkdDigit) {
                flag = YES;
            }
        }
    }
    
    return flag;
}


@end
