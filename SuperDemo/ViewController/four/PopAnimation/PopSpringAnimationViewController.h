//
//  PopSpringAnimationViewController.h
//  SuperDemo
//
//  Created by tanyugang on 15/7/30.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopSpringAnimationViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (weak, nonatomic) IBOutlet UISlider *bouncinessSlider;
@property (weak, nonatomic) IBOutlet UISlider *speedSlide;
@property (weak, nonatomic) IBOutlet UISlider *tensionSlide;
@property (weak, nonatomic) IBOutlet UISlider *frictionSlide;
@property (weak, nonatomic) IBOutlet UISlider *massSlide;
- (IBAction)slideValueChange:(id)sender;


@property (weak, nonatomic) IBOutlet UISwitch *tensionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *frictionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *massSwitch;
- (IBAction)switchValueChange:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
- (IBAction)segValueChange:(id)sender;

@end
