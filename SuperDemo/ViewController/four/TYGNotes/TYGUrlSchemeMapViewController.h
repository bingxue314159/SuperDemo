//
//  TYGUrlSchemeMapViewController.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/18.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  URL Scheme的方式打开第APP外地图

#import <UIKit/UIKit.h>

@interface TYGUrlSchemeMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField10;
@property (weak, nonatomic) IBOutlet UITextField *textField20;
@property (weak, nonatomic) IBOutlet UITextField *textField21;

- (IBAction)buttonClick:(UIButton *)sender;

@end
