//
//  TYGConfig.h
//  AutomobileMarket
//
//  Created by tanyugang on 15/4/16.
//  Copyright (c) 2015年 YDAPP. All rights reserved.
//

/**
 *  配置各种参数
 */

#ifndef AutomobileMarket_TYGConfig_h
#define AutomobileMarket_TYGConfig_h

#define tygConfing_ApiUrl @"http://111.75.167.167:11000/api/api.action"    //接口
#define tygConfing_PicUrl @"http://111.75.167.167:11000/"  //图片接口
#define tygConfing_YDApiUrl @"http://223.82.246.237:8080/ivhs/"    //移动接口（意见反馈）
#define tygConfing_YDJtxms @"http://211.138.208.187:9005/JX_BOSS/BUSIAction.action"    //移动接口（交通小秘书）
#define tygConfing_UMAppKey @"5518db52fd98c59442000763"    //友盟KEY
#define tygConfing_BaiduAppKey @"FQunv0ack7XrYKFXgc1lQmCc" //百度地图KEY

//====================缓存有效时间(秒)==============================
#define tygCacheTime_cityArea 24*60*60  //所支持的城市
#define tygCacheTime_couponModels 24*60*60  //代金券模板

//缓存有效时间(秒) -- 以下缓存时间最好都一致
#define tygCacheTime_saleStore 24*60*60 //服务项
#define tygCacheTime_saleStoreTypes 24*60*60 //服务项类型
#define tygCacheTime_saleServers 24*60*60   //服务子项
#define tygCacheTime_saleServiceTypes 24*60*60  //服务子项类型
#define tygCacheTime_queryCount 24*60*60    //统计信息

//===================定义是否及时更新缓存===============================
#define tygCacheIsUpdate_cityArea NO  //所支持的城市
#define tygCacheIsUpdate_couponModels YES  //代金券模板
#define tygCacheIsUpdate_saleStore YES //服务项
#define tygCacheIsUpdate_saleStoreTypes NO //服务项类型
#define tygCacheIsUpdate_saleServers YES   //服务子项
#define tygCacheIsUpdate_saleServiceTypes NO  //服务子项类型
#define tygCacheIsUpdate_queryCount YES    //统计信息

#endif
