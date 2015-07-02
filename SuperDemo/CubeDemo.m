//
//  CubeDemo.m
//  SuperDemo
//
//  Created by tanyugang on 15/4/21.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "CubeDemo.h"
#import "CubeController.h"
#import "CubeViewController.h"


@interface CubeDemo ()<CubeControllerDataSource>

@end

@implementation CubeDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [button setTitle:@"开始3D导航" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button{
    CubeController *controller = [[CubeController alloc] init];
    controller.dataSource = self;
    controller.wrapEnabled = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    //真实应用中
    /*
     - (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions
     {
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     CubeController *controller = [[CubeController alloc] init];
     controller.dataSource = self;
     controller.wrapEnabled = YES;
     self.window.rootViewController = controller;
     [self.window makeKeyAndVisible];
     
     return YES;
     }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfViewControllersInCubeController:(__unused CubeController *)cubeController
{
    return 3;
}

- (UIViewController *)cubeController:(__unused CubeController *)cubeController viewControllerAtIndex:(NSInteger)index
{
    switch (index % 3)
    {
        case 0:
        {
            return [[CubeViewController alloc] initWithNibName:@"RedViewController" bundle:nil];
        }
        case 1:
        {
            return [[CubeViewController alloc] initWithNibName:@"GreenViewController" bundle:nil];
        }
        case 2:
        {
            return [[CubeViewController alloc] initWithNibName:@"BlueViewController" bundle:nil];
        }
    }
    return nil;
}

@end
