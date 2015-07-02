//
//  MJScrollViewController.m
//  MJRefreshExample
//
//  Created by 谈宇刚 on 14-10-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJScrollViewController.h"
#import "MJRefresh.h"

@interface MJScrollViewController ()

@end

@implementation MJScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 2.集成刷新控件
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.5);
    [self.view addSubview:self.scrollView];
    
//    [self.scrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.scrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing) dateKey:@"mjScorll"];
    
#warning 自动刷新(一进入程序就下拉刷新)
//    [self.scrollView headerBeginRefreshing];
    [self.scrollView.header beginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.scrollView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.scrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据

    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格

        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.scrollView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加假数据

    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.scrollView footerEndRefreshing];
    });
}


@end
