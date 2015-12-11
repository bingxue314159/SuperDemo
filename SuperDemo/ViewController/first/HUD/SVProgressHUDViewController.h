//
//  SVProgressHUDViewController.h
//  SVProgressHUD
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  HUB

#import <UIKit/UIKit.h>

@interface SVProgressHUDViewController : UIViewController

- (IBAction)show;
- (IBAction)showWithStatus;

- (IBAction)dismiss;
- (IBAction)dismissInfo;
- (IBAction)dismissSuccess;
- (IBAction)dismissError;

@end

