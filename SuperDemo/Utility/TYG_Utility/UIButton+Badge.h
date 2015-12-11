//
//  UIButton+Badge.h
//  ImagePickerDemo
//
//  Created by raozhongxiong on 12-11-23.
//  Copyright (c) 2012年 raozhongxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Badge)

//按钮右上角显示数字
- (void)badgeNumber:(int)number;
- (void)setBadge:(int)badge;

//按钮右上角显示图片
-(void)badgeImage:(UIImage *)image;
-(void)setBadgeImage:(UIImage *)image;

@end
