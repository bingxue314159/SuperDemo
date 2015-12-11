//
//  FirstViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *titleArray;
}

@end

@implementation FirstViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [NSMutableArray arrayWithCapacity:10];
        
        self.title = @"首页";

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [titleArray addObject:@"*选取器集合-SelectTableViewController"];
    [titleArray addObject:@"*菜单集合-TYGMenuTableViewController"];
    [titleArray addObject:@"*HUD/POP效果-TYGHUDandPOPTableViewController"];
    [titleArray addObject:@"*iOS7Sampler-MasterViewController"];
    [titleArray addObject:@"16种视图切换动画-AnimationViewController"];
    [titleArray addObject:@"各种各样的cover flow效果-iCarouselExampleViewController"];
    [titleArray addObject:@"无限滚动-DMLazyScrollViewViewController"];
    [titleArray addObject:@"M13BadgeView-M13BadgeViewController"];
    [titleArray addObject:@"快速集成下拉刷新MJRefresh-MJSampleIndexViewController"];
    [titleArray addObject:@"3D导航-CubeDemo"];
    [titleArray addObject:@"标签云-SphereViewController"];
    [titleArray addObject:@"消息弹出-TSMessagesViewController"];
    [titleArray addObject:@"键盘遮挡-IQKeyboardViewController"];
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
    static NSString *reuseIdetify = @"FirstTableViewCell";
    
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
