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

@implementation UncaughtExceptionHandler{
    BOOL dismissed;
}

+ (void)InstallUncaughtExceptionHandler
{
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
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


void HandleException(NSException *exception){
    
    [[UncaughtExceptionHandler new] performSelectorOnMainThread:@selector(handleException:) withObject:nil waitUntilDone:YES];
}

void SignalHandler(int signal){
    [[UncaughtExceptionHandler new] performSelectorOnMainThread:@selector(handleException:) withObject:nil waitUntilDone:YES];
}

- (void)handleException:(NSException *)exception
{
	
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"您可以尝试继续使用，但应用程序可能会不稳定.", nil)];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"未处理的异常", nil)
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"退出应用程序", nil)
                                          otherButtonTitles:NSLocalizedString(@"继续使用", nil), nil];
	[alert show];
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed)
	{
		for (NSString *mode in (__bridge NSArray *)allModes)
		{
			CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);
    
    [UncaughtExceptionHandler unInstallUncaughtExceptionHandler];
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

@end
