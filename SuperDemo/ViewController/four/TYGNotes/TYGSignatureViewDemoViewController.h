//
//  TYGSignatureViewDemoViewController.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/11/26.
//  Copyright © 2015年 TYG. All rights reserved.
//
//  手势签名DEMO

#import <UIKit/UIKit.h>

@interface TYGSignatureViewDemoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *signatureView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

- (IBAction)seg:(UISegmentedControl *)sender;

@end
