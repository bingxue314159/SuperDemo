//
//  UIScrollView+JJCenterScroll.m
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import "UIScrollView+JJCenterScroll.h"

@implementation UIScrollView (JJCenterScroll)

- (void)scrollRectToCenter:(CGRect)rect animated:(BOOL)animated {
    
    CGSize scrollSize = self.bounds.size;
    CGFloat x = CGRectGetMidX(rect) - ((scrollSize.width - rect.size.width) / 2.0f) - (rect.size.width / 2.0f);
    CGFloat y = CGRectGetMidY(rect) - ((scrollSize.height - rect.size.height) / 2.0f) - (rect.size.height / 2.0f);
    
    x = (x < 0 ? 0 : x);
    y = (y < 0 ? 0 : y);
    
    CGSize contentSize = self.contentSize;
    CGPoint maxContentOffset = CGPointMake(contentSize.width - scrollSize.width, contentSize.height - scrollSize.height);
    x = (x > maxContentOffset.x ? maxContentOffset.x : x);
    y = (y > maxContentOffset.y ? maxContentOffset.y : y);
    
    [self setContentOffset:CGPointMake(x, y) animated:animated];

}

- (void)setContentSizeWithMarginSize:(CGSize)margin {
    
    CGSize contentSize = self.bounds.size;
    
    NSArray *childs = self.subviews;
    for (UIView *child in childs) {
        
        CGRect frame = child.frame;
        contentSize.width = MAX(contentSize.width, CGRectGetMaxX(frame));
        contentSize.height = MAX(contentSize.height, CGRectGetMaxY(frame));
    }
    
    self.contentSize = contentSize;
}

@end
