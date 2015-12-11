//
//  AnimationViewController.m
//  StudyiOS
//
//  Created by ZhangYiCheng on 11-9-28.
//  Copyright 2011 ZhangYiCheng. All rights reserved.
//

#import "AnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.7   // 动画持续时间(秒)

@implementation AnimationViewController

@synthesize blueView;
@synthesize greenView;
@synthesize typeID;

#pragma mark Load
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark Core Animation
- (IBAction)buttonPressed1:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    switch (tag) {
        case 101:
            animation.type = kCATransitionFade;
            break;
        case 102:
            animation.type = kCATransitionPush;
            break;
        case 103:
            animation.type = kCATransitionReveal;
            break;
        case 104:
            animation.type = kCATransitionMoveIn;
            break;
        case 201:
            animation.type = @"cube";
            break;
        case 202:
            animation.type = @"suckEffect";
            break;
        case 203:
            animation.type = @"oglFlip";
            break;
        case 204:
            animation.type = @"rippleEffect";
            break;
        case 205:
            animation.type = @"pageCurl";
            break;
        case 206:
            animation.type = @"pageUnCurl";
            break;
        case 207:
            animation.type = @"cameraIrisHollowOpen";
            break;
        case 208:
            animation.type = @"cameraIrisHollowClose";
            break;
        default:
            break;
    }
    
    switch (self.typeID) {
        case 0:
            animation.subtype = kCATransitionFromLeft;
            break;
        case 1:
            animation.subtype = kCATransitionFromBottom;
            break;
        case 2:
            animation.subtype = kCATransitionFromRight;
            break;
        case 3:
            animation.subtype = kCATransitionFromTop;
            break;
        default:
            break;
    }
    self.typeID += 1;
    if (self.typeID > 3) {
        self.typeID = 0;
    }
    
    NSUInteger green = [[self.view subviews] indexOfObject:self.greenView];
    NSUInteger blue = [[self.view subviews] indexOfObject:self.blueView];
    [self.view exchangeSubviewAtIndex:green withSubviewAtIndex:blue];
    
    [[self.view layer] addAnimation:animation forKey:@"animation"];
}

#pragma mark UIView动画
- (IBAction)buttonPressed2:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:kDuration];
    switch (tag) {
        case 105:
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
            break;
        case 106:
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
            break;
        case 107:
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
            break;
        case 108:
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            break;
        default:
            break;
    }
    
    NSUInteger green = [[self.view subviews] indexOfObject:self.greenView];
    NSUInteger blue = [[self.view subviews] indexOfObject:self.blueView];
    [self.view exchangeSubviewAtIndex:green withSubviewAtIndex:blue];
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用某个方法
    //[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView commitAnimations];
}


@end
