//
//  TYGLoadingTableViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/1.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGLoadingTableViewController.h"

@interface TYGLoadingTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *titleArray;
}

@end

@implementation TYGLoadingTableViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [NSMutableArray arrayWithCapacity:10];
        
        self.title = @"启动引导";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [titleArray addObject:@"Onboard-OnboardDemo"];
    [titleArray addObject:@"JazzHands-IFTTTJazzHandsViewController"];
    [titleArray addObject:@"MYBlurIntroductionView-MYBlurIntroductionDemo"];
    
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
