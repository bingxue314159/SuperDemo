//
//  ViewController.m
//  AutomobileMarket
//
//  Created by tanyugang on 15/3/6.
//  Copyright (c) 2015年 YDAPP. All rights reserved.
//

#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
#import "IQKeyboardManager.h"

#import "TYG_allHeadFiles.h"

@interface MainViewController (){
    FirstViewController *firstViewController;
    SecondViewController *secondViewController;
    ThirdViewController *thirdViewController;
    FourViewController *fourViewController;
}

@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization

        self.view.backgroundColor = [UIColor whiteColor];

        [self drawTabBarView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //解决键盘遮挡住输入框的问题
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告");
}

- (void)drawTabBarView{
    //    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_bg.png"]];//背景
    [self.tabBar setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];
    //    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"bottomSelect_bg.png"]];//item选中时的背景
    self.tabBar.layer.masksToBounds = YES;
    self.tabBar.tintColor = [UIColor colorWithRed:1 green:0.4 blue:0.02 alpha:1];
    self.tabBar.shadowImage = [[UIImage alloc] init];//隐藏那条黑线
    self.selectedIndex = 0;//在此处设置是无效的，因为viewControlls还未加载
    //    self.delegate = self;
    
    //设置字体颜色
    UIColor *titleNormalColor = [UIColor blackColor];
    UIColor *titleSelectedColor = [UIColor orangeColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleNormalColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleSelectedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    //视图控制器
    firstViewController = [[FirstViewController alloc] init];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil tag:1];
    item1.image = [[UIImage imageNamed:@"首页_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//忽略tabBar.tintColor
    item1.selectedImage = [[UIImage imageNamed:@"首页_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firstViewController.tabBarItem = item1;
    
    secondViewController = [[SecondViewController alloc] init];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"发现" image:nil tag:2];
    item2.image = [[UIImage imageNamed:@"发现_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"发现_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondViewController.tabBarItem = item2;
    
    thirdViewController = [[ThirdViewController alloc] init];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"VIP" image:nil tag:3];
    item3.image = [[UIImage imageNamed:@"VIP_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"VIP_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thirdViewController.tabBarItem = item3;
    
    fourViewController = [[FourViewController alloc] init];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"我的" image:nil tag:4];
    item4.image = [[UIImage imageNamed:@"我的_黑.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"我的_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fourViewController.tabBarItem = item4;
    
    
    //导航栏
    self.navBarController1 = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    self.navBarController2 = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    self.navBarController3 = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    self.navBarController4 = [[UINavigationController alloc] initWithRootViewController:fourViewController];
    
    //导航栏背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"view1NavBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    //隐藏那条黑线
    //[[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    //导航栏禁用半透明效果
    //只要同时设置BackgroundImage、ShadowImage，translucent = YES时，Navigationbar变成透明而不模糊
    if (SystemVersion >= 7.0) {
//        [[UINavigationBar appearance] setTranslucent:NO];//这句不知道为什么，在iOS7.1.1下会闪退
        self.navBarController1.navigationBar.translucent = NO;
        self.navBarController2.navigationBar.translucent = NO;
        self.navBarController3.navigationBar.translucent = NO;
        self.navBarController4.navigationBar.translucent = NO;
    }
    
    /*
     if (SystemVersion >= 7.0) {
         [[UINavigationBar appearance] setBarTintColor:Color_NavBar_BACKGROUND];
     }
     else {
         [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.11 green:0.68 blue:0.75 alpha:1]];
     }
     */
    
    //iOS8 滑动的时候隐藏navigation bar
    //[UINavigationBar appearance].hidesBarsOnSwipe = Yes;
    
    //状态栏风格
    ////方案一：需要配合配置表,将 View controller-based status bar appearance 设置为NO（默认为 YES）：
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //设置状态栏风格,iOS9不建议使用，会有警告产生
    ////方案二：iOS9后，建议Use -[UIViewController preferredStatusBarStyle]
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    //自定义返回按钮
    UIImage *backButtonImage_OFF = [[UIImage imageNamed:@"back_ON_25.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage_OFF forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //返回按钮样式及颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    if(SystemVersion >= 7.0){
//        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back_ON_25.png"]];//iOS7
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_ON_25.png"]];//iOS7
//    }
    
    //iOS 隐藏/去掉 导航栏返回按钮中的文字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    //导航栏标题样式
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:Color_NavBarTitel, NSForegroundColorAttributeName, Font_NavBarTitel, NSFontAttributeName, nil]];
    
    //组装
    self.viewControllers = [NSArray arrayWithObjects:self.navBarController1,self.navBarController2,self.navBarController3,self.navBarController4, nil];
    
    self.selectedIndex = 0;//设置启动时第一次显示的UI
}

//设置状态栏的白色(一定要在rootViewController的中设置)
//最好的方法是在navBarController1的rootViewController中调用：
-(UIStatusBarStyle)preferredStatusBarStyle{
    //PS：此法的只有在设置了以下代码才会被调用（对于preferredStatusBarStyle不执行问题）：
    //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    return UIStatusBarStyleLightContent;
}
@end
