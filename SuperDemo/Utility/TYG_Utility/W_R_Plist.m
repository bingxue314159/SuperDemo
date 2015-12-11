//
//  W_R_Plist.m
//  2013002-­2
//
//  Created by  tanyg on 13-7-30.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "W_R_Plist.h"

@implementation W_R_Plist

//写数据到文件
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

//从文件中读取数据
+ (NSData *)readFromFile:(NSString *)fileNmae{
    
    if(fileNmae==nil||fileNmae==NULL) return nil;
    
//    NSArray* arr=[fileNmae componentsSeparatedByString:@"."];
//    NSString* name=[arr objectAtIndex:0];
//    NSString* type=[arr objectAtIndex:1];
//    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
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
 * 功能：获取文件路径
 * 参数：fileName--文件名 isCreat -- 当文件不存在时，是否创建
 */
+ (NSString *) getFilePath:(NSString *)filename isNotExistsCreatIt:(BOOL)isCreat{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [rootPath stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        if (isCreat) {
            BOOL flag = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
            if (flag) {
                return filePath;
            }
        }
    }
    else{
        return filePath;
    }
    return nil;
}

@end


//////////////////////////////////////////////////////////
// 1 、功能：读写标准程序运行配置文件Root.plist当中的配置参数
//////////////////////////////////////////////////////////
@implementation SystemConfig

/**
 * 功能：获取配置文件Root.plist当中关键字key对应的值,如果配置文件Root当中无数据
 *      则从Config配置文件当中读取相关数据
 */
+ (id)getObject:(NSString *)key{
    //读取Settings.bundle里面的Root.plist
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    id rtn=[defaults stringForKey:key];
    
    //如果rtn为空，则从其他配置文件当中读取相关信息
    //    if ([rtn length] == 0) {
    //        NSString *path=[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    //        NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    //        
    //        rtn=[dic valueForKey:key];
    //        if ([[NSNull null] isEqual:rtn]) {
    //            rtn = nil;
    //        }
    //    }
    
    NSLog(@"读取配置文件：%@=%@",key,rtn);
    
	return rtn;
}

/**
 * 功能：设置配置文件Config.plist当中key对应的值value
 */
+ (BOOL)setValue:(id)value key:(NSString *)key{
    /*
     BOOL flag = NO;
     @try {
     NSString *path=[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
     NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
     [dic setObject:value forKey:key];
     
     if ([dic writeToFile:path atomically:YES]) {
     flag = YES;
     }
     }
     @catch (NSException *exception) {
     flag = NO;
     NSLog(@"写值到配置文件Config.plist时出错 error = %@",exception);
     }
     @finally {
     
     }
     
     return flag;
     */
    
    BOOL flag = NO;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    
    //这里建议同步存储到磁盘中，但是不是必须的
    flag = [defaults synchronize];
    
    return flag;
}

@end
