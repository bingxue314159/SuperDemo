//
//  W_R_Plist.m
//  2013002-­2
//
//  Created by  tanyg on 13-7-30.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "W_R_Plist.h"

@implementation W_R_Plist

/**
 *  写数据到Documents下的文件
 *  @param fileNmae   文件名
 *  @param senderData 数据
 *  @return Bool
 */
+ (BOOL)writeToFile:(NSString *)fileNmae data:(id)senderData {
    BOOL flag = NO;
    
    NSString *filePath = [W_R_Plist getFilePath:fileNmae isNotExistsCreatIt:YES];
    
    if ([senderData isKindOfClass:[NSString class]]) {
        flag = [senderData writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    else{
        flag = [senderData writeToFile:filePath atomically:YES];
    }
    
    return flag;
}

/**
 *  从Documents下的文件中读取数据
 *  @param fileNmae 文件名
 *  @return 读取的数据
 */
+ (NSData *)readFromFile:(NSString *)fileNmae{
    
    if(fileNmae==nil||fileNmae==NULL) return nil;
    
    NSString *filePath = [W_R_Plist getFilePath:fileNmae isNotExistsCreatIt:NO];
    
    if (filePath){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return data;
        
    }else{
        //文件不存在
        return nil;
    }
    return nil;
}

/**
 *  获取Documents下的文件路径
 *  @param filename 文件名
 *  @param isCreat  当文件不存在时，是否创建
 *  @return 文件路径
 */
+ (NSString *) getFilePath:(NSString *)filename isNotExistsCreatIt:(BOOL)isCreat{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [rootPath stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath] && isCreat) {
        //如果文件不存在，且isCreat==YES
        BOOL flag = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (flag) {
            return filePath;
        }
        else{
            NSLog(@"创建文件%@失败",filename);
        }
    }
    else{
        return filePath;
    }
    return nil;
}

//设置禁止所有文件云同步
-(void)addNotBackUpiCloud{
    
    //Document
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    [self fileList:docPath];
    
    //Library
    NSArray *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [libPaths objectAtIndex:0];
    [self fileList:libPath];
}

- (void)fileList:(NSString*)directory{
    
    NSError *error = nil;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:directory error:&error];
    
    for (NSString* each in fileList) {
        
        NSMutableString* path = [[NSMutableString alloc]initWithString:directory];
        
        [path appendFormat:@"/%@",each];
        NSURL *filePath = [NSURL fileURLWithPath:path];
        
        [W_R_Plist addSkipBackupAttributeToItemAtURL:filePath];
        
        [self fileList:path];
        
    }
    
}

/**
 *  设置禁止指定文件云同步
 *  @param URL 文件路径
 *  @return Bool
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    
    //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    if (![[NSFileManager defaultManager] fileExistsAtPath: [URL path]]) {
        return NO;
    }
    else if (nil == URL){
        return NO;
    }
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end


//////////////////////////////////////////////////////////
// 功能：读写标准程序运行配置文件当中的配置参数
//////////////////////////////////////////////////////////
@implementation SystemConfig

/**
 *  写入Setting的值到NSUserDefaults
 *  注册默认设置，如果值已经存在，不会更改已存在的值，如果要更改，用setObject:forKey:
 */
+ (void)SettingsBundleRegisterDefaults{
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for(NSDictionary *prefSpecification in preferences) {
        
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];//注册默认设置，如果值已经存在，不会更改已存在的值，如果要更改，用setObject:forKey:
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获取Setting的值
 *  @param key key(对应的Identifier)
 *  @return value
 */
+ (id)SettingsBundleGetObject:(NSString *)key{
    
    id rtn = [self getObject:key];
    
    return rtn;
}

/**
 *  获取Config.plist的值
 *  @param key key
 *  @return value
 */
+ (id)ConfigPlistGetObject:(NSString *)key{
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    id rtn = [dic valueForKey:key];
    if ([[NSNull null] isEqual:rtn]) {
        rtn = nil;
    }
    
    NSLog(@"读取Config.plist文件：%@=%@",key,rtn);
    
    return rtn;
}

/**
 *  设置Config.plist的值
 *  @param value value
 *  @param key   key
 *  @return 是否成功保存
 */
+ (BOOL)ConfigPlistSetValue:(id)value key:(NSString *)key{
    BOOL flag = NO;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    if (path) {
        NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
        [dic setObject:value forKey:key];
        
        flag = [dic writeToFile:path atomically:YES];
        
        NSLog(@"写Config.plist文件：%@=%@",key,value);
    }
    else{
        NSLog(@"写值到配置文件Config.plist时出错,Config.plist文件不存在");
    }
    
    return flag;
}

/**
 * 功能：获取NSUserDefaults当中关键字key对应的值
 */
+ (id)getObject:(NSString *)key{
    //读取Settings.bundle里面的Root.plist
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    id rtn=[defaults objectForKey:key];
    
    NSLog(@"读取NSUserDefaults文件：%@=%@",key,rtn);
    
	return rtn;
}

/**
 * 功能：设置配置文件Config.plist当中key对应的值value
 */
+ (BOOL)setValue:(id)value key:(NSString *)key{
    
    BOOL flag = NO;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    
    NSLog(@"写NSUserDefaults文件：%@=%@",key,value);
    //这里建议同步存储到磁盘中，但是不是必须的
    flag = [defaults synchronize];
    
    return flag;
}

@end
