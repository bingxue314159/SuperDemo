//
//  TYGUIButtonViewController.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/2.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  自定义不规则按钮的点击事件的响应区域

#import <UIKit/UIKit.h>
#import "TYGUIButton.h"

@interface TYGUIButtonViewController : UIViewController

@property (weak, nonatomic) IBOutlet TYGUIButton *button1;

- (IBAction)switchValueChanged:(UISwitch *)sender;
- (IBAction)buttonClick:(UIButton *)sender;

@end
