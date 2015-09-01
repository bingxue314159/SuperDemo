//
//  StyledPageControlTableViewController.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/1.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"
@class PageControlDemoTableViewCell;

@interface StyledPageControlTableViewController : UITableViewController

@end

@interface PageControlDemoTableViewCell : UITableViewCell

@property (nonatomic) StyledPageControl *pageControl;

@end
