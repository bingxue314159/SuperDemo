//
//  UIImageView+Badge.m
//  youjiaba
//
//  Created by 谈宇刚 on 14-11-20.
//  Copyright (c) 2014年 uvct. All rights reserved.
//

#import "UIImageView+Badge.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (Badge)

//按钮右上角显示数字
- (UILabel *)badgeNumber:(int)number
{
    UILabel *badgerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 12)];
    badgerLab.layer.cornerRadius =  6.0;
    badgerLab.layer.masksToBounds = YES;
    badgerLab.backgroundColor = [UIColor darkGrayColor];
    badgerLab.textColor = [UIColor whiteColor];
    badgerLab.text = [NSString stringWithFormat:@"%d",number];
    badgerLab.textAlignment = NSTextAlignmentCenter;
    badgerLab.center = CGPointMake(self.frame.size.width, 0);
    badgerLab.font = [UIFont systemFontOfSize:8];
    badgerLab.adjustsFontSizeToFitWidth = YES;
    badgerLab.tag = 100;
    [self addSubview:badgerLab];
    
    return badgerLab;
}

- (void)setBadgeNumber:(int)badgenumber
{
    if (self) {
        UILabel *lab = (UILabel *)[self viewWithTag:100];
        if (lab == nil) {
            lab = [self badgeNumber:badgenumber];
        }
        
        if (badgenumber == 0) {
            lab.hidden = YES;
        }
        else {
            lab.hidden = NO;
            lab.text = [NSString stringWithFormat:@"%d",badgenumber];
        }
    }
}

//按钮右上角显示图片
-(UIImageView *)badgeImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = CGRectMake(0, 0, 10, 10);
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.center = CGPointMake(self.frame.size.width, 5);
    imageView.tag = 200;

    [self addSubview:imageView];
    
    return imageView;
}

-(void)setBadgeImage:(UIImage *)image{
    if (self) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:200];
        if (imageView == nil) {
            imageView = [self badgeImage:image];
        }
        
        if (image) {
            imageView.hidden = NO;
            imageView.image = image;
        }
        else{
            imageView.hidden = YES;
        }
    }
}


@end
