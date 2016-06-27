//
//  TYGFileManager.m
//  SuperDemo
//
//  Created by 谈宇刚 on 16/6/27.
//  Copyright © 2016年 TYG. All rights reserved.
//

#import "TYGFileManager.h"

@implementation TYGFileManager


/** 磁盘总空间 */
+(CGFloat)diskOfAllSizeMBytes{

    CGFloat size = 0.0;
    
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"ERROR:%@",error.localizedDescription);
#endif
    }
    else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024.0/1024.0;
    }

    return size;
}

/** 获取磁盘可用空间大小 */
+ (CGFloat)diskOfFreeSizeMBytes{
    
    CGFloat size = 0.0;
    
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"ERROR:%@",error.localizedDescription);
#endif
    }
    else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024.0/1024.0;
    }
    
    return size;
}

/** 获取指定路径下某个文件的大小 */
+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        return 0;
    }
    
   return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}

/** 获取文件夹下所有文件的大小 */
+ (long long)folderSizeAtPath:(NSString *)folderPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSString *fileName;
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    long long folderSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:filePath];
    }
    
    return folderSize;
}

@end
