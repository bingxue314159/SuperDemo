//
//  PDTSimpleCalendarDemo.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/27.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "PDTSimpleCalendarDemo.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"

@interface PDTSimpleCalendarDemo ()<PDTSimpleCalendarViewDelegate>

@property (nonatomic, strong) NSArray *customDates;

@end

@implementation PDTSimpleCalendarDemo

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
    
    PDTSimpleCalendarViewController *calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //This is the default behavior, will display a full year starting the first of the current month
    [calendarViewController setDelegate:self];
    
    PDTSimpleCalendarViewController *hebrewCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //Example of how you can change the default calendar
    //Other options you can try NSPersianCalendar, NSIslamicCalendar, NSIndianCalendar, NSJapaneseCalendar, NSRepublicOfChinaCalendar
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    hebrewCalendar.locale = [NSLocale currentLocale];
    [hebrewCalendarViewController setCalendar:hebrewCalendar];
    
    PDTSimpleCalendarViewController *dateRangeCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //For this calendar we're gonna allow only a selection between today and today + 3months.
    dateRangeCalendarViewController.firstDate = [NSDate date];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.month = 3;
    NSDate *lastDate =[dateRangeCalendarViewController.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    dateRangeCalendarViewController.lastDate = lastDate;
        
    //Example of how you can now customize the calendar colors
//    [[PDTSimpleCalendarViewCell appearance] setCircleDefaultColor:[UIColor whiteColor]];
//    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor orangeColor]];
//    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor blueColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextDefaultColor:[UIColor redColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:[UIColor purpleColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor magentaColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextDisabledColor:[UIColor purpleColor]];
//    [[PDTSimpleCalendarViewCell appearance] setTextDefaultFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0]];
//
//    [[PDTSimpleCalendarViewHeader appearance] setTextColor:[UIColor redColor]];
//    [[PDTSimpleCalendarViewHeader appearance] setSeparatorColor:[UIColor orangeColor]];
//    [[PDTSimpleCalendarViewHeader appearance] setTextFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:8.0]];
        
    //Set the edgesForExtendedLayout to UIRectEdgeNone
    if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
        [calendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [hebrewCalendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [dateRangeCalendarViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    calendarViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"calendar" image:nil selectedImage:nil];
    hebrewCalendarViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"hebrew" image:nil selectedImage:nil];
    dateRangeCalendarViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"dateRange" image:nil selectedImage:nil];
    self.viewControllers = @[calendarViewController, hebrewCalendarViewController, dateRangeCalendarViewController];
}

#pragma mark - PDTSimpleCalendarViewDelegate

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date{
    NSLog(@"Date Selected : %@",date);
    NSLog(@"Date Selected with Locale %@", [date descriptionWithLocale:[NSLocale systemLocale]]);
}

- (BOOL)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller shouldUseCustomColorsForDate:(NSDate *)date{
    if ([self.customDates containsObject:date]) {
        return YES;
    }
    
    return NO;
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller circleColorForDate:(NSDate *)date{
    return [UIColor whiteColor];
}

- (UIColor *)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller textColorForDate:(NSDate *)date{
    return [UIColor orangeColor];
}

@end
