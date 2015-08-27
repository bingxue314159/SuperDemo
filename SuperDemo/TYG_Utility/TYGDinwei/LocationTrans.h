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

/**
 国内各地图API坐标系统比较
 * API                  坐标系
 * 百度地图API          百度坐标
 * 腾讯搜搜地图API       火星坐标
 * 搜狐搜狗地图API       搜狗坐标
 * 阿里云地图API         火星坐标
 * 图吧MapBar地图API    图吧坐标
 * 高德MapABC地图API    火星坐标
 * 灵图51ditu地图API    火星坐标
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
