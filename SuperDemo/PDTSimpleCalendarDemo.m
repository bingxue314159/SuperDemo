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

#import "TYG_allHeadFiles.h"
#import "DMLazyScrollView.h"

@interface PDTSimpleCalendarDemo ()<PDTSimpleCalendarViewDelegate>{
    DMLazyScrollView* lazyScrollView;
    NSMutableArray *viewControllerArray;
}

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
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    _customDates = @[[dateFormatter dateFromString:@"01/05/2014"], [dateFormatter dateFromString:@"01/06/2014"], [dateFormatter dateFromString:@"01/07/2014"]];
    
    // PREPARE PAGES
    NSUInteger numberOfPages = 3;
    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        [viewControllerArray addObject:[NSNull null]];
    }
    
    UIView *conView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavBarHeight)];
    conView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:conView];
    // PREPARE LAZY VIEW
    lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:conView.bounds];
    [lazyScrollView setEnableCircularScroll:YES];
    [lazyScrollView setAutoPlay:YES];
    
    __weak __typeof(&*self)weakSelf = self;
    lazyScrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    lazyScrollView.numberOfPages = numberOfPages;
    // lazyScrollView.controlDelegate = self;
    [conView addSubview:lazyScrollView];
    
}

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index > lazyScrollView.numberOfPages || index < 0) return nil;
    
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null]) {
        UIViewController *actionViewController;
        switch (index) {
            case 0:{
                PDTSimpleCalendarViewController *calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
                //This is the default behavior, will display a full year starting the first of the current month
                [calendarViewController setDelegate:self];
                
                actionViewController = calendarViewController;
                break;
            }
            case 1:{
                PDTSimpleCalendarViewController *hebrewCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
                //Example of how you can change the default calendar
                //Other options you can try NSPersianCalendar, NSIslamicCalendar, NSIndianCalendar, NSJapaneseCalendar, NSRepublicOfChinaCalendar
                NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
                hebrewCalendar.locale = [NSLocale currentLocale];
                [hebrewCalendarViewController setCalendar:hebrewCalendar];
                
                actionViewController = hebrewCalendarViewController;
                break;
            }
            case 2:{
                PDTSimpleCalendarViewController *dateRangeCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
                //For this calendar we're gonna allow only a selection between today and today + 3months.
                dateRangeCalendarViewController.firstDate = [NSDate date];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                offsetComponents.month = 3;
                NSDate *lastDate =[dateRangeCalendarViewController.calendar dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                dateRangeCalendarViewController.lastDate = lastDate;
                
                actionViewController = dateRangeCalendarViewController;
                break;
            }
            default:
                break;
        }
        
        
        
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
            [actionViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        
        [viewControllerArray replaceObjectAtIndex:index withObject:actionViewController];
        
        return actionViewController;
    }
    
    return res;
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
