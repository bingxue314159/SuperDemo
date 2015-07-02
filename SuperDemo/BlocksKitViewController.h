//
//  BlocksKitViewController.h
//  SuperDemo
//
//  Created by tanyugang on 15/7/1.
//  Copyright © 2015年 TYG. All rights reserved.
//
//  BlockKit测试--为UIKit增加Block回调，是对Cocoa类的一个扩展

#import <UIKit/UIKit.h>

@interface BlocksKitViewController : UIViewController

- (IBAction)buttonClickForUIAlertView:(UIButton *)sender;

- (IBAction)buttonClickForUIActionSheetView:(UIButton *)sender;

- (IBAction)buttonClickForUIMessage:(UIButton *)sender;

@end
