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
    [carDic setObject:carrierName forKey:@"carrierName"];
    [carDic setObject:mobileCountryCode forKey:@"mobileCountryCode"];
    [carDic setObject:mobileNetworkCode forKey:@"mobileNetworkCode"];
    [carDic setObject:isoCountryCode forKey:@"isoCountryCode"];
    [carDic setObject:allowsVOIP forKey:@"allowsVOIP"];
    
    return carDic;
}


/**
 获取当前网络的类型(ios7之后可以按照以下方式获取。方便而且类型多)

 @return 网络类型（3G，4G……）
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
         */
        return _telephonyInfo.currentRadioAccessTechnology;
    }
    
    return NULL;
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
            netname = @"Wifi";
            break;
        default:
            break;
    }
    return netname;
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
