//
//  POPDecayAnimationViewController.h
//  SuperDemo
//
//  Created by tanyugang on 15/7/30.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POPDecayAnimationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popCircle;
@property (weak, nonatomic) IBOutlet UISlider *velocitySlider;
@property (weak, nonatomic) IBOutlet UISlider *decelerationSlider;

- (IBAction)sliderValueChange:(id)sender;

@end
