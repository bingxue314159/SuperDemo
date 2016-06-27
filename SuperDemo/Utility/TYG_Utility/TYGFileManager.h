//
//  TYGFileManager.h
//  SuperDemo
//
//  Created by 谈宇刚 on 16/6/27.
//  Copyright © 2016年 TYG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYGFileManager : NSObject

/** 磁盘总空间 */
+(CGFloat)diskOfAllSizeMBytes;

/** 获取磁盘可用空间大小 */
+ (CGFloat)diskOfFreeSizeMBytes;

/** 获取指定路径下某个文件的大小 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

/** 获取文件夹下所有文件的大小 */
+ (long long)folderSizeAtPath:(NSString *)folderPath;

@end
