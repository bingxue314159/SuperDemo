//
//  TYGStarRationViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/5/4.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGStarRationViewController.h"
#import "HCSStarRatingView.h"

@interface TYGStarRationViewController ()

@end

@implementation TYGStarRationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    starRatingView.maximumValue = 10;
    starRatingView.minimumValue = 0;
    starRatingView.value = 4.5f;
    starRatingView.allowsHalfStars = NO;
    starRatingView.spacing = 5;
    starRatingView.tintColor = [UIColor redColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:starRatingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
}


@end
