//
//  CommonHeader.h
//
//  Created by tanyg on 13-12-10.
//  Copyright (c) 2012年 2013002-02. All rights reserved.
//
/**
 * @brief 定义全局常量
 * @author 谈宇刚
 * @version 1.1
 * @date 2013年7月18日
 *
 * # 更新日志
 * [2013年7月18日] 1.1
 * + 修改字体宏，使其fontSize为变量
 *
 * [2015年4月9日] 1.2
 * + 增加iphone6 6plus的判断
 */

#import <UIKit/UIKit.h>

/*======================================================
 *********************** 系统 **************************
 ======================================================*/
//IOS系统名称 e.g. @"iPhone OS"
#define SystemName [[UIDevice currentDevice] systemName]
//IOS系统版本号 e.g. 7.0.3
#define SystemVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
//获取当前语言
#define SystemLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//UUID--MacUUID(App重装后UUID会改变)
#define MacUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//本机类型--e.g. @"iPhone", @"iPod, @"iPhone Simulator"
#define SystemModel [[UIDevice currentDevice] model]

//App名称
#define AppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
//App版本号 e.g. 1.1.0
#define AppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//App build版本号 e.g. 1.1.0
#define AppBuildVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
//App BundleIdentifier e.g. com.baidu.test
#define AppBundleIdentifier [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

//屏幕尺寸的宽高与scale的乘积就是相应的分辨率值。
#define SystemScale [UIScreen mainScreen].scale

//判断是否是iphone4屏-640像素 x 960像素
#define isiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone5
#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone6
#define isiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone6 plus
#define isiPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iphone
#define isIPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? YES: NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断iphone的版本号
#define isSystemIsWhich(yoursystem) [[[UIDevice currentDevice] systemVersion] compare:yoursystmen] == NSOrderedDescending

//判断当前设备是否为刘海屏幕
#define isLiuhaiScreen ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
        isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

#define isIphoneX ({\
    BOOL isPhoneX = NO;\
    if (@available(iOS 11.0, *)) {\
        if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
        isPhoneX = YES;\
        }\
    }\
    isPhoneX;\
})

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

/*======================================================
 *********************** 内存 **************************
 ======================================================*/
//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

//字符串安全处理
#define SAFE_STRING(str) ([[NSNull null] isEqual:str] ? @"" : (([(str) length] ? (str) : @"")))
//把数字变成字符串
#define SAFE_StringFormInt(intNum) [NSString stringWithFormat:@"%ld",(long)(intNum)]
#define SAFE_StringFormFloat2d(floatNum) [NSString stringWithFormat:@"%.2f",floatNum]

//对象安全处理
//#define SAFE_OBJECT(object) ([[NSNull null] isEqual:object] ? nil : object)
#define SAFE_OBJECT(object) (nil == object ? [NSNull null] : object)
//安全的移除一个对象
#define SAFE_RemoveView(view) if(view){\
if ([view superview]) {[view removeFromSuperview];}\
view = nil;\
}
//清空视图
#define SAFE_emptyView(view) for(UIView *subview in [view subviews]){[subview removeFromSuperview];}
//释放一个对象
#define safe_release(obj) if(obj != nil && obj !=NULL){ \
[obj release]; \
obj = nil;\
}

/**
 *  强弱引用转换
 */
#define WeekSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(strongSelf) __strong __typeof(&*self)strongSelf = weakSelf;

/**
 * 强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 * 调用方式: `@weakify_self`实现弱引用转换，`@strongify_self`实现强引用转换
 *
 * 示例：
 * @weakify_self
 * [obj block:^{
 * @strongify_self
 * self.property = something;
 * }];
 */
#ifndef weakify_self
#if __has_feature(objc_arc)
#define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif

#ifndef strongify_self
#if __has_feature(objc_arc)
#define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif

/**
 * 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 * 示例：
 * @weakify(object)
 * [obj block:^{
 * @strongify(object)
 * strong_object = something;
 * }];
 */
#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
#endif
#endif

/*======================================================
 *********************** 图片 **************************
 ======================================================*/
//获取图片文件
#define GET_IMAGE(__NAME__,__TYPE__)    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:__NAME__ ofType:__TYPE__]]

/*======================================================
 ********************** 字体类 **************************
 ======================================================*/

/**
 * 导航栏 标题字体
 */
#define Font_NavBarTitel [UIFont boldSystemFontOfSize:16]

/**
 * 导航栏 按钮字体
 */
#define Font_NavBarButton [UIFont systemFontOfSize:16]

/**
 * 按钮字体
 */
#define Font_Button(fontsize) [UIFont systemFontOfSize:(fontsize)]

/**
 * 按钮字体
 */
#define Font_Text(fontsize) [UIFont systemFontOfSize:(fontsize)]
#define Font_Text_bold(fontsize) [UIFont boldSystemFontOfSize:(fontsize)]

/*======================================================
 ********************** 颜色类 **************************
 ======================================================*/

/**
 * 转换计算着色的值(16进制->10进制) e.g. ColorFromRGB(0x067AB5)
 */
#define Color_RGB_OxH(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 * 转换计算着色的值 e.g. Color_RGB(120,110,0),相应的参数会除255.0
 */
#define Color_RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define Color_RGB(r,g,b) RGBA(r,g,b,1.0f)


/*======================================================
 ********************** APP颜色类 **************************
 ======================================================*/
/**
 * 导航栏 默认背景颜色
 */
#define Color_NavBar_BACKGROUND  [UIColor colorWithRed:0.11 green:0.68 blue:0.75 alpha:1]

/**
 * 导航栏 标题颜色
 */
#define Color_NavBarTitel  [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]

/**
 * 文字 默认文本颜色
 */
#define Color_Text  [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]


/**
 * 文字--深色 默认背景颜色
 */
#define Color_Text_dark  [UIColor colorWithRed:0.4235 green:0.4078 blue:0.4078 alpha:1.0]

/**
 * 边框颜色
 */
#define Color_border  [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1]
#define Color_border_heightLinght [UIColor colorWithRed:0.6 green:0.85 blue:0.62 alpha:1]

/**
 * 文字--深色 默认背景颜色16位
 */
#define Color_Text_dark_16H @"#6C6868"

/**
 * 视图背景 默认背景颜色
 */
#define Color_mainviewBackground [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]
#define Color_viewBackground [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]
/**
 * 按钮 默认背景颜色
 */
#define Color_buttonONBackground  [UIColor colorWithRed:0.8235 green:0.8235 blue:0.8235 alpha:1.0]
#define Color_buttonOFFBackground  [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]

/**
 * 按钮 默认背景颜色
 */
#define Color_buttonTitel  [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]

/**
 * 右移视图背景 默认背景颜色
 */
#define Color_moveRightViewBackground  [UIColor colorWithRed:0.0000 green:0.4745 blue:0.5255 alpha:1.0]


/*======================================================
 ************* 定义各种frame及坐标和尺寸 ******************
 ======================================================*/
/**
 * 当前APP占设备的屏幕FRAME--不含状态栏高度
 */
#define APPFrame [[UIScreen mainScreen] applicationFrame]

/**
 * 当前设备的屏幕FRAME--含状态栏高度
 */
#define MainFrame [[UIScreen mainScreen] bounds]

/**
 * 当前设备的屏幕X
 */
#define SCREEN_X   [[UIScreen mainScreen] bounds].origin.x

/**
 * 当前设备的屏幕Y
 */
#define SCREEN_Y   [[UIScreen mainScreen] bounds].origin.y

/**
 * 当前设备的屏幕宽度
 */
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width

/**
 * 当前设备的屏幕高度(含状态栏高度)
 */
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

// iPhone X
#define  isiPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)

// Tabbar safe bottom margin.
#define TabbarSafeBottomMargin (isiPhoneX ? 34.f : 0.f)

//工具栏高度
#define TabBarHeight (isiPhoneX ? (49.f+34.f) : 49.f)

//导航栏、状态栏调度
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// iPhone OS SDK 7.0 以后版本的处理
#define NavBarHeight  (isiPhoneX ? 88.f : 64.f) // Status bar & navigation bar height.
#define STATUS_H 0.0f
#else
// iPhone OS SDK 7.0 之前版本的处理
#define NavBarHeight 44.0f
#define STATUS_H [[UIApplication sharedApplication] statusBarFrame].size.height
#endif
#endif

//状态栏
#define STATUS_FRAME [[UIApplication sharedApplication] statusBarFrame]//状态栏FRAME

//RootViewController
#define RootViewController [UIApplication sharedApplication].keyWindow.rootViewController
#define RootWindow [UIApplication sharedApplication].keyWindow



/*======================================================
 ********************* 打印日志 *************************
 ======================================================*/
//Debug模式下打印日志和当前行数
//可以用printf来替代NSLog，这样输出的信息中就不会带有时间等信息。
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//此处屏蔽，是把此宏放在了-Prefix.pch
////重写NSLog,Debug模式下打印日志和当前行数
////可以用printf来替代NSLog，这样输出的信息中就不会带有时间等信息。
//#if DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

/**
 * 1) __VA_ARGS__ 是一个可变参数的宏，这个可变参数的宏是新的C99规范中新增的，目前似乎只有gcc支持（VC6.0的编译器不支持）。宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,否则会编译出错。
 * 2) __FILE__ 宏在预编译时会替换成当前的源文件名
 * 3) __LINE__宏在预编译时会替换成当前的行号
 * 4) __FUNCTION__宏在预编译时会替换成当前的函数名称
 * 5) __PRETTY_FUNCTION__对函数的打印会带上参数
 * 6) __DATE__编译时的日期
 * 7) __TIME__编译时的时间
 */

/*======================================================
 *********************** 其它 ***************************
 ======================================================*/
//float a=0.0，a与0比较竟然不相等,只能通过a<0.000001来判断a是否为0，也可用 CGFLOAT_MIN 替代
#define FLOAT_ERROR_MARGIN 0.000001
//由角度获取弧度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
//由弧度获取角度
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//G－C－D
#define GCD_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
