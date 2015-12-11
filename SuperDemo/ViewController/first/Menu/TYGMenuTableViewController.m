//
//  TYGMenuTableViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/6/5.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGMenuTableViewController.h"

@interface TYGMenuTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *titleArray;
}

@end

@implementation TYGMenuTableViewController


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
    [titleArray addObject:@"垂直的弹出式菜单-kxMenuDemo"];
    [titleArray addObject:@"横向的弹出式菜单-QBPopupMenuDemo"];
    [titleArray addObject:@"多种动画的下拉菜单-IGLDemoViewController"];
    [titleArray addObject:@"四个方向展开和收起菜单-DWBubbleMenuButtonDemo"];
    
    [titleArray addObject:@"导航栏侧边下拉、弹出-RWDemoViewController"];
    [titleArray addObject:@"导航栏下拉、弹出-REMenuExample"];
    [titleArray addObject:@"导航栏滑动菜单-REFrostedViewControllerExample"];
    [titleArray addObject:@"菊花菜单-AwesomeMenuDemoViewController"];

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
    static NSString *reuseIdetify = @"SelectTableViewCell";
    
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
