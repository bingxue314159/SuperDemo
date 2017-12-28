//
//  TYGDeviceDataLibrery.h
//  SuperDemo
//
//  Created by 谈宇刚 on 2017/12/28.
//  Copyright © 2017年 TYG. All rights reserved.
//
//原作者：https://github.com/PengfeiWang666/iOS-getClientInfo

#import <Foundation/Foundation.h>

@interface TYGDeviceDataLibrery : NSObject

+ (instancetype)sharedLibrery;
/** 获取设备名称 */
- (const NSString *)getDiviceName;
/** 获取设备电池容量，单位 mA 毫安 */
- (NSInteger)getBatteryCapacity;
/** 获取电池电压，单位 V 福特 */
- (CGFloat)getBatterVolocity;
/** 获取CPU处理器名称 */
- (const NSString *)getCPUProcessor;

@end
