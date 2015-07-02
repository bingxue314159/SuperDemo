//
//  TYGUzysViewController.h
//  SuperDemo
//
//  Created by tanyugang on 15/5/25.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  照片选取器

#import <UIKit/UIKit.h>

@interface TYGUzysViewController : UIViewController

@property (nonatomic,weak) IBOutlet UIButton *btnImage;
@property (nonatomic,weak) IBOutlet UIButton *btnVideo;
@property (nonatomic,weak) IBOutlet UIButton *btnImageOrVideo;
@property (nonatomic,weak) IBOutlet UIButton *btnImageAndVideo;
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UILabel *labelDescription;

@end
