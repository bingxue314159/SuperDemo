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

@interface Utility : NSObject

/**
 * 获取设备硬件型号，如:iPod1.1,iPhone4.3
 */
+ (NSString *)getModel;

/**
 * 获取设备硬件名称，如iPhone 4,iPad mini2
 */
+ (NSString*)deviceName;

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
 * 获取当前时间
 */
+ (NSDate *)getThisTime;

/**
 * 转换时间(NSDate to NSString）
 */
+ (NSString *) getTimeFromDate:(NSDate *)currentDate;

/**
 *  从字符串转换为时间
 *  @param uiDate 输入的日期字符串形如：@"1992-05-21 13:08:08"
 *  @return NSDate
 */
//+ (NSDate *) dateConvertDateFromString:(NSString*)uiDate;

/**
 * 解析新浪微博中的日期,@"EEE MMM d HH:mm:ss Z yyyy"
 */
+ (NSString*)getTimeResolveSinaWeiboDate:(NSString*)date;

/**
 * 计算时间间隔，如：1小时前，1天前，1个月前，1年前
 * @parma paramStartDate,paramEndDate-传入的起止时间（e.g. 2014-05-09 18:06:59）
 * @return 字符串，如：1小时前，1天前，1个月前，1年前
 */
+ (NSString *)getTimeStrFromDate:(NSDate *)paramStartDate endDate:(NSDate*)paramEndDate;

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
 * 安全的从字典中获取字符串
 */
+ (NSString *)safeGetValueFromDic:(NSDictionary *)dic key:(NSString *)key;

/**
 * 安全的从字典中获取对象
 */
+ (id)safeGetObjectFromDic:(NSDictionary *)dic key:(NSString *)key;

/**
 *  安全的多级弹出视图控制器
 *  @param naviController 要执行弹出的视图控制器
 *  @param level          弹出的层级数
 *  @param animated       是否有动画效果
 */
+ (void)SafePopViewController:(UINavigationController *)naviController level:(NSInteger) level isAnimated:(BOOL)animated;

/**
 *  安全加载视图控制器，当要加载的视图控制器A已存在时，会把A以上的视图控制器弹出，保留A,如果isRefresh = YES,A也弹出
 *  @param flagViewController 要加载的视图控制器
 *  @param naviController     要执行弹出的视图控制器
 *  @param isRefresh          是否更新已存在的视图控制器
 *  @param isAnimated         是否支持动画
 */
+ (void)SafePushViewController:(UIViewController *)flagViewController fromNaviController:(UINavigationController *)naviController isRefreshOldView:(BOOL) isRefresh isAnimated:(BOOL)isAnimated;

/**
 *  pop到A 再 push B
 *  @param viewControllerA 视图控制器
 *  @param viewControllerB 视图控制器
 *  @param naviController  导航器
 *  @param isAnimated      是否支持动画
 */
+ (void)SafePopToViewController:(UIViewController *)viewControllerA thenPuthViewController:(UIViewController *)viewControllerB fromNaviController:(UINavigationController *)naviController isAnimated:(BOOL)isAnimated;

/**
 * 将字典或者数组转化为JSON串
 */
+(NSString *) safeToJSON:(NSDictionary *) dic;

/**
 * 将服务器传输来的data数据转化为字典
 */
+(NSDictionary *)safeDataToDictionary:(NSData *)responseData;

/**
 *  版本比较
 *  @param appVersion     APP本地版本
 *  @param serviceVersion 服务器上的APP版本
 *  @return -1:appVersion > serviceVersion,0:版本相同,1:appVersion < serviceVersion
 */
+ (NSInteger)compareAppVersion:(NSString *)appVersion serviceVersion:(NSString *)serviceVersion;

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
