//
//  Utility.h
//
/**
 *  描述：工具类接口文件
 *  作者：谈宇刚
 *  日期：2013年12月10日
 *  版本：1.1
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

@interface Utility : NSObject {
    
}

/*
 * 功能：检测网络连接状态
 */
+ (BOOL) connectedToNetwork;

/**
 * 检测一个网址是否可以正常访问
 */
+ (BOOL) hostAvailable: (NSString *) theHost;

/**
 * 去除两边的空格
 */
+ (NSString *)trimString:(NSString *)string;

/**
 * 提示窗口
 */
+ (void)MsgBox:(NSString *)msg;

/**
 *  提示窗口
 */
+ (void)MsgBox:(NSString *)msg subTitle:(NSString *)subTitle;

/**
 * 气泡式提示窗口
 */
+ (void)popMessage:(NSString *)msg;

/**
 * 获取view的controller
 */
+ (UIViewController *)getViewController:(UIView *)view;

/**
 * 获取当前时间
 */
+ (NSDate *)getThisTime;

/**
 * 转换时间(NSDate to NSString）
 */
+ (NSString *) getTimeFromDate:(NSDate *)currentDate;

/**
 * 从字符串@"1992-05-21 13:08:08"转换为时间
 */
+ (NSDate *) dateConvertDateFromString:(NSString*)uiDate;

/**
 * 解析新浪微博中的日期
 */
+ (NSString*)getTimeResolveSinaWeiboDate:(NSString*)date;

/**
 * 转换时间到当天零点或者最后一秒
 * @parma currentDate-传入的时间（e.g. 2014-05-09 18:06:59），timeType ? 0 : 1
 * @return 转化好的时间 2014-05-09 00:00:00 | 2014-05-09 23:59:59
 **/
+ (NSDate *)dateFromDate:(NSDate *)currentDate timeType:(NSInteger)timeType;

/**
 * 计算时间间隔，如：1小时前，1天前，1个月前，1年前
 * @parma paramStartDate,paramEndDate-传入的起止时间（e.g. 2014-05-09 18:06:59）
 * @return 字符串，如：1小时前，1天前，1个月前，1年前
 */
+ (NSString *)getTimeStrFromDate:(NSDate *)paramStartDate endDate:(NSDate*)paramEndDate;

/**
 * 获取指定文件的位置
 */
+ (NSString *) getFilePath:(NSString *)filename isNotExistsCreatIt:(BOOL) isCreat;

/*
 * 指定个一文件路径,此方法一般用在FMDB初始化数据库中
 */
+ (NSString *) getDBFilePath;

/**
 * 获取UUID
 */
+ (NSString *) getUUID;

/**
 *  汉字转拼音
 *  @param chinese 汉字
 *  @return 不带声调的拼音(多个汉字拼音间会带有空格)
 */
+ (NSString *) getPinyinFromChinese:(NSString *)chinese;

/**
 * 封装系统相关信息
 */
+ (NSMutableDictionary *) dictionaryAddJOSNHeader:(NSMutableDictionary *) dic;

/**
 * 安全的从字典中获取字符串
 */
+ (NSString *)safeGetValueFromDic:(NSDictionary *)dic key:(NSString *)key;

/**
 * 安全的从字典中获取对象
 */
+ (id)safeGetObjectFromDic:(NSDictionary *)dic key:(NSString *)key;

/*
 * 功能：安全加载视图控制器，当要加载的视图控制器A已存在时，会把A以上的视图控制器弹出，保留A,如果isRefresh = YES,A也弹出
 * 参数：flagViewController-要加载的视图控制器 isRefresh--是否更新已存在的视图控制器
 * 返回：
 */
+ (void)SafePushViewController:(UIViewController *)flagViewController isRefreshOldView:(BOOL) isRefresh;

/**
 * 将字典或者数组转化为JSON串
 */
+(NSString *) safeToJSON:(NSDictionary *) dic;

/**
 * 将服务器传输来的data数据转化为字典
 */
+(NSDictionary *)safeDataToDictionary:(NSData *)responseData;

/**
 *  获取随机颜色
 *  @return 随机颜色
 */
+(UIColor *)RandomColor;

/**
 *  生成随机数
 *  @param from 随机数左边界
 *  @param to   随机数右边界
 *  @return 边界内的随机数
 */
+(int)RandomNumber:(int)from to:(int)to;

@end
