//
//  TYGAPPVersion.h
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/14.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//
/**
 *  APP升级、检测与更新
 *  服务器目前保存的最新版本的版本信息
 */

#import <UIKit/UIKit.h>

@interface TYGAPPVersion : NSObject

@property (nonatomic,assign) NSInteger id_appVersion;//id
@property (nonatomic,strong) NSString *version;//版本号
@property (nonatomic,strong) NSString *versionCount;//升级次数
@property (nonatomic,strong) NSString *describe;//升级说明
@property (nonatomic,assign) BOOL isUpdate;//是否强制更新
@property (nonatomic,strong) NSURL *appUrl;//APP下载地址
@property (nonatomic,strong) NSString *remark;//app标记名称
@property (nonatomic,strong) NSString *remark1;//
@property (nonatomic,strong) NSString *remark2;//

/**
 *  检测是否需要更新
 *  @return Bool
 */
- (BOOL)isNeedUpdate;

/**
 *  执行升级（可直接调用此方法，内容已经做了相应的检测）
 */
- (void)updateApp;

/**
 *  检测是否是APP首次运行(更新安装或首次运行)
 *  @return Bool
 */
- (BOOL)isFirstRun;

@end
