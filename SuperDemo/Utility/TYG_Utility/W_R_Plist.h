//
//  W_R_Plist.h
//  2013002-­2
//
//  Created by  tanyg on 13-7-30.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
/**
 *  描述：文件的读写
 *  作者：谈宇刚
 *  日期：2013年8月18日
 *  版本：1.0
 */

#import <UIKit/UIKit.h>
@class SystemConfig;

@interface W_R_Plist : UIView


//写数据到文件
+ (BOOL)writeToFile:(NSString *)fileNmae data:(id)senderData;
//从文件中读取数据
+ (NSData *)readFromFile:(NSString *)fileNmae;

/**
 * 功能：获取文件路径
 * 参数：fileName--文件名 isCreat -- 当文件不存在时，是否创建
 */
+ (NSString *)getFilePath:(NSString *)filename isNotExistsCreatIt:(BOOL)isCreat;

@end


//功能：读写标准程序运行配置文件Root.plist当中的配置参数
@interface SystemConfig : NSObject

/**
 * 功能：获取配置文件Root.plist当中关键字key对应的值,如果配置文件Root当中无数据
 *      则从Config配置文件当中读取相关数据
 */
//+ (id)getObject:(NSString *)key;

/**
 * 功能：设置配置文件Config.plist当中key对应的值value
 */
+ (BOOL)setValue:(id)value key:(NSString *)key;
@end
