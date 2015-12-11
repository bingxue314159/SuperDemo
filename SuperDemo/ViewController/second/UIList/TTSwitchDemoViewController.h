//
//  TTSwitchDemoViewController.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/1.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTControlItem;
@class TTControlCell;

@interface TTSwitchDemoViewController : UIViewController

@end

@interface TTControlItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIControl *control;

+ (id)itemWithTitle:(NSString *)title control:(UIControl *)control;

@end

@interface TTControlCell : UITableViewCell

@property (nonatomic, strong) TTControlItem *controlItem;

+ (NSString *)cellIdentifier;

@end
