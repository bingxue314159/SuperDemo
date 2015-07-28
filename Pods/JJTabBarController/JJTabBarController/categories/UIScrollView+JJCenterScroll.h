//
//  UIScrollView+JJCenterScroll.h
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Extra functionality to the UIScrollView.
 */
@interface UIScrollView (JJCenterScroll)

/**
 *  Set the new contentOffset so the rect is in the center.
 *
 *  @param rect     frame to be centered
 *  @param animated is movement animated
 */
- (void)scrollRectToCenter:(CGRect)rect animated:(BOOL)animated;

/**
 *  Set contentSize based on the margin and the farthermost subview.
 *
 *  @param margin margin from contentSize
 */
- (void)setContentSizeWithMarginSize:(CGSize)margin;

@end
