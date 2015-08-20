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

@implementation Utility

//创建GET方法的URL后面的参数
+(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

+(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

/*
 * 功能：检测网络连接状态
 * 备注：#import "SystemConfiguration/SystemConfiguration.h"
 *      #include "netdb.h"
 */
+(BOOL) connectedToNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    /**
     *  SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     *  SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     *  第一个参数可以为NULL或kCFAllocatorDefault
     *  第二个参数为需要测试连接的IP地址,当为0.0.0.0时则可以查询本机的网络连接状态.
     *  同时返回一个引用必须在用完后释放.
     *  PS: SCNetworkReachabilityCreateWithName: 这个是根据传入的网址测试连接,
     *  第二个参数比如为"www.apple.com",其他和上一个一样.
     *
     *  SCNetworkReachabilityGetFlags: 这个函数用来获得测试连接的状态,
     *  第一个参数为之前建立的测试连接的引用,
     *  第二个参数用来保存获得的状态,
     *  如果能获得状态则返回TRUE，否则返回FALSE
     *
     */
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    //根据获得的连接标志进行判断
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    
    //    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    //    BOOL mobilNet = flags & kSCNetworkReachabilityFlagsIsWWAN;//当前网络为蜂窝网络，即3G或者GPRS
    
    return (isReachable && !needsConnection) ? YES : NO;
}

// Direct from Apple. Thank you Apple
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
    if (!IPAddress || ![IPAddress length]) return NO;
	
    memset((char *) address, sizeof(struct sockaddr_in), 0);
    address->sin_family = AF_INET;
    address->sin_len = sizeof(struct sockaddr_in);
	
    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
    if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
        return NO;
    }
	
    return YES;
}

//根据网址获取相应的IP
+ (NSString *) getIPAddressForHost: (NSString *) theHost
{
    theHost=[theHost substringFromIndex:7];
    NSLog(@"%@",theHost);
	struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	return addressString;
}

//检测一个网址是否可以正常访问
+ (BOOL) hostAvailable: (NSString *) theHost
{
	
    NSString *addressString = [self getIPAddressForHost:theHost];
    if (!addressString)
    {
        printf("Error recovering IP address from host name\n");
        return NO;
    }
	
    struct sockaddr_in address;
    BOOL gotAddress = [self addressFromString:addressString address:&address];
	
    if (!gotAddress)
    {
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
        return NO;
    }
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags =SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    return isReachable ? YES : NO;;
}

//提示窗口
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
    CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(labelW, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
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

//验证邮箱格式（可匹配多个结果）
+ (BOOL) isEmail:(NSString *)email{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    if (result) {
        NSLog(@"%@\n", [email substringWithRange:result.range]);
        return YES;
    }
    return NO;
}

//利用正则表达式验证邮箱输入合法性
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码格式验证
+(BOOL)isTelphoneNumber:(NSString *)telNum{
    
    telNum = [telNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] == 11) {
        NSString *telNumRegex = @"^1[3-8]+\\d{9}$";
        NSPredicate *telNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telNumRegex];
        return [telNumTest evaluateWithObject:telNum];
    }
    return NO;
}

//验证是否是数字与字母的组合
+(BOOL)isNumberAndChar:(NSString *)sting{
    sting = [sting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:sting];
}

//验证是否是数字
+(BOOL)isNumber:(NSString *)sting{
    //^((\+|\-)?[1-9]\d*\.?\d*)|((\+|\-)?0\.\d*)|(\.\d*)$
    sting = [sting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *stringRegex = @"^([0-9]+\\d*\\.?\\d*)|(0(\\.\\d*)?)|(\\.\\d*)$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:sting];
}

//去除两边的空格
+ (NSString *)trimString:(NSString *)string{
    
    if (string) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }

    return string;
}

//获取view的controller
+ (UIViewController *)getViewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

// 获取系统当前时间
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

//从字符串转换为时间
//输入的日期字符串形如：@"1992-05-21 13:08:08"
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

//解析新浪微博中的日期
+ (NSString*)getTimeResolveSinaWeiboDate:(NSString*)date{
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    //必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *newDate=[iosDateFormater dateFromString:date];
    
    return [Utility getTimeFromDate:newDate];
}

/**
 * 转换时间到当天零点或者最后一秒
 * @parma currentDate-传入的时间（e.g. 2014-05-09 18:06:59），timeType ? 0 : 1
 * @return 转化好的时间 2014-05-09 00:00:00 | 2014-05-09 23:59:59
 **/
+ (NSDate *) dateFromDate:(NSDate *)currentDate timeType:(NSInteger)timeType{
    
    NSTimeInterval secondsPerDay = 8*60*60;
    currentDate = [currentDate dateByAddingTimeInterval:-secondsPerDay];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    //    [df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    //输出时间
    NSString *time = [df stringFromDate:currentDate];//2013年09月22日 18小时15分40秒
    
    NSString *newStr = [NSString stringWithFormat:@"%@ 00:00:00",time];
    if (timeType != 0) {
        //结束时间
        newStr = [NSString stringWithFormat:@"%@ 23:59:59",time];
    }
    NSDate *newDate = [Utility dateConvertDateFromString:newStr];
    
    return newDate;
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
    NSInteger diffMin    = [DateComponent minute];
    NSInteger diffSec   = [DateComponent second];
    NSInteger diffDay   = [DateComponent day];
    NSInteger diffMon  = [DateComponent month];
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

+ (NSString *) getFilePath:(NSString *)filename isNotExistsCreatIt:(BOOL) isCreat{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [rootPath stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        if (isCreat) {
            [fileManager createFileAtPath:filePath contents:nil attributes:nil];
            return filePath;
        }
        else{
            return nil;
        }
    }
    else{
        return filePath;
    }
    return nil;
}

/*
 * 指定个一文件路径,此方法一般用在FMDB初始化数据库中
 */
+ (NSString *) getYoujaibaDBFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"uuxoo.db"];
    
    return dbPath;
}


//获取UUID
+ (NSString *) getUUID{
    //e.g. UUID : 3F396F0E-99B0-40FB-91E8-2E9A658E1531
    
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    return uuid.UUIDString;
}

//获取“UUID-时间戳”
+ (NSString *) getUUIDTimes{
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSTimeInterval dd = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *string = [NSString stringWithFormat:@"%@-%f",uuid.UUIDString,dd];
    return string;
}

/**
 *  汉字转拼音
 *
 *  @param chinese 汉字
 *
 *  @return 不带声调的拼音
 */
+ (NSString *) getPinyinFromChinese:(NSString *)chinese{

    //先转换为带声调的拼音
    NSMutableString *str = [chinese mutableCopy];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    return str;
}

//封装系统相关信息
+ (NSMutableDictionary *) dictionaryAddJOSNHeader:(NSMutableDictionary *) dic{

    [dic setObject:@"Android" forKey:@"os"];//os
    [dic setObject:@"1.0" forKey:@"v"];//API版本--Version
    [dic setObject:@"10086" forKey:@"app"];
    
    //UUID--MacUUID
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    [dic setObject:uuid.UUIDString forKey:@"clientId"];
    
    return dic;
}

//安全的从字典中获取字符串
+ (NSString *)safeGetValueFromDic:(NSDictionary *)dic key:(NSString *)key{
    NSNull *null = [[NSNull alloc] init];
    NSString *value;
    
    id obj = [dic objectForKey:key];
    
    if ([null isEqual:obj]) {
        value = @"";
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@",obj];
    }
    else{
        value = [dic objectForKey:key];
        //去掉左右两边的空格
        if (value) {
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
    }
    
    return value;
}

//安全的从字典中获取对象
+ (id)safeGetObjectFromDic:(NSDictionary *)dic key:(NSString *)key{
    NSNull *null = [[NSNull alloc] init];
    id object;
    if ([null isEqual:[dic objectForKey:key]]) {
        object = nil;
    }
    else{
        object = [dic objectForKey:key];
    }
    
    return object;
}

/**
 * 功能：安全加载视图控制器，当要加载的视图控制器A已存在时，会把A以上的视图控制器弹出，保留A,如果isRefresh = YES,A也弹出
 * 参数：flagViewController-要加载的视图控制器 isRefresh--是否更新已存在的视图控制器
 * 返回：
 */
+ (void)SafePushViewController:(UIViewController *)flagViewController isRefreshOldView:(BOOL) isRefresh{
    
    UIViewController *RootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    NSArray *chileController = RootViewController.navigationController.childViewControllers;
    NSInteger count = [chileController count];
    BOOL isOldView = NO;
    if (count >= 1 && flagViewController != nil) {
        UIViewController *controller;
        for (int i = 0; i < count; i++) {
            controller = [chileController objectAtIndex:i];
            
            if ([flagViewController isKindOfClass:[controller class]]) {
                isOldView = YES;
                for (int y = (count-1); y > i; y--) {
                    UIViewController *controllerY = [chileController objectAtIndex:y];
                    //此处的动画效果一定要为NO，否则会因为POP太连续，导致动画效果没有执行完毕，从而不执行POP操作了
                    [controllerY.navigationController popViewControllerAnimated:NO];
                    NSLog(@"MoveRightView message:pop %@",controllerY);
                    
                }
                
                if (isRefresh) {
                    [controller.navigationController popViewControllerAnimated:NO];
                }
                
                break;
            }
        }
        
        if (!isOldView || isRefresh) {
            [RootViewController.navigationController pushViewController:flagViewController animated:NO];
        }
        
        controller = nil;
        flagViewController = nil;
        NSLog(@"MoveRightView message: all controller = %@",RootViewController.navigationController.childViewControllers);
    }
    else{
        NSLog(@"MoveRightView message:RootViewController没有视图加载");
    }
    
}


// 将字典或者数组转化为JSON串
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

// 将字典或者数组转化为JSON串,并DES加密
+(NSString *) safeToJSONToDES:(NSDictionary *) dic{
    NSString *json = [self safeToJSON:dic];
    if (json) {
        json = [TYGEncryptDecrypt DESEncrypt:json key:@"lghlmcl0"];
    }
    
    return json;
}

// string DES加密
+(NSString *)safeStringToDES:(NSString *)string{
    
    if (string) {
        string = [TYGEncryptDecrypt DESEncrypt:string key:@"lghlmcl0"];
    }
    
    return string;
}

//将服务器传输来的data数据转化为字典
+(NSDictionary *)safeDataToDictionary:(NSData *)responseData{

    NSString *resStr = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
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
 *  获取随机颜色
 *  @return 随机颜色
 */
+(UIColor *)randomColor{
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
+(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
