//
//  EmptryView.m
//  2013002-­2
//
//  Created by  tanyg on 13-11-7.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "EmptryView.h"

@implementation EmptryView

- (id) init{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapGes];
        
    }
    return self;
}

- (void)viewClick:(UITapGestureRecognizer *)tapGes{
    
    if (self && [self subviews]) {
        for (UIView *view in [self subviews]) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }
    
    if (self.target) {
        [self.target resignFirstResponder];
    }
    
    if (self.targetArray) {
        for (id targ in self.targetArray) {
            if (targ && [targ respondsToSelector:@selector(resignFirstResponder)]) {
                [targ resignFirstResponder];
            }
        }
    }
    
}

@end
