//
//  TYGUUMSign.h
//  AutomobileMarket
//
//  Created by tanyugang on 15/3/23.
//  Copyright (c) 2015年 YDAPP. All rights reserved.
//
//  生成签名

#import <UIKit/UIKit.h>
#import "GTMBase64_tyg.h"

#define disturbCode @"uuxoo!#$F2*809ss888E01BF6B6C208ddd062DCABAB8AF"

@interface TYGUUMSign : UIView

/**
 * 生成签名
 *
 */
+ (NSString *)signDic:(NSDictionary *)dic;

/**
 * 封装系统相关信息及参数设置
 * @param api:接口
 * @param dataDic:data参数部分
 */
+ (NSString *) uumParamDicWithApi:(NSString *)api dataDic:(NSDictionary *)dataDic;
@end
