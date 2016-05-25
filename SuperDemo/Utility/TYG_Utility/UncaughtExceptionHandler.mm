//
//  UncaughtExceptionHandler.m
//  2013002-­2
//
//  Created by  tanyg on 13-9-6.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

@implementation UncaughtExceptionHandler{
    BOOL dismissed;
}

+ (void)InstallUncaughtExceptionHandler
{
    //异常处理,将下面C函数的函数地址当做参数
    NSSetUncaughtExceptionHandler(&HandleException);
    
    //内存访问错误，重复释放等错误NSSetUncaughtExceptionHandler就无能为力了，因为这种错误它抛出的是Signal
    signal(SIGABRT, SignalHandler);//程序中止命令中止信号
    signal(SIGILL, SignalHandler);//程序非法指令信号
    signal(SIGSEGV, SignalHandler);//程序无效内存中止信号
    signal(SIGFPE, SignalHandler);//程序浮点异常信号
    signal(SIGBUS, SignalHandler);//程序内存字节未对齐中止信号
    signal(SIGPIPE, SignalHandler);//程序Socket发送失败中止信号
    
    /**
     * 信号处理函数可以通过 signal() 系统调用来设置。
     * 如果没有为一个信号设置对应的处理函数，就会使用默认的处理函数，否则信号就被进程截获并调用相应的处理函数。
     * 在没有处理函数的情况下，程序可以指定两种行为：忽略这个信号 SIG_IGN 或者用默认的处理函数 SIG_DFL 。
     * 但是有两个信号是无法被截获并处理的： SIGKILL、SIGSTOP 。
     *
     * Signal信号的类型
     SIGABRT--程序中止命令中止信号
     SIGALRM--程序超时信号
     SIGFPE--程序浮点异常信号
     SIGILL--程序非法指令信号
     SIGHUP--程序终端中止信号
     SIGINT--程序键盘中断信号
     SIGKILL--程序结束接收中止信号
     SIGTERM--程序kill中止信号
     SIGSTOP--程序键盘中止信号
     SIGSEGV--程序无效内存中止信号
     SIGBUS--程序内存字节未对齐中止信号
     SIGPIPE--程序Socket发送失败中止信号
     */
}

+ (void)unInstallUncaughtExceptionHandler
{
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

// 设置一个C函数，用来接收崩溃信息
void HandleException(NSException *exception){
    
    [[UncaughtExceptionHandler new] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
}

void SignalHandler(int signal){
    
    NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n" @"%@", nil), signal, getAppInfo()];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:reason userInfo:userInfo];
    
    [[UncaughtExceptionHandler new] performSelectorOnMainThread:@selector(handleException:) withObject:exception waitUntilDone:YES];
}

//处理异常信息
- (void)handleException:(NSException *)exception{
	
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"您可以尝试继续使用，但应用程序可能会不稳定.\n" @"%@\n%@", nil), [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"未处理的异常", nil)
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"退出应用程序", nil)
                                          otherButtonTitles:NSLocalizedString(@"继续使用", nil), nil];
	[alert show];
	
    
    //当接收到异常处理消息时，让程序开始runloop，防止程序死亡
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed) {
        //继续使用
		for (NSString *mode in (__bridge NSArray *)allModes) {
            
			CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
		}
	}
    
    
	//当点击弹出视图的取消按钮,isDimissed ＝ YES,上边的循环跳出
	CFRelease(allModes);
    [UncaughtExceptionHandler unInstallUncaughtExceptionHandler];
    
    //处理signal()捕获的异常
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else {
        
        [exception raise];
    }
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 0) {
        //退出
        dismissed = YES;
    }
    else{
        //继续使用
    }
}

//定义导常信息
NSString* getAppInfo() {
    
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUUID : %@\n",
                         
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         
                         [UIDevice currentDevice].model,
                         
                         [UIDevice currentDevice].systemName,
                         
                         [UIDevice currentDevice].systemVersion,
                         
                         [UIDevice currentDevice].identifierForVendor.UUIDString];
    
    NSLog(@"Crash!!!! %@", appInfo);
    
    return appInfo;
    
}

@end
