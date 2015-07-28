//
//  SelectTableViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "SelectTableViewController.h"

@interface SelectTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *titleArray;
}

@end

@implementation SelectTableViewController

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
    
    [titleArray addObject:@"选取器DEMO1-IQActionSheetDemo"];
    [titleArray addObject:@"选取器DEMO2-ActionSheetPickerTableViewController"];
    [titleArray addObject:@"选取器DEMO3-kDropDownSelectDemo"];
    [titleArray addObject:@"地区选取器-HZAreaPickerViewDemo"];
    [titleArray addObject:@"照片选取器-TYGUzysViewController"];
    [titleArray addObject:@"照片浏览器-MWPhotoBrowserDemo"];
    
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
    
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    if ([@"ActionSheetPickerTableViewController" isEqualToString:className]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ActionSheetPickerDemo" bundle:nil];

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
