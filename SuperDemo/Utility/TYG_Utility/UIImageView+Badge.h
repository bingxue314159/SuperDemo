//
//  UIImageView+Badge.h
//  youjiaba
//
//  Created by 谈宇刚 on 14-11-20.
//  Copyright (c) 2014年 uvct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Badge)

//按钮右上角显示数字
- (void)setBadgeNumber:(int)badgenumber;

//按钮右上角显示图片
-(void)setBadgeImage:(UIImage *)image;

@end
