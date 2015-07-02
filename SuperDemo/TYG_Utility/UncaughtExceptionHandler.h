//
//  UncaughtExceptionHandler.h
//  2013002-­2
//
//  Created by  tanyg on 13-9-6.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
/*
 * 功能：全局崩溃监控，防止意外崩溃
 * 使用方法：在AppDelegate 调用InstallUncaughtExceptionHandler()
 *
 */

#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject

+ (void)InstallUncaughtExceptionHandler;
+ (void)unInstallUncaughtExceptionHandler;

@end




