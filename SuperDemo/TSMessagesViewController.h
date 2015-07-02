//
//  TSMessagesViewController.h
//  SuperDemo
//
//  Created by tanyugang on 15/4/21.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  弹出消息

#import <UIKit/UIKit.h>

@interface TSMessagesViewController : UIViewController

- (IBAction)didTapError:(id)sender;
- (IBAction)didTapWarning:(id)sender;
- (IBAction)didTapMessage:(id)sender;
- (IBAction)didTapSuccess:(id)sender;
- (IBAction)didTapButton:(id)sender;
- (IBAction)didTapDismissCurrentMessage:(id)sender;
- (IBAction)didTapEndless:(id)sender;
- (IBAction)didTapLong:(id)sender;
- (IBAction)didTapBottom:(id)sender;
- (IBAction)didTapText:(id)sender;
- (IBAction)didTapCustomDesign:(id)sender;
- (IBAction)didTapNavbarHidden:(id)sender;


@end
