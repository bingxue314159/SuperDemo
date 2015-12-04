//
//  TYGMasonryTestViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/12/3.
//  Copyright © 2015年 TYG. All rights reserved.
//

#import "TYGMasonryTestViewController.h"
#import "TYG_allHeadFiles.h"

@interface TYGMasonryTestViewController (){
    
    UIView *view0;
}

@end

@implementation TYGMasonryTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self testMasonry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //此处会被调用两次
    NSLog(@"viewDidLayoutSubviews黑色view0.frame = %@",NSStringFromCGRect(view0.frame));
}

//Masonry学习笔记
- (void)testMasonry{
    view0 = [UIView new];
    view0.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view0];//在做autoLayout之前 一定要先将view添加到superview上 否则会报错
    /*
     mas_makeConstraints 只负责新增约束 Autolayout不能同时存在两条针对于同一对象的约束 否则会报错
     mas_updateConstraints 针对上面的情况 会更新在block中出现的约束 不会导致出现两个相同约束的情况
     mas_remakeConstraints 则会清除之前的所有约束 仅保留最新的约束
     
     三种函数善加利用 就可以应对各种情况了
     */
    [view0 mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.center.equalTo(self.view);
        //        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
        //        make.centerX.equalTo(self.view);
        
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(view0.mas_width);
        //        make.bottom.equalTo(self.view).offset(-10 - TabBarHeight);
        
    }];
    
    //[初级] 让一个view略小于其superView(边距为10)
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor redColor];
    [view0 addSubview:view1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view0).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        
        /* 等价于
         make.top.equalTo(sv).with.offset(10);
         make.left.equalTo(sv).with.offset(10);
         make.bottom.equalTo(sv).with.offset(-10);
         make.right.equalTo(sv).with.offset(-10);
         */
        
        /* 也等价于
         make.top.left.bottom.and.right.equalTo(sv).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
         */
    }];
    
    //[初级] 让两个高度为150的view垂直居中且等宽且等间隔排列 间隔为10(自动计算其宽度)
    NSInteger padding1 = 10;
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor orangeColor];
    [view1 addSubview:view2];
    
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor orangeColor];
    [view1 addSubview:view3];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view1.mas_centerY);
        make.left.equalTo(view1.mas_left).with.offset(padding1);
        make.right.equalTo(view3.mas_left).with.offset(-padding1);
        make.height.mas_equalTo(@150);
        make.width.equalTo(view3);
    }];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view1.mas_centerY);
        make.left.equalTo(view2.mas_right).with.offset(padding1);
        make.right.equalTo(view1.mas_right).with.offset(-padding1);
        make.height.mas_equalTo(@150);
        make.width.equalTo(view2);
    }];
    
    //[中级] 在UIScrollView顺序排列一些view并自动计算contentSize
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view2).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    
    UIView *container = [UIView new];
    container.backgroundColor = [UIColor yellowColor];
    container.clipsToBounds = YES;
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        /*
         如果我们需要竖向的滑动 就把width设为和scrollview相同
         如果需要横向的滑动 就把height设为和scrollview相同
         */
        make.width.equalTo(scrollView);
    }];
    
    NSInteger count = 10;
    UIView *lastView = nil;
    for (NSInteger i = 1; i<= count; i++) {
        UIView *tempView = [UIView new];
        [container addSubview:tempView];
        tempView.backgroundColor = [Utility RandomColor];
        
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(container);
            make.height.mas_equalTo(@(20*i));
            
            if (lastView) {
                make.top.mas_equalTo(lastView.mas_bottom).offset(1);
            }
            else{
                //make.top.mas_equalTo(container.mas_top);
                make.top.equalTo(container);
            }
        }];
        
        lastView = tempView;
        
        UILabel *tempLabel = [UILabel new];
        tempLabel.text = SAFE_StringFormInt(i);
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.font = Font_Text(18);
        [tempView addSubview:tempLabel];
        [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(tempView);
        }];
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lastView.mas_bottom);
        //        make.bottom.equalTo(lastView);
    }];
}

@end
