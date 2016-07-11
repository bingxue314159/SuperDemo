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
 *
 *  版本：1.0  日期：2013年08月18日  初始创建
 *  版本：1.1  日期：2016年01月18日  增加各种配置文件的读写
 */

#import <UIKit/UIKit.h>
@class SystemConfig;

//获取temp
#define TYGPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define TYGPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define TYGPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface W_R_Plist : UIView

/**
 *  写数据到Documents下的文件
 *  @param fileNmae   文件名
 *  @param senderData 数据
 *  @return Bool
 */
+ (BOOL)writeToFile:(NSString *)fileNmae data:(id)senderData;

/**
 *  从Documents下的文件中读取数据
 *  @param fileNmae 文件名
 *  @return 读取的数据
 */
+ (NSData *)readFromFile:(NSString *)fileNmae;

/**
 *  获取Documents下的文件路径
 *  @param filename 文件名
 *  @param isCreat  当文件不存在时，是否创建
 *  @return 文件路径
 */
+ (NSString *)getFilePath:(NSString *)filename isNotExistsCreatIt:(BOOL)isCreat;

/**
 *  设置禁止指定文件云同步
 *  @param URL 文件路径
 *  @return Bool
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end


//////////////////////////////////////////////////////////
// 功能：读写标准程序运行配置文件当中的配置参数
//////////////////////////////////////////////////////////
@interface SystemConfig : NSObject

/**
 *  写入Setting的值到NSUserDefaults
 *  注册默认设置，如果值已经存在，不会更改已存在的值，如果要更改，用setObject:forKey:
 */
+ (void)SettingsBundleRegisterDefaults;

/**
 *  获取Setting的值
 *  @param key key(对应的Identifier)
 *  @return value
 */
+ (id)SettingsBundleGetObject:(NSString *)key;

/**
 *  获取Config.plist的值
 *  @param key key
 *  @return value
 */
+ (id)ConfigPlistGetObject:(NSString *)key;

/**
 *  设置Config.plist的值
 *  @param value value
 *  @param key   key
 *  @return 是否成功保存
 */
+ (BOOL)ConfigPlistSetValue:(id)value key:(NSString *)key;

/**
 * 功能：获取NSUserDefaults当中关键字key对应的值
 */
+ (id)getObject:(NSString *)key;

/**
 * 功能：设置配置文件Config.plist当中key对应的值value
 */
+ (BOOL)setValue:(id)value key:(NSString *)key;

@end
