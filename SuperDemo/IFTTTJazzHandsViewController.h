//
//  IFTTTJazzHandsViewController.h
//  JazzHandsDemo
//
//  Created by Devin Foley on 9/27/13.
//  Copyright (c) 2013 IFTTT Inc. All rights reserved.
//

#import "IFTTTJazzHands.h"
@class IFTTTCircleView;

@interface IFTTTJazzHandsViewController : IFTTTAnimatedPagingScrollViewController

@end

@interface IFTTTCircleView : UIView

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end