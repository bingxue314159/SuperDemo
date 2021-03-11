//
//  TYGSimInfo.m
//  SuperDemo
//
//  Created by 谈宇刚 on 2018/1/8.
//  Copyright © 2018年 TYG. All rights reserved.
//

#import "TYGSimInfo.h"
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#define SAFE_STRING(str) ([[NSNull null] isEqual:str] ? @"" : (([(str) length] ? (str) : @"")))

//判断当前设备是否为刘海屏幕
#define isLiuhaiScreen ({\
BOOL isBangsScreen = NO; \
if (@available(iOS 11.0, *)) { \
UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
isBangsScreen = window.safeAreaInsets.bottom > 0; \
} \
isBangsScreen; \
})

@interface TYGSimInfo()

@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyInfo;

@end

@implementation TYGSimInfo

+ (instancetype)sharedManager {
    static TYGSimInfo *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[TYGSimInfo alloc] init];
        _manager.telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    });
    return _manager;
}

/**
 获取sim卡信息
 
 @return NSDictionary
 */
- (NSDictionary *)getcarrierInfo{
    
    CTCarrier *carrier = [_telephonyInfo subscriberCellularProvider];
    NSString *carrierName = [carrier carrierName];  //供应商名称（中国联通 中国移动）
    NSString *mobileCountryCode = carrier.mobileCountryCode; //所在国家编号(MCC)
    NSString *mobileNetworkCode = carrier.mobileNetworkCode; //供应商网络编号(MNC)
    NSString *isoCountryCode = carrier.isoCountryCode;//isoCountryCode
    NSString *allowsVOIP = carrier.allowsVOIP ? @"YES" : @"NO"; //是否允许voip
    
    NSLog(@"carrier:%@", [carrier description]);
    
    NSMutableDictionary *carDic = [NSMutableDictionary dictionaryWithCapacity:5];
    [carDic setObject:SAFE_STRING(carrierName) forKey:@"carrierName"];
    [carDic setObject:SAFE_STRING(mobileCountryCode) forKey:@"mobileCountryCode"];
    [carDic setObject:SAFE_STRING(mobileNetworkCode) forKey:@"mobileNetworkCode"];
    [carDic setObject:SAFE_STRING(isoCountryCode) forKey:@"isoCountryCode"];
    [carDic setObject:SAFE_STRING(allowsVOIP) forKey:@"allowsVOIP"];
    
    return carDic;
}


/**
 获取当前网络的类型(ios7之后可以按照以下方式获取。方便而且类型多)
 
 @return 网络类型（CTRadioAccessTechnologyGPRS，CTRadioAccessTechnologyWCDMA……）
 */
- (NSString *)getCurrentRadioAccessTechnology{
    
    if ([CTTelephonyNetworkInfo instancesRespondToSelector:@selector(currentRadioAccessTechnology)]) {
        /*
         CTRadioAccessTechnologyGPRS         //介于2G和3G之间，也叫2.5G ,过度技术
         CTRadioAccessTechnologyEdge         //EDGE为GPRS到第三代移动通信的过渡，EDGE俗称2.75G
         CTRadioAccessTechnologyWCDMA
         CTRadioAccessTechnologyHSDPA            //亦称为3.5G(3?G)
         CTRadioAccessTechnologyHSUPA            //3G到4G的过度技术
         CTRadioAccessTechnologyCDMA1x       //3G
         CTRadioAccessTechnologyCDMAEVDORev0    //3G标准
         CTRadioAccessTechnologyCDMAEVDORevA
         CTRadioAccessTechnologyCDMAEVDORevB
         CTRadioAccessTechnologyeHRPD        //电信使用的一种3G到4G的演进技术， 3.75G
         CTRadioAccessTechnologyLTE          //接近4G
         CTRadioAccessTechnologyNRNSA       //NR的非独立组网（NSA）模式@available(iOS 14.0, *)
         CTRadioAccessTechnologyNR          //新无线(5G)@available(iOS 14.0, *)
         */
        return _telephonyInfo.currentRadioAccessTechnology;
    }
    
    return NULL;
}


/**
 获取当前网络的类型(ios7之后可以按照以下方式获取。方便而且类型多)
 
 @return 网络类型（3G，4G……）
 */
+ (NSString *)getCurrentRadioAccessTechnologyName{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    NSString *currentNet = @"";
    
    if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
        currentNet = @"GPRS";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
        currentNet = @"2.75G EDGE";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]){
        currentNet = @"3.5G HSDPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]){
        currentNet = @"3.5G HSUPA";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        currentNet = @"2G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
        currentNet = @"3G";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]){
        currentNet = @"HRPD";
    }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        currentNet = @"4G";
    }else if (@available(iOS 14.0, *)) {
        if ([currentStatus isEqualToString:CTRadioAccessTechnologyNRNSA]){
            currentNet = @"5G NSA";
        }else if ([currentStatus isEqualToString:CTRadioAccessTechnologyNR]){
            currentNet = @"5G";
        }
    }
    return currentNet;
}


/**
 获取网络环境
 */
+ (NSString *)networktype {
    NSArray * subviews = [[[[UIApplication sharedApplication] valueForKey: @ "statusBar"] valueForKey: @ "foregroundView"] subviews];
    NSNumber * dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if ([subview isKindOfClass: [NSClassFromString(@ "UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSString *netname = @"";
    switch ([[dataNetworkItemView valueForKey: @ "dataNetworkType"] integerValue]) {
        case 0:
            netname = @"No wifi or cellular";
            break;
        case 1:
            netname = @"2G";
            break;
        case 2:
            netname = @"3G";
            break;
        case 3:
            netname = @"4G";
            break;
        case 4:
            netname = @"LTE";
            break;
        case 5:
            netname = @"WIFI";
            break;
        default:
            break;
    }
    return netname;
}


/// iOS获取设备的网络状态(已适配iOS13,iOS14无变化)
+ (NSString *)getNetworkType {
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = nil;
    //    判断是否是iOS 13
    NSString *network = @"";
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                statusBar = [localStatusBar performSelector:@selector(statusBar)];
            }
        }
        
        #pragma clang diagnostic pop
        if (statusBar) {
            //            UIStatusBarDataCellularEntry
            id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                //                If wifiEntry is enabled, is WiFi.
                network = @"WIFI";
            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                if (type) {
                    switch (type.integerValue) {
                        case 0:
                            //                            无sim卡
                            network = @"NONE";
                            break;
                        case 1:
                            network = @"1G";
                            break;
                        case 4:
                            network = @"3G";
                            break;
                        case 5:
                            network = @"4G";
                            break;
                        default:
                            //                            默认WWAN类型
                            network = @"WWAN";
                            break;
                    }
                }
            }
        }
    }else {
        statusBar = [app valueForKeyPath:@"statusBar"];
        
        if (isLiuhaiScreen) {
            //            刘海屏
            id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
            UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
            NSArray *subviews = [[foregroundView subviews][2] subviews];
            
            if (subviews.count == 0) {
                //                    iOS 12
                id currentData = [statusBarView valueForKeyPath:@"currentData"];
                id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
                    network = @"WIFI";
                }else {
                    //                    卡1:
                    id cellularEntry = [currentData valueForKey:@"cellularEntry"];
                    //                    卡2:
                    id secondaryCellularEntry = [currentData valueForKey:@"secondaryCellularEntry"];
                    
                    if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
                        //                            无卡情况
                        network = @"NONE";
                    }else {
                        //                            判断卡1还是卡2
                        BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
                        int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
                        switch (networkType) {
                            case 0://无服务
                                network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
                                break;
                            case 3:
                                network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
                                break;
                            case 4:
                                network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
                                break;
                            case 5:
                                network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
                                break;
                            default:
                                break;
                        }
                        
                    }
                }
                
            }else {
                
                for (id subview in subviews) {
                    if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                        network = @"WIFI";
                    }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                        network = [subview valueForKeyPath:@"originalText"];
                    }
                }
            }
            
        }else {
            // 非刘海屏
            UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
            NSArray *subviews = [foregroundView subviews];
            
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                    int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                    switch (networkType) {
                        case 0:
                            network = @"NONE";
                            break;
                        case 1:
                            network = @"2G";
                            break;
                        case 2:
                            network = @"3G";
                            break;
                        case 3:
                            network = @"4G";
                            break;
                        case 5:
                            network = @"WIFI";
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
    
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}


- (void)test{
    //1.当sim卡更换时弹出此窗口
    //2.当你的 iPhone 漫游到了其他网路的时候，就会执行你这段 block
    _telephonyInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"carrier:%@", [carrier description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Sim card changed" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [alert show];
        });
    };
    
    //CTCallCenter 的用途是用来监控是不是有电话打进来、正在接听、或是已经挂断
    //而 CTCall 则是将每一则通话事件包装成一个物件
    CTCallCenter *center = [[CTCallCenter alloc] init];
    center.callEventHandler = ^(CTCall *call) {
        NSLog(@"call:%@", [call description]);
    };
}

@end
