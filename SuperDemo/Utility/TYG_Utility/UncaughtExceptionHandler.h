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
 * 整个工程中至少有一个.mm文件
 * 注意：
 * 不能与第三方崩溃统计工具一起使用，如：友盟统计、BugHD等
 */

#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject

+ (void)InstallUncaughtExceptionHandler;
+ (void)unInstallUncaughtExceptionHandler;

@end




