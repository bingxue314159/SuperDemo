//
//  TimesSquareViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/28.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TimesSquareViewDemo.h"
#import "TSQTAViewController.h"

@interface TimesSquareViewDemo ()

@end

@implementation TimesSquareViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMainView{
    TSQTAViewController *gregorian = [[TSQTAViewController alloc] init];
    gregorian.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.calendar.locale = [NSLocale currentLocale];
    
    TSQTAViewController *hebrew = [[TSQTAViewController alloc] init];
    hebrew.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    hebrew.calendar.locale = [NSLocale currentLocale];
    
    TSQTAViewController *islamic = [[TSQTAViewController alloc] init];
    islamic.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCalendar];
    islamic.calendar.locale = [NSLocale currentLocale];
    
    TSQTAViewController *indian = [[TSQTAViewController alloc] init];
    indian.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIndianCalendar];
    indian.calendar.locale = [NSLocale currentLocale];
    
    TSQTAViewController *persian = [[TSQTAViewController alloc] init];
    persian.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSPersianCalendar];
    persian.calendar.locale = [NSLocale currentLocale];

    self.viewControllers = @[gregorian, hebrew, islamic, indian, persian];
}

@end
