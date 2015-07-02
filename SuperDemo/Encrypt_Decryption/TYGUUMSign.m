//
//  TYGUUMSign.m
//  AutomobileMarket
//
//  Created by tanyugang on 15/3/23.
//  Copyright (c) 2015年 YDAPP. All rights reserved.
//

#import "TYGUUMSign.h"
#import "NSData+AES256.h"
#import "Utility.h"

@implementation TYGUUMSign

/**
 * 生成签名
 *
 */
+ (NSString *)signDic:(NSDictionary *)dic{
    
    NSLog(@"生成签名,参数：%@",dic);
    
    NSArray *keyArray = [dic allKeys];

    //字符串的比较
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [keyArray sortedArrayUsingDescriptors:descriptors];
    
    //生成排序好的字符串
    NSMutableString *jsonStr = [NSMutableString string];
    
    for (int i=0; i<resultArray.count; i++) {
        
        NSString *key = [resultArray objectAtIndex:i];
        NSString *value = [dic objectForKey:key];
        if (value.length) {
            [jsonStr appendFormat:@"%@%@",key,value];
        }
    }

    //添加干挠码
    [jsonStr appendFormat:disturbCode];
    
    //MD5
    NSData *md5Data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *md5Str = [md5Data md5Hash];
    
    //Base64
    NSData *base64Data = [md5Str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [GTMBase64_tyg stringByEncodingData:base64Data];
    
    return base64Str;
}

/**
 * 封装系统相关信息及参数设置
 * @param api:接口
 * @param dataDic:data参数部分
 */
+ (NSString *) uumParamDicWithApi:(NSString *)api dataDic:(NSDictionary *)dataDic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [dic setObject:@"IOS" forKey:@"os"];//os
    [dic setObject:@"1.0" forKey:@"v"];//API版本--Version
    [dic setObject:@"10086" forKey:@"app"];
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    [dic setObject:uuid.UUIDString forKey:@"clientId"];//UUID--MacUUID
    
    //api
    [dic setValue:api forKey:@"api"];
    
    //data
    NSString *dataStr = [Utility safeToJSON:dataDic];
    dataStr = [GTMBase64_tyg stringByEncodingData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dic setValue:dataStr forKey:@"data"];
    
    //param
    NSString *dicStr = [Utility safeToJSON:dic];
    
    return dicStr;
}

@end
