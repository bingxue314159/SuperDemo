//
//  kDropDownSelectDemo.h
//  SuperDemo
//
//  Created by tanyugang on 15/4/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"

@interface kDropDownSelectDemo : UIViewController<kDropDownListViewDelegate>

- (IBAction)DropDownPressed:(id)sender;
- (IBAction)DropDownSingle:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectedCountryNames;

@end