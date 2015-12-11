//
//  LocationTrans.m
//  2013002-­2
//
//  Created by  tanyg on 13-10-8.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "LocationTrans.h"

@implementation LocationTrans

Location LocationMake(double lng, double lat) {
    Location loc;
    loc.lng = lng;
    loc.lat = lat;
    
    return loc;
}

///
///  WGS-84 到 GCJ-02 的转换
///

const double pi = 3.14159265358979324;

//
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

Location transformFromWGSToGCJ(Location wgLoc)
{
    Location mgLoc;
    if (outOfChina(wgLoc.lat, wgLoc.lng))
    {
        mgLoc = wgLoc;
        return mgLoc;
    }
    double dLat = transformLat(wgLoc.lng - 105.0, wgLoc.lat - 35.0);
    double dLon = transformLon(wgLoc.lng - 105.0, wgLoc.lat - 35.0);
    double radLat = wgLoc.lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    mgLoc.lat = wgLoc.lat + dLat;
    mgLoc.lng = wgLoc.lng + dLon;
    
    return mgLoc;
}

bool outOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

///
///  GCJ-02 坐标转换成 BD-09 坐标
///

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
Location bd_encrypt(Location gcLoc)
{
    double x = gcLoc.lng, y = gcLoc.lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    return LocationMake(z * cos(theta) + 0.0065, z * sin(theta) + 0.006);
}

///
///   BD-09 坐标转换成 GCJ-02坐标
///
///
Location bd_decrypt(Location bdLoc)
{
    double x = bdLoc.lng - 0.0065, y = bdLoc.lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    return LocationMake(z * cos(theta), z * sin(theta));
}

@end
