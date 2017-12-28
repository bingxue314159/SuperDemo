//
//  TYGBatteryInfo.h
//  SuperDemo
//
//  Created by 谈宇刚 on 2017/12/28.
//  Copyright © 2017年 TYG. All rights reserved.
//
//原作者：https://github.com/PengfeiWang666/iOS-getClientInfo

#import <Foundation/Foundation.h>

@interface TYGBatteryInfo : NSObject

@property (nonatomic, assign) NSUInteger capacity;/**< 电池容量 */
@property (nonatomic, assign) CGFloat voltage;/**< 电池电流 */

@property (nonatomic, assign) NSUInteger levelPercent;/**< 电量（%） */
@property (nonatomic, assign) NSUInteger levelMAH;/**< 当前电量（剩余电量）; */
@property (nonatomic, copy)   NSString *status;/**< 电池状态 */

+ (instancetype)sharedManager;
/** 开始监测电池电量 */
- (void)startBatteryMonitoringCallback:(void(^)(TYGBatteryInfo *sender))batteryStatusUpdated;
/** 停止监测电池电量 */
- (void)stopBatteryMonitoring;


@end
