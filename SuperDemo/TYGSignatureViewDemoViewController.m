//
//  TYGSignatureViewDemoViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/11/26.
//  Copyright © 2015年 TYG. All rights reserved.
//

#import "TYGSignatureViewDemoViewController.h"
#import "TYGSignatureView.h"
#import "TYGSignatureViewQuartz.h"
#import "TYGSignatureViewQuartzQuadratic.h"
#import "TYGSignatureLineView.h"

#import "TYG_allHeadFiles.h"

@interface TYGSignatureViewDemoViewController (){
    
    TYGSignatureViewQuartz *view1;
    TYGSignatureViewQuartzQuadratic *view2;
    TYGSignatureView *view3;
    TYGSignatureLineView *view4;
    
}

@end

@implementation TYGSignatureViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.38f animations:^{
        if (nil == view1) {
            view1 = [[TYGSignatureViewQuartz alloc] init];
            view1.frame = self.signatureView.bounds;
            view1.backgroundColor = [Utility RandomColor];
        }
        [self.signatureView addSubview:view1];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)seg:(UISegmentedControl *)sender {
    
    SAFE_emptyView(self.signatureView);
    self.signatureView.tag = sender.selectedSegmentIndex;
    
    switch (sender.selectedSegmentIndex) {
        case 0:{
            //连点成线
            if (nil == view1) {
                view1 = [[TYGSignatureViewQuartz alloc] init];
                view1.frame = self.signatureView.bounds;
                view1.backgroundColor = [Utility RandomColor];
            }
            
            [self.signatureView addSubview:view1];
            break;
        }
        case 1:{
            //二次贝塞尔曲线
            if (nil == view2) {
                view2 = [[TYGSignatureViewQuartzQuadratic alloc] init];
                view2.frame = self.signatureView.bounds;
                view2.backgroundColor = [Utility RandomColor];
            }
            
            [self.signatureView addSubview:view2];
            break;
        }
        case 2:{
            //可变的笔刷宽度
            if (nil == view3) {
                view3 = [[TYGSignatureView alloc] init];
                view3.frame = self.signatureView.bounds;
                view3.backgroundColor = [Utility RandomColor];
                
                view3.strokeColor = [UIColor redColor];
            }
            
            [self.signatureView addSubview:view3];
            break;
        }
        case 3:{
            //油墨笔
            if (nil == view4) {
                view4 = [[TYGSignatureLineView alloc] init];
                view4.frame = self.signatureView.bounds;
                view4.backgroundColor = [Utility RandomColor];
                
                view4.lineColor = [UIColor redColor];
            }
            
            [self.signatureView addSubview:view4];
            break;
        }
        default:
            break;
    }
    
    // Erase with long press
    self.signatureView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longer.cancelsTouchesInView = YES;
    [self.signatureView addGestureRecognizer:longer];
}

//长按事件
- (void)longPress:(UILongPressGestureRecognizer *)lp {
    UIView *view = lp.view;

    switch (view.tag) {
        case 0:{
            if (view1) {
                [view1 erase];
            }
            
            break;
        }
        case 1:{
            if (view2) {
                [view2 erase];
            }
            break;
        }
        case 2:{
            if (view3) {
                [view3 erase];
            }
            break;
        }
        case 3:{
            if (view4) {
                [view4 erase];
            }
            break;
        }
        default:
            break;
    }
    
}
@end
