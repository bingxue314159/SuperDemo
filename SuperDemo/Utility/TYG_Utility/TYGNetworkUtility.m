//
//  TYGNetworkUtility.m
//  SuperDemo
//
//  Created by 谈宇刚 on 16/6/17.
//  Copyright © 2016年 TYG. All rights reserved.
//

#import "TYGNetworkUtility.h"
#import <netdb.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>   //获取设备IP地址

#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation TYGNetworkUtility

/**
 * 功能：检测网络连接状态
 */
+(BOOL) connectedToNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    /**
     *  SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     *  SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     *  第一个参数可以为NULL或kCFAllocatorDefault
     *  第二个参数为需要测试连接的IP地址,当为0.0.0.0时则可以查询本机的网络连接状态.
     *  同时返回一个引用必须在用完后释放.
     *  PS: SCNetworkReachabilityCreateWithName: 这个是根据传入的网址测试连接,
     *  第二个参数比如为"www.apple.com",其他和上一个一样.
     *
     *  SCNetworkReachabilityGetFlags: 这个函数用来获得测试连接的状态,
     *  第一个参数为之前建立的测试连接的引用,
     *  第二个参数用来保存获得的状态,
     *  如果能获得状态则返回TRUE，否则返回FALSE
     *
     */
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    //根据获得的连接标志进行判断
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    
    //    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    //    BOOL mobilNet = flags & kSCNetworkReachabilityFlagsIsWWAN;//当前网络为蜂窝网络，即3G或者GPRS
    
    return (isReachable && !needsConnection) ? YES : NO;
}

// Direct from Apple. Thank you Apple
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
    if (!IPAddress || ![IPAddress length]) return NO;
    
    memset((char *) address, sizeof(struct sockaddr_in), 0);
    address->sin_family = AF_INET;
    address->sin_len = sizeof(struct sockaddr_in);
    
    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
    if (conversionResult == 0) {
        NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
        return NO;
    }
    
    return YES;
}

/**
 *  根据网址获取相应的IP
 *  @param theHost 网址,如：http://www.baidu.com
 *  @return IP
 */
+ (NSString *) getIPAddressForHost: (NSString *) theHost
{
    theHost=[theHost substringFromIndex:7];
    NSLog(@"%@",theHost);
    struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}

/** 检测一个网址是否可以正常访问 */
+ (BOOL) hostAvailable: (NSString *) theHost
{
    
    NSString *addressString = [self getIPAddressForHost:theHost];
    if (!addressString)
    {
        printf("Error recovering IP address from host name\n");
        return NO;
    }
    
    struct sockaddr_in address;
    BOOL gotAddress = [self addressFromString:addressString address:&address];
    
    if (!gotAddress)
    {
        printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
        return NO;
    }
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags =SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    return isReachable ? YES : NO;;
}

/**
 *  IP地址从二进制到符号的转化(for IPV6)
 */
+ (NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr{
    NSString *address = nil;
    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    if(inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    return address;
}

/**
 *  IP地址从二进制到符号的转化(for IPV4)
 */
+ (NSString *)formatIPV4Address:(struct in_addr)ipv4Addr{
    NSString *address = nil;
    char dstStr[INET_ADDRSTRLEN];
    char srcStr[INET_ADDRSTRLEN];
    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
    if(inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    return address;
}


#pragma mark WIFI相关
/**
 *  获取WiFi 信息
 *  返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
 *  e.g. { BSSID = "a4:2b:8c:c:7f:bd"; SSID = bdmy06; SSIDDATA = ;}
 *  @return NSDictionary
 */
+ (NSDictionary *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            // 这里其实对应的有三个key:kCNNetworkInfoKeySSID、kCNNetworkInfoKeyBSSID、kCNNetworkInfoKeySSIDData，
            //WiFiName = [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            //WiFiName = [info objectForKey:@"SSID"];
            break;
        }
    }
    return info;
}

/**
 *  获取广播地址、子网掩码、端口等
 *  { broadcast = "192.168.1.255"; interface = en0; localIp = "192.168.1.7"; etmask = "255.255.255.0"; }
 *  @return NSMutableDictionary
 */
+ (NSMutableDictionary *)getLocalInfoForCurrentWiFi {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    
                    //----192.168.1.255 广播地址
                    NSString *broadcast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    if (broadcast) {
                        [dict setObject:broadcast forKey:@"broadcast"];
                    }
                    NSLog(@"broadcast address--%@",broadcast);
                    
                    //--192.168.1.106 本机地址
                    NSString *localIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    if (localIp) {
                        [dict setObject:localIp forKey:@"localIp"];
                    }
                    NSLog(@"local device ip--%@",localIp);
                    
                    //--255.255.255.0 子网掩码地址
                    NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    if (netmask) {
                        [dict setObject:netmask forKey:@"netmask"];
                    }
                    NSLog(@"netmask--%@",netmask);
                    
                    //--en0 端口地址
                    NSString *interface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    if (interface) {
                        [dict setObject:interface forKey:@"interface"];
                    }
                    NSLog(@"interface--%@",interface);
                    return dict;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return dict;
}

/** 获取设备IP地址(WIFI) */
+ (NSString *)getLocalIPAddressForCurrentWiFi{
    
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
    }
    freeifaddrs(interfaces);
    
    return address;
}

@end
