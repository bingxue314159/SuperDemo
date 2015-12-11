//
//  TYGAppVersionViewController.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/18.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  系统版本检测及是否首次启动检测

#import <UIKit/UIKit.h>

@interface TYGAppVersionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *appVersionTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionTextField;
@property (weak, nonatomic) IBOutlet UITextField *licTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UISwitch *updateSwitch;

- (IBAction)updateAction:(id)sender;

@end
