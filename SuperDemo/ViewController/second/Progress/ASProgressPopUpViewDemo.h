//
//  ASProgressPopUpViewDemo.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  直接在进度栏上显示进度的百分比，并提供颜色和不同效果的定制

#import <UIKit/UIKit.h>
#import "ASProgressPopUpView.h"

@interface ASProgressPopUpViewDemo : UIViewController

@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView1;
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView2;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UIButton *continuousButton;

@end
