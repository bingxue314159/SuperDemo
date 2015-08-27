//
//  TYGDinwei.m
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/17.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//

#import "TYGDinwei.h"

@interface TYGDinwei ()<CLLocationManagerDelegate>{
    
    void(^_successDinwei)(CLLocationManager *manager,CLLocation *location);//成功回调
    void(^_errorDinwei)(CLLocationManager *manager,NSError *error);//失败回调

}

@end

@implementation TYGDinwei

- (instancetype)init
{
    self = [super init];
    if (self) {
        //定位管理器
        _locationManager = [[CLLocationManager alloc] init];
        //_locationManager.distanceFilter = 50.0f;//距离筛选器（距离上次报告的距离多少米之后再报告当前位置）
        _locationManager.distanceFilter = kCLDistanceFilterNone;//距离筛选器，单位米（移动多少米才回调更新）
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精确度
    }
    return self;
}

//初始化定位管理器
- (void)starDinWei{

    if (![CLLocationManager locationServicesEnabled]) {
        //定位功能不可用
        NSError *error = [NSError errorWithDomain:@"定位服务当前可能尚未打开，请设置打开！" code:0 userInfo:nil];
        _errorDinwei(_locationManager,error);
        return;
    }

    CLAuthorizationStatus authorStatus = [CLLocationManager authorizationStatus];
    //如果没有授权则请求用户授权
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    // iPhone OS SDK 8.0 以后版本的处理
    if (authorStatus == kCLAuthorizationStatusNotDetermined) {
        //用户尚未做出决定是否启用定位服务
        //使用此方法前在要在info.plist中配置NSLocationWhenInUseUsageDescription
        [_locationManager requestWhenInUseAuthorization];//iOS8
    }
    else if (authorStatus == kCLAuthorizationStatusAuthorizedWhenInUse || authorStatus == kCLAuthorizationStatusAuthorizedAlways){
        [self startUpdatingLocation];
    }
#else
    // iPhone OS SDK 8.0 之前版本的处理
    [self startUpdatingLocation];
#endif
#endif
    
}

//开始定位
- (void)startUpdatingLocation{

    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];//启动跟踪定位
}

//成功回调
- (void)successDinwei:(void(^)(CLLocationManager *manager,CLLocation *location))success{
    _successDinwei = success;
}

//失败回调
- (void)errorDinwei:(void(^)(CLLocationManager *manager,NSError *error))error{
    _errorDinwei = error;
}

#pragma mark - 火星经纬度换算

//WGS-84 到 GCJ-02 的转换
- (CLLocationCoordinate2D) locationTransWGSToGCJ:(CLLocationCoordinate2D) ccl2D{
    Location location = LocationMake(ccl2D.longitude, ccl2D.latitude);
    location = transformFromWGSToGCJ(location);
    
    ccl2D.longitude = location.lng;
    ccl2D.latitude = location.lat;
    
    return ccl2D;
}

//GCJ-02 坐标转换成 BD-09 坐标
- (CLLocationCoordinate2D) locationTransCGJToBD:(CLLocationCoordinate2D) ccl2D{
    Location location = LocationMake(ccl2D.longitude, ccl2D.latitude);
    location = bd_encrypt(location);
    
    ccl2D.longitude = location.lng;
    ccl2D.latitude = location.lat;
    
    return ccl2D;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);

    self.cll2D_WGS_84 = coordinate;
    //火星经纬度换算WGS-84 到 GCJ-02 的转换
    coordinate = [self locationTransWGSToGCJ:coordinate];
    self.cll2D_GCJ_02 = coordinate;
    //GCJ-02 坐标转换成 BD-09 坐标
    coordinate = [self locationTransCGJToBD:coordinate];
    self.cll2D_DB_09 = coordinate;
    
    _successDinwei(manager,location);
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    
    
    NSString *errMsg = @"定位服务不可用，请确保当前设备支持定位服务！";
    if ([error domain] == kCLErrorDomain)
    {
        switch ([error code])
        {
            case kCLErrorDenied:{
                //定位时进入这个错误分支就是定位服务未开启
                //如果没有正在进行定位 可以用这个
                CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
                if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
                    //kCLAuthorizationStatusDenied:用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
                    //kCLAuthorizationStatusRestricted:没有获得用户授权使用定位服务,可能用户没有自己禁止访问授权

                    errMsg = @"定位服务不可用，请前往 设置-->隐私-->定位服务 对本应用进行授权";
                }
                else if (status == kCLAuthorizationStatusNotDetermined){
                    //用户尚未做出决定是否启用定位服务
                    errMsg = @"定位服务不可用，请前往 设置-->隐私-->定位服务 对本应用进行授权";
                }
                break;
            }
                
        }
    }

    NSError *error2 = [NSError errorWithDomain:errMsg code:[error code] userInfo:[error userInfo]];
    _errorDinwei(manager,error2);
}

#pragma mark - 地理编码
//(地理编码)根据地名确定地理坐标
+ (void)getCoordinateByAddress:(NSString *)address completionHandler:(void(^)(CLPlacemark *placemark,NSError *error))completionHandler{
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];

    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        completionHandler(placemark,error);
        
        /*
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
        
        NSString *name=placemark.name;//地名
        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        NSString *country=placemark.country; //国家
        NSString *administrativeArea=placemark.administrativeArea; // 州
        NSString *locality=placemark.locality; // 城市
        NSString *thoroughfare=placemark.thoroughfare;//街道
        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如:门牌 等
        
        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        NSString *postalCode=placemark.postalCode; //邮编
        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        NSString *ocean=placemark.ocean; // 海洋
        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        */
    }];
}

//反地理编码(根据坐标取得地名)
+ (void)getAddressByLatitude:(CLLocation *)location completionHandler:(void(^)(CLPlacemark *placemark,NSError *error))completionHandler{

    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        completionHandler(placemark,error);
    }];
}

/**
 *  计算两个坐标点的距离(系统自带方法)
 *  @param current   第一个点
 *  @param location2 第二个点
 *  @return 两个点的距离
 */
+ (CLLocationDistance)getDistanceWith:(CLLocation *)current location2:(CLLocation *)location2{

//    CLLocation *current=[[CLLocation alloc] initWithLatitude:32.178722 longitude:119.508619];

    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:location2];
    return meters;
}




@end
