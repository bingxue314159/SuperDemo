//
//  TYGNetworkUtility.h
//  SuperDemo
//
//  Created by 谈宇刚 on 16/6/17.
//  Copyright © 2016年 TYG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYGNetworkUtility : NSObject

/*
 * 功能：检测网络连接状态
 */
+ (BOOL) connectedToNetwork;

/**
 * 检测一个网址是否可以正常访问
 */
+ (BOOL) hostAvailable: (NSString *) theHost;

/**
 *  获取WiFi 信息
 *  返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
 *  e.g. { BSSID = "a4:2b:8c:c:7f:bd"; SSID = bdmy06; SSIDDATA = ;}
 *  @return NSDictionary
 */
+ (NSDictionary *)fetchSSIDInfo;

/**
 *  获取广播地址、子网掩码、端口等
 *  { broadcast = "192.168.1.255"; interface = en0; localIp = "192.168.1.7"; etmask = "255.255.255.0"; }
 *  @return NSMutableDictionary
 */
+ (NSMutableDictionary *)getLocalInfoForCurrentWiFi;

@end
