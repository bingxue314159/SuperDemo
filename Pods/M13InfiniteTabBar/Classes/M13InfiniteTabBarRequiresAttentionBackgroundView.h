//
//  M13InfiniteTabBarRequiresAttentionBackgroundView.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 1/17/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**The view that is shown under the M13InfiniteTabBar to show that a specific tab that is off screen requires attention.*/
@interface M13InfiniteTabBarRequiresAttentionBackgroundView : UIView

/**Show that a tab off the left edge requires attention.
 @param importanceLevel The importance level of the off screen information. The higer the number, the more importance. Entering 0 will end the animation.*/
- (void)showAnimationOnLeftEdgeWithImportanceLevel:(NSInteger)importanceLevel;
/**Show that a tab off the right edge requires attention.
 @param importanceLevel The importance level of the off screen information. The higer the number, the more importance. Entering 0 will end the animation.*/
- (void)showAnimationOnRightEdgeWithImportanceLevel:(NSInteger)importanceLevel;


@end
