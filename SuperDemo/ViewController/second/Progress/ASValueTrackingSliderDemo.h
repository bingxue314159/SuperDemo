//
//  ASValueTrackingSliderDemo.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  UISlider 的子类，即时显示了滑块的指示数字，可进行各种效果定制

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"

@interface ASValueTrackingSliderDemo : UIViewController

@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider1;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider2;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider3;

@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;

@end
