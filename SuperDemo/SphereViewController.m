//
//  SphereViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/4/21.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "SphereViewController.h"
#import "ZYQSphereView.h"
#import "CommonHeader.h"

@interface SphereViewController (){
    ZYQSphereView *sphereView;
    NSTimer *timer;
}

@end

@implementation SphereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2.0, 10, 300, 300)];
    sphereView.center=CGPointMake(self.view.center.x, (SCREEN_HEIGHT - NavBarHeight)/2.0);
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50; i++) {
        UIButton *subV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        subV.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1];
        [subV setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        subV.layer.masksToBounds=YES;
        subV.layer.cornerRadius=3;
        [subV addTarget:self action:@selector(subVClick:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:subV];
        
    }
    
    [sphereView setItems:views];
    
    sphereView.isPanTimerStart=YES;
    
    [self.view addSubview:sphereView];
    [sphereView timerStart];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((SCREEN_WIDTH-120)/2, CGRectGetMaxY(sphereView.frame) + 20, 120, 30);
    [self.view addSubview:btn];
    btn.backgroundColor=[UIColor whiteColor];
    btn.layer.borderWidth=1;
    btn.layer.borderColor=[[UIColor orangeColor] CGColor];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitle:@"start/stop" forState:UIControlStateNormal];
    btn.selected=NO;
    [btn addTarget:self action:@selector(changePF:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)subVClick:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);
    
    BOOL isStart=[sphereView isTimerStart];
    
    [sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform=CGAffineTransformMakeScale(1, 1);
            if (isStart) {
                [sphereView timerStart];
            }
        }];
    }];
}



-(void)changePF:(UIButton*)sender{
    if ([sphereView isTimerStart]) {
        [sphereView timerStop];
    }
    else{
        [sphereView timerStart];
    }
}

@end
