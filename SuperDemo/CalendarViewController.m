//
//  CalendarViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/28.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *titleArray;
}

@end

@implementation CalendarViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [NSMutableArray arrayWithCapacity:10];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [titleArray addObject:@"日历控件-PDTSimpleCalendarDemo"];
    [titleArray addObject:@"日历控件-ABCalendarPickerDemo"];
    [titleArray addObject:@"日历控件-TimesSquareViewDemo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdetify = @"CalendarViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = [titleArray objectAtIndex:indexPath.row];
    NSString *className = [[title componentsSeparatedByString:@"-"] lastObject];
    
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
 
    
    if ([@"ABCalendarPickerDemo" isEqualToString:className]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ABCalendarPickerDemo" bundle:nil];
        
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    else{
        UIViewController* viewController = [[NSClassFromString(className) alloc] init];
        viewController.title = [[title componentsSeparatedByString:@"-"] firstObject];
        viewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}


@end
