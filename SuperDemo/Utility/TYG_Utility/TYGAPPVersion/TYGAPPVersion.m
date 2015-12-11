//
//  TYGAPPVersion.m
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/14.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//

#import "TYGAPPVersion.h"

//App版本号 e.g. 1.1.0
#define AppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//App build版本号 e.g. 1.1.0
#define AppBuildVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

@interface TYGAPPVersion ()<UIAlertViewDelegate>

@end

@implementation TYGAPPVersion

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 *  检测是否需要更新
 *  @return Bool
 */
- (BOOL)isNeedUpdate{
    
    BOOL flag = NO;
    NSString *serviceVersion = self.version;
    
    NSInteger result = [self compareAppVersion:AppVersion serviceVersion:serviceVersion];
    if (result == 1) {
        
        //需要更新
        flag = YES;
    }
    
    return flag;
}


/**
 *  版本比较
 *  @param appVersion     APP本地版本
 *  @param serviceVersion 服务器上的APP版本
 *  @return -1:appVersion > serviceVersion,0:版本相同,1:appVersion < serviceVersion
 */
- (NSInteger)compareAppVersion:(NSString *)appVersion serviceVersion:(NSString *)serviceVersion{
    
    NSMutableArray *appVersionArray = [NSMutableArray arrayWithArray:[appVersion componentsSeparatedByString:@"."]];
    NSMutableArray *serviceVersionArray = [NSMutableArray arrayWithArray:[serviceVersion componentsSeparatedByString:@"."]];
    
    while (serviceVersionArray.count < appVersionArray.count) {
        [serviceVersionArray addObject:@"0"];
    }
    
    while (serviceVersionArray.count > appVersionArray.count) {
        [appVersionArray addObject:@"0"];
    }
    
    NSInteger result = 0;
    for (int i = 0; i < appVersionArray.count; i++) {
        NSInteger appInt = [[appVersionArray objectAtIndex:i] integerValue];
        NSInteger serviceInt = [[serviceVersionArray objectAtIndex:i] integerValue];
        
        
        if (serviceInt > appInt) {
            //服务器版本大于本地版本
            result = 1;
            break;
        }
        else if (serviceInt < appInt){
            result = -1;
            break;
        }
        
    }
    
    return result;
}

/**
 *  执行升级
 */
- (void)updateApp{

    if ([self isNeedUpdate]) {
        
        //需要更新
        NSString *title = [NSString stringWithFormat:@"有新的版本(%@)",self.version];
        NSString *message = self.describe;
    
        
        if (self.isUpdate) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
            [alertView show];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            [alertView show];
        }
    }
    
}

/**
 *  检测是否是APP首次运行(更新安装或首次运行)
 *  @return Bool
 */
- (BOOL)isFirstRun{
    
    BOOL flag = NO;
    NSString *key = @"TYGAppVersion";
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *appVersion = [defaults stringForKey:key];

    if (nil == appVersion || appVersion.length == 0) {
        appVersion = @"0.0.0";
    }
    
    NSInteger result = [self compareAppVersion:appVersion serviceVersion:AppVersion];
    if (result == 1) {
        //更新安装或首次运行
        //更新版本号
        NSLog(@"首次运行,app版本为:%@",AppVersion);
        [defaults setValue:AppVersion forKey:key];
        [defaults synchronize];//这里建议同步存储到磁盘中，但是不是必须的
        
        flag = YES;
    }
    
    return flag;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([@"更新" isEqualToString:title]) {
        NSURL *appUrl = self.appUrl;
        //调用自带 浏览器 safari
        [[UIApplication sharedApplication] openURL:appUrl];
    }
}

@end
