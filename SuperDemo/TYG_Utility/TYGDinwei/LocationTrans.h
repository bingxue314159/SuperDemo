//
//  LocationTrans.h
//  2013002-­2
//
//  Created by  tanyg on 13-10-8.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
/**
 * iPhone的GPS定位(CLLocationManager)获得的经纬坐标是基于WGS-84坐标系（世界标准)
 * Google地图使用的是GCJ-02坐标系（中国特色的火星坐标系），这就是为什么获得的经纬坐标在google地图上会发生偏移
 * 百度的经纬坐标在GCJ-02的基础上再做了次加密，就是DB-09坐标系
 */

#import <Foundation/Foundation.h>

@interface LocationTrans : NSObject

// 定义经纬度结构体
typedef struct {
    double lng;
    double lat;
} Location;

Location LocationMake(double lng, double lat);

/**
 * WGS-84 到 GCJ-02 的转换
 * iOS  到 Google地图
 */
Location transformFromWGSToGCJ(Location wgLoc);

/**
 * GCJ-02 坐标转换成 BD-09 坐标
 * Google 到 百度
 */
Location bd_encrypt(Location gcLoc);

@end
