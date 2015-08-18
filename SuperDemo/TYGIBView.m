//
//  TYGIBView.m
//  testTabBar
//
//  Created by tanyugang on 15/8/12.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//

#import "TYGIBView.h"

@implementation TYGIBView

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    
    self.layer.cornerRadius = self.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = self.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    
    self.layer.borderColor = self.borderColor.CGColor;
}

- (void)setMasksToBounds:(BOOL)masksToBounds{
    _masksToBounds = masksToBounds;
    
    self.layer.masksToBounds = self.masksToBounds;
}

@end
