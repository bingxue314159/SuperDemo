//
//  TYGDeviceInfo.h
//  SuperDemo
//
//  Created by 谈宇刚 on 2017/12/28.
//  Copyright © 2017年 TYG. All rights reserved.
//
//原作者：https://github.com/PengfeiWang666/iOS-getClientInfo

#import <Foundation/Foundation.h>

@interface TYGDeviceInfo : NSObject


/** 能否打电话 */
@property (nonatomic, assign, readonly) BOOL canMakePhoneCall NS_EXTENSION_UNAVAILABLE_IOS("");

+ (instancetype)sharedManager;
/** 容量转换 */
-(NSString *)fileSizeToString:(unsigned long long)fileSize;

/** 获取设备型号 */
- (const NSString *)getDeviceName;
/** 获取设备颜色 */
- (NSString *)getDeviceColor;
/** 获取设备外壳颜色 */
- (NSString *)getDeviceEnclosureColor;
/** 获取mac地址 */
- (NSString *)getMacAddress;
/** 获取广告标识符 */
- (NSString *)getIDFA;
/** 本机类型--e.g. @"iPhone", @"iPod, @"iPhone Simulator" */
- (NSString *)getDeviceModel;
/** 获取设备上次重启的时间 */
- (NSDate *)getSystemUptime;

/** CPU频率 */
- (NSUInteger)getCPUFrequency;
/** 获取总线程频率 */
- (NSUInteger)getBusFrequency;
/** 获取当前设备主存 */
- (NSUInteger)getRamSize;
/** 获取CPU线程数量 */
- (NSString *)getCPUProcessor;
/** 获取CPU数量 */
- (NSUInteger)getCPUCount;
/** 获取CPU总的使用百分比 */
- (float)getCPUUsage;
/** 获取单个CPU使用百分比 */
- (NSArray *)getPerCPUUsage;


/** 获取本 App 所占磁盘空间 */
- (NSString *)getApplicationSize;
/** 获取磁盘总空间 */
- (int64_t)getTotalDiskSpace;
/** 获取未使用的磁盘空间 */
- (int64_t)getFreeDiskSpace;
/** 获取已使用的磁盘空间 */
- (int64_t)getUsedDiskSpace;

/** 获取总内存空间 */
- (int64_t)getTotalMemory;
/** 获取活跃的内存空间 */
- (int64_t)getActiveMemory;
/** 获取不活跃的内存空间 */
- (int64_t)getInActiveMemory;
/** 获取空闲的内存空间 */
- (int64_t)getFreeMemory;
/** 获取正在使用的内存空间 */
- (int64_t)getUsedMemory;
/** 获取存放内核的内存空间 */
- (int64_t)getWiredMemory;
/** 获取可释放的内存空间 */
- (int64_t)getPurgableMemory;

@end
