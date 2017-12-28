//
//  TYGBatteryInfo.m
//  SuperDemo
//
//  Created by 谈宇刚 on 2017/12/28.
//  Copyright © 2017年 TYG. All rights reserved.
//

#import "TYGBatteryInfo.h"
#import "TYGDeviceDataLibrery.h"

#include <objc/runtime.h>

@interface TYGBatteryInfo ()

@property (nonatomic, assign) BOOL batteryMonitoringEnabled;
@property (nonatomic, strong) void(^_batteryStatusUpdated)(TYGBatteryInfo *sender);//回调

@end

@implementation TYGBatteryInfo

+ (instancetype)sharedManager {
    static TYGBatteryInfo *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[TYGBatteryInfo alloc] init];
        _manager.status = @"Unknown";
    });
    return _manager;
}

//开始监测电池电量
- (void)startBatteryMonitoringCallback:(void(^)(TYGBatteryInfo *sender))batteryStatusUpdated{
    
    __batteryStatusUpdated = batteryStatusUpdated;
    
    if (!self.batteryMonitoringEnabled) {
        self.batteryMonitoringEnabled = YES;
        UIDevice *device = [UIDevice currentDevice];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_batteryLevelUpdatedCB:)
                                                     name:UIDeviceBatteryLevelDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_batteryStatusUpdatedCB:)
                                                     name:UIDeviceBatteryStateDidChangeNotification
                                                   object:nil];
        
        [device setBatteryMonitoringEnabled:YES];
        
        // If by any chance battery value is available - update it immediately
        if ([device batteryState] != UIDeviceBatteryStateUnknown) {
            [self _doUpdateBatteryStatus];
        }
    }
}

- (void)stopBatteryMonitoring {
    if (self.batteryMonitoringEnabled) {
        self.batteryMonitoringEnabled = NO;
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

// 获取精准电池电量(是通过 runtime 获取电池电量控件类私有变量的值，较为精确。)
+ (CGFloat)getCurrentBatteryLevel {
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        
        for (id aview in [status subviews]) {
            
            int batteryLevel = 0;
            
            for (id bview in [aview subviews]) {
                
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0) {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar) {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                        } else {
                            return 0;
                        }
                    }
                }
            }
        }
    }
    
    return 0;
}

- (void)setBatteryStatusUpdated:(void (^)(TYGBatteryInfo *))batteryStatusUpdated{
    __batteryStatusUpdated = batteryStatusUpdated;
}

#pragma mark - Private Method

- (void)_batteryLevelUpdatedCB:(NSNotification*)notification {
    [self _doUpdateBatteryStatus];
}

- (void)_batteryStatusUpdatedCB:(NSNotification*)notification {
    [self _doUpdateBatteryStatus];
}

- (void)_doUpdateBatteryStatus {
    float batteryMultiplier = [[UIDevice currentDevice] batteryLevel];
    self.levelPercent = batteryMultiplier * 100;
    self.levelMAH =  self.capacity * batteryMultiplier;
    
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateCharging:
            // UIDeviceBatteryStateFull seems to be overwritten by UIDeviceBatteryStateCharging
            // when charging therefore it's more reliable if we check the battery level here
            // explicitly.
            if (self.levelPercent == 100) {
                self.status = @"Fully charged";
            } else {
                self.status = @"Charging";
            }
            break;
        case UIDeviceBatteryStateFull:
            self.status = @"Fully charged";
            break;
        case UIDeviceBatteryStateUnplugged:
            self.status = @"Unplugged";
            break;
        case UIDeviceBatteryStateUnknown:
            self.status = @"Unknown";
            break;
    }
    
    if (__batteryStatusUpdated) {
        __batteryStatusUpdated(self);
    }
}

#pragma mark - Setters && Getters
- (CGFloat)voltage {
    return [[TYGDeviceDataLibrery sharedLibrery] getBatterVolocity];
}

- (NSUInteger)capacity {
    return [[TYGDeviceDataLibrery sharedLibrery] getBatteryCapacity];
}
@end
