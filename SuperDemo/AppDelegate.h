//
//  AppDelegate.h
//  SuperDemo
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *viewController;
@property (strong, nonatomic) REFrostedViewController *frostedViewController;

@end

