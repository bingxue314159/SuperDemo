//
//  SecondViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *titleArray;
}

@end

@implementation SecondViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [NSMutableArray arrayWithCapacity:10];
        
        self.title = @"发现";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [titleArray addObject:@"*日历集合-CalendarViewController"];
    [titleArray addObject:@"左右滑动列表cell-SWTableViewCellDemo"];
    [titleArray addObject:@"左右滑动列表cell-MGSwipeTableCellDemo"];
//    [titleArray addObject:@"BlocksKit-BlocksKitViewController"];
//    [titleArray addObject:@"DTCoreText-DTCoreTextViewController"];
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
    static NSString *reuseIdetify = @"SecondViewController";
    
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
    
    UIViewController* viewController = [[NSClassFromString(className) alloc] init];
    viewController.title = [[title componentsSeparatedByString:@"-"] firstObject];
    viewController.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}


@end
