//
//  Utility.m
//
/**
 *  描述：工具类接口文件
 *  作者：谈宇刚
 *  日期：2013年12月10日
 *  版本：1.1
 */

#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "TYGEncryptDecrypt.h"

#include <sys/sysctl.h> //获取设备硬件名称，方法一
#import <sys/utsname.h> //获取设备硬件名称，方法二

@implementation Utility

/**
 * 获取设备硬件型号，如:iPod1.1,iPhone4.3
 */
+ (NSString *)getModel {
    
    //方法一,#include <sys/sysctl.h>
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
    
    /*
    //方法二,#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    return code;
     */
}

/**
 * 获取设备硬件名称，如iPhone 4,iPad mini2
 */
+ (NSString*)deviceName{
    
    NSString *code = [self getModel];
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{
              @"i386"      :@"Simulator",       //32-bit Simulator
              @"x86_64"    :@"Simulator",       //64-bit Simulator
              
              @"iPod1,1"   :@"iPod Touch 1",    // (Original)
              @"iPod2,1"   :@"iPod Touch 2",    // (Second Generation)
              @"iPod3,1"   :@"iPod Touch 3",    // (Third Generation)
              @"iPod4,1"   :@"iPod Touch 4",    // (Fourth Generation)
              @"iPod5,1"   :@"iPod Touch 5",    // (Five Generation)
              @"iPod7,1"   :@"iPod Touch 6",    // (6th Generation)
              
              @"iPhone1,1" :@"iPhone",          // (Original)
              @"iPhone1,2" :@"iPhone",          // (3G)
              @"iPhone2,1" :@"iPhone",          // (3GS)
              @"iPhone3,1" :@"iPhone 4",        // (GSM)
              @"iPhone3,2" :@"iPhone 4",        //
              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
              @"iPhone4,1" :@"iPhone 4S",       //
              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
              @"iPhone7,1" :@"iPhone 6 Plus",   //
              @"iPhone7,2" :@"iPhone 6",        //
              @"iPhone8,1" :@"iPhone 6S",       //
              @"iPhone8,2" :@"iPhone 6S Plus",  //
              @"iPhone8,4" :@"iPhone SE",       //
              
              @"iPad1,1"   :@"iPad",            // (Original,WiFi)
              @"iPad2,1"   :@"iPad 2",          //WiFi
              @"iPad2,2"   :@"iPad 2",          //GSM
              @"iPad2,3"   :@"iPad 2",          //CDMAV
              @"iPad2,4"   :@"iPad 2",          //CDMAS
              @"iPad2,5"   :@"iPad Mini",       //iPad Mini 1st Gen - WiFi
              @"iPad2,6"   :@"iPad Mini",       //iPad Mini 1st Gen
              @"iPad2,7"   :@"iPad Mini",       //iPad Mini 1st Gen
              @"iPad3,1"   :@"iPad 3",          // (3rd Generation - GSM)
              @"iPad3,2"   :@"iPad 3",          // (3rd Generation - GSM)
              @"iPad3,3"   :@"iPad 3",          // (3rd Generation - CDMA)
              @"iPad3,4"   :@"iPad 4",          // (4th Generation)
              @"iPad3,5"   :@"iPad 4",          // (4th Generation)
              @"iPad3,6"   :@"iPad 4",          // (4th Generation)
              @"iPad2,5"   :@"iPad Mini",       // (Original)
              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
              @"iPad4,3"   :@"iPad Air",
              @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
              @"iPad4,5"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Cellular)
              @"iPad4,6"   :@"iPad Mini 2",
              @"iPad4,7"   :@"iPad Mini 3",     // (3rd Generation iPad Mini - Wifi (model A1599))
              @"iPad4,8"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
              @"iPad4,9"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
              @"iPad5,1"   :@"iPad Mini 4",     //wifi
              @"iPad5,2"   :@"iPad Mini 4",     //Cellular
              @"iPad5,3"   :@"iPad Air 2",
              @"iPad5,4"   :@"iPad Air 2",
              @"iPad6,3"   :@"iPad Air 2",      //iPad Pro 9.7 inch
              @"iPad6,4"   :@"iPad Air 2",      //iPad Pro 9.7 inch
              @"iPad6,7"   :@"iPad Air 2",      //iPad Pro 12.9 inch
              @"iPad6,8"   :@"iPad Air 2",      //iPad Pro 12.9 inch
        };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

/**
 * 提示窗口
 */
+ (void)MsgBox:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

/**
 *  提示窗口
 */
+ (void)MsgBox:(NSString *)msg subTitle:(NSString *)subTitle{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:subTitle
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+ (void)popMessage:(NSString *)msg{
    
    CGFloat offset_v = 5;
    CGFloat offset_h = 5;
    CGFloat fontSize = 18;

    //label
    UILabel *label = [[UILabel alloc] init];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;

    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    CGFloat labelW = appFrame.size.width *2/3;
    CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(labelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    
    label.frame = CGRectMake(offset_h, offset_v, labelSize.width, labelSize.height);
    
    //view
    CGFloat viewW = label.frame.size.width + offset_h*2;
    CGFloat viewH = label.frame.size.height + offset_v*2;
    UIView *lableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    lableView.tag = 56798;
    [lableView addSubview:label];
    lableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    lableView.layer.borderWidth = 0.0;
    lableView.layer.cornerRadius = 4.0;
    lableView.layer.masksToBounds = YES;
    
    //subview
    UIView *view = [UIApplication sharedApplication].keyWindow;
    lableView.center = CGPointMake(appFrame.size.width/2, appFrame.size.height *2/5);
    
    //show
    UIView *tempView = [view viewWithTag:lableView.tag];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    
    [view addSubview:lableView];
    [lableView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5f];
}

/**
 * 去除两边的空格
 */
+ (NSString *)trimString:(NSString *)string{
    
    if (string) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }

    return string;
}

/**
 * 获取当前时间
 */
+(NSDate *)getThisTime{
    // 获取系统当前时间
    NSDate * date = [NSDate date];//格林威治标准时间GMT
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;//2013-09-22 10:15:40 +0000
}

//转换时间（NSDate to NSString）
+ (NSString *) getTimeFromDate:(NSDate *)currentDate{
    //设置时间输出格式：
    if (currentDate == nil) {
        return @"";
    }
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
//    [df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
//    [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    //输出时间
    NSString *time = [df stringFromDate:currentDate];//2013年09月22日 18小时15分40秒
    return time;
}

/**
 *  从字符串转换为时间
 *  @param uiDate 输入的日期字符串形如：@"1992-05-21 13:08:08"
 *  @return NSDate
 */
+(NSDate *) dateConvertDateFromString:(NSString*)uiDate
{
    if (!(uiDate && uiDate.length > 0)) {
        return nil;
    }
    
    if (uiDate.length > 19) {
        //1992-05-21 13:08:08.0
        uiDate = [uiDate substringWithRange: NSMakeRange (0, 19)];
    }
    else if (uiDate.length == 10){
        //1992-05-21
        uiDate = [NSString stringWithFormat:@"%@ 00:00:00",uiDate];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:uiDate];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

/**
 * 解析新浪微博中的日期,@"EEE MMM d HH:mm:ss Z yyyy"
 */
+ (NSString*)getTimeResolveSinaWeiboDate:(NSString*)date{
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    //必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *newDate=[iosDateFormater dateFromString:date];
    
    return [Utility getTimeFromDate:newDate];
}

/**
 * 计算时间间隔，如：1小时前，1天前，1个月前，1年前
 * @parma paramStartDate,paramEndDate-传入的起止时间（e.g. 2014-05-09 18:06:59）
 * @return 字符串，如：1小时前，1天前，1个月前，1年前
 */
+ (NSString *)getTimeStrFromDate:(NSDate *)paramStartDate endDate:(NSDate*)paramEndDate{
    
    NSString *strResult=nil;
    NSCalendar *chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit|NSSecondCalendarUnit | NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *DateComponent = [chineseClendar components:unitFlags fromDate:paramStartDate toDate:paramEndDate options:0];
    
    NSInteger diffHour = [DateComponent hour];
    NSInteger diffMin = [DateComponent minute];
    NSInteger diffSec = [DateComponent second];
    NSInteger diffDay = [DateComponent day];
    NSInteger diffMon = [DateComponent month];
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
        strResult=[NSString stringWithFormat:@"%ld 年前",(long)diffYear];
    }
    else if(diffMon>0){
        strResult=[NSString stringWithFormat:@"%ld 月前",(long)diffMon];
    }else if(diffDay>0){
        strResult=[NSString stringWithFormat:@"%ld 天前",(long)diffDay];
    }else if(diffHour>0){
        strResult=[NSString stringWithFormat:@"%ld 小时前",(long)diffHour];
    }else if(diffMin>0){
        strResult=[NSString stringWithFormat:@"%ld 分钟前",(long)diffMin];
    }else if(diffSec>0){
        strResult=[NSString stringWithFormat:@"%ld 秒前",(long)diffSec];
    }else{
        strResult=[NSString stringWithFormat:@"未知时间"];
    }
    
    return strResult;
}

/*
 * 指定个一文件路径,此方法一般用在FMDB初始化数据库中
 */
+ (NSString *) getDBFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"appBase.db"];
    
    return dbPath;
}


//获取UUID
+ (NSString *) getUUID{
    //e.g. UUID : 3F396F0E-99B0-40FB-91E8-2E9A658E1531
    
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    return uuid.UUIDString;
}

/**
 *  汉字转拼音
 *  @param chinese 汉字
 *  @return 不带声调的拼音
 */
+ (NSString *) getPinyinFromChinese:(NSString *)chinese{
    
    if (chinese.length) {
        //先转换为带声调的拼音
        NSMutableString *str = [chinese mutableCopy];
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
        
        //再转换为不带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
        
        return str;
    }

    return @"";
}

/**
 * 安全的从字典中获取字符串
 */
+ (NSString *)safeGetValueFromDic:(NSDictionary *)dic key:(NSString *)key{
    NSNull *null = [[NSNull alloc] init];
    NSString *value;
    
    if (nil == dic || nil == key) {
        return @"";
    }
    
    id obj = [dic objectForKey:key];
    
    if (nil == obj || [null isEqual:obj]) {
        value = @"";
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@",obj];
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        value = obj;
        //去掉左右两边的空格
        if (value && value.length > 0) {
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
    }
    else{
        value = [NSString stringWithFormat:@"%@",obj];
    }
    
    return value;
}

/**
 * 安全的从字典中获取对象
 */
+ (id)safeGetObjectFromDic:(NSDictionary *)dic key:(NSString *)key{

    if (nil == dic || key.length == 0) {
        return nil;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id object = [dic objectForKey:key];
    
    return object;
}

/**
 *  安全的多级弹出视图控制器
 *  @param naviController 要执行弹出的视图控制器
 *  @param level          弹出的层级数
 *  @param animated       是否有动画效果
 */
+ (void)SafePopViewController:(UINavigationController *)naviController level:(NSInteger) level isAnimated:(BOOL)animated{
    
    if (nil == naviController || level <= 0) {
        return;
    }
    
    NSArray *chileController = naviController.childViewControllers;
    NSInteger count = [chileController count];
    if (count > level) {
        UIViewController *controller;
        
        NSInteger maxIndex = count - 1;
        for (NSInteger i = maxIndex; i >= 0; i--) {
            controller = [chileController objectAtIndex:i];
            level--;
            
            if (level == 0) {
                [controller.navigationController popViewControllerAnimated:animated];
                break;
            }
            else{
                [controller.navigationController popViewControllerAnimated:NO];
            }
        }
        
        controller = nil;
    }
    else{
        NSLog(@"MoveRightView message:RootViewController没有视图加载");
    }
    
}

/**
 *  安全加载视图控制器，当要加载的视图控制器A已存在时，会把A以上的视图控制器弹出，保留A,如果isRefresh = YES,A也弹出
 *  @param flagViewController 要加载的视图控制器
 *  @param naviController     要执行弹出的视图控制器
 *  @param isRefresh          是否更新已存在的视图控制器
 *  @param isAnimated         是否支持动画
 */
+ (void)SafePushViewController:(UIViewController *)flagViewController fromNaviController:(UINavigationController *)naviController isRefreshOldView:(BOOL) isRefresh isAnimated:(BOOL)isAnimated{
    
    NSArray *chileController = naviController.childViewControllers;
    NSInteger count = [chileController count];
    BOOL isOldView = NO;
    if (count >= 1 && flagViewController != nil) {
        UIViewController *controller;
        for (int i = 0; i < count; i++) {
            controller = [chileController objectAtIndex:i];
            
            if ([flagViewController isKindOfClass:[controller class]]) {
                isOldView = YES;
                for (NSInteger y = (count-1); y > i; y--) {
                    UIViewController *controllerY = [chileController objectAtIndex:y];
                    //此处的动画效果一定要为NO，否则会因为POP太连续，导致动画效果没有执行完毕，从而不执行POP操作了
                    [controllerY.navigationController popViewControllerAnimated:NO];
                    NSLog(@"pop %@",controllerY);
                    
                }
                
                if (isRefresh) {
                    [controller.navigationController popViewControllerAnimated:NO];
                }
                
                break;
            }
        }
        
        if (!isOldView || isRefresh) {
            [naviController pushViewController:flagViewController animated:isAnimated];
        }
        
        controller = nil;
        //flagViewController = nil;
        NSLog(@"childViewControllers = %@",naviController.childViewControllers);
    }
    else{
        NSLog(@"没有视图加载");
    }
}

/**
 *  pop到A 再 push B
 *  @param viewControllerA 视图控制器
 *  @param viewControllerB 视图控制器
 *  @param naviController  导航器
 *  @param isAnimated      是否支持动画
 */
+ (void)SafePopToViewController:(UIViewController *)viewControllerA thenPuthViewController:(UIViewController *)viewControllerB fromNaviController:(UINavigationController *)naviController isAnimated:(BOOL)isAnimated{
    
    [self SafePushViewController:viewControllerA fromNaviController:naviController isRefreshOldView:NO isAnimated:NO];
    [naviController pushViewController:viewControllerB animated:isAnimated];
}

/**
 * 将字典或者数组转化为JSON串
 */
+(NSString *) safeToJSON:(NSDictionary *) dic{
    
    NSString *JsonStingSend = nil;
    //判断Foundation对象是否可以转换为JSON数据
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error = nil;
        //把数据封装成JSON格式
        NSData *jsonDataSend = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if ([jsonDataSend length] > 0 && error == nil){
            //使用这个方法的返回，我们就可以得到想要的JSON串
            JsonStingSend = [[NSString alloc] initWithData:jsonDataSend encoding:NSUTF8StringEncoding];

        }else{
            NSLog(@"将传入的字典转换为JSON失败");
        }
    }
    return JsonStingSend;
}

/**
 * 将服务器传输来的data数据转化为字典
 */
+(NSDictionary *)safeDataToDictionary:(NSData *)responseData{

    NSString *resStr = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    if (nil == resStr) {
        return nil;
    }
    resStr = [resStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    NSData *newJsonData = [resStr dataUsingEncoding:NSUTF8StringEncoding];
    
    // 将返回的值JSON编辑成NSDictionary
    NSError *error = nil;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:newJsonData options:NSJSONReadingAllowFragments error:&error];
    
    if ([[NSNull null] isEqual:responseDic] || error != nil) {
        responseDic = nil;
    }
    
    return responseDic;
}

/**
 *  版本比较
 *  @param appVersion     APP本地版本
 *  @param serviceVersion 服务器上的APP版本
 *  @return -1:appVersion > serviceVersion,0:版本相同,1:appVersion < serviceVersion
 */
+ (NSInteger)compareAppVersion:(NSString *)appVersion serviceVersion:(NSString *)serviceVersion{
    
    /*
     NSComparisonResult comResult = [appVersion compare:serviceVersion options:NSNumericSearch];
     switch (comResult) {
     case NSOrderedAscending: {
     //<
     break;
     }
     case NSOrderedSame: {
     //=
     break;
     }
     case NSOrderedDescending: {
     //>
     break;
     }
     }
     */
    NSMutableArray *appVersionArray = [NSMutableArray arrayWithArray:[appVersion componentsSeparatedByString:@"."]];
    NSMutableArray *serviceVersionArray = [NSMutableArray arrayWithArray:[serviceVersion componentsSeparatedByString:@"."]];
    
    while (serviceVersionArray.count < appVersionArray.count) {
        [serviceVersionArray addObject:@"0"];
    }
    
    while (serviceVersionArray.count > appVersionArray.count) {
        [appVersionArray addObject:@"0"];
    }
    
    NSInteger result = 0;
    for (int i = 0; i < appVersionArray.count; i++) {
        NSInteger appInt = [[appVersionArray objectAtIndex:i] integerValue];
        NSInteger serviceInt = [[serviceVersionArray objectAtIndex:i] integerValue];
        
        
        if (serviceInt > appInt) {
            //服务器版本大于本地版本
            result = 1;
            break;
        }
        else if (serviceInt < appInt){
            result = -1;
            break;
        }
        
    }
    
    return result;
    
}

/**
 *  获取随机颜色
 *  @return 随机颜色
 */
+(UIColor *)RandomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

/**
 *  生成随机数
 *  @param from 随机数左边界
 *  @param to   随机数右边界
 *  @return 边界内的随机数
 */
+(int)RandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
