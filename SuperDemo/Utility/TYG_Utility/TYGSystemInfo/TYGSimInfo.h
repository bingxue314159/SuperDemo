//
//  TYGSimInfo.h
//  SuperDemo
//
//  Created by 谈宇刚 on 2018/1/8.
//  Copyright © 2018年 TYG. All rights reserved.
//
//  获取Sim卡信息

#import <Foundation/Foundation.h>

@interface TYGSimInfo : NSObject

+ (instancetype)sharedManager;

/**
 获取当前网络的类型(ios7之后可以按照以下方式获取。方便而且类型多)
 
 @return 网络类型（CTRadioAccessTechnologyGPRS，CTRadioAccessTechnologyWCDMA……）
 */
- (NSString *)getCurrentRadioAccessTechnology;

/**
 获取当前网络的类型(ios7之后可以按照以下方式获取。方便而且类型多)
 
 @return 网络类型（3G，4G……）
 */
+ (NSString *)getCurrentRadioAccessTechnologyName;

/**
 获取sim卡信息
 
 @return NSDictionary
 */
- (NSDictionary *)getcarrierInfo;


/**
 获取网络环境
 */
+ (NSString *)networktype;

/// iOS获取设备的网络状态(已适配iOS13,iOS14无变化)
+ (NSString *)getNetworkType;

@end
