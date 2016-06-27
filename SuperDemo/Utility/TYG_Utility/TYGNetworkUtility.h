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

@end
