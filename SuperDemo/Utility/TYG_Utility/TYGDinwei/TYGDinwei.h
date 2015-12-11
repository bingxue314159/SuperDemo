//
//  TYGDinwei.h
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/17.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//
//  系统自带的定位功能

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationTrans.h"

@interface TYGDinwei : UIView

@property (nonatomic,strong) CLLocationManager *locationManager;/**< 位置管理器 */
@property (nonatomic) CLLocationCoordinate2D cll2D_WGS_84;/**< iPhone获取的经纬度，未经转换的WGS-84坐标系 */
@property (nonatomic) CLLocationCoordinate2D cll2D_GCJ_02;/**< Google地图使用的是GCJ-02坐标系(中国特色的火星坐标系) */
@property (nonatomic) CLLocationCoordinate2D cll2D_DB_09;/**< 百度的经纬坐标在GCJ-02的基础上再次加密，就是DB-09坐标系 */

/**
 *  开始定位
 */
- (void)starDinWei;

/**
 *  成功定位
 *  @param success block
 */
- (void)successDinwei:(void(^)(CLLocationManager *manager,CLLocation *location))success;

/**
 *  失败定位
 *  @param error block
 */
- (void)errorDinwei:(void(^)(CLLocationManager *manager,NSError *error))error;

/**
 *  (地理编码)根据地名确定地理坐标
 *  @param address           地名
 *  @param completionHandler block
 */
+ (void)getCoordinateByAddress:(NSString *)address completionHandler:(void(^)(CLPlacemark *placemark,NSError *error))completionHandler;

/**
 *  反地理编码(根据坐标取得地名)
 *  @param location          坐标
 *  @param completionHandler block
 */
+ (void)getAddressByLatitude:(CLLocation *)location completionHandler:(void(^)(CLPlacemark *placemark,NSError *error))completionHandler;

/**
 *  计算两个坐标点的距离(系统自带方法)
 *  @param current   第一个点
 *  @param location2 第二个点
 *  @return 两个点的距离
 */
+ (CLLocationDistance)getDistanceWith:(CLLocation *)current location2:(CLLocation *)location2;


@end
