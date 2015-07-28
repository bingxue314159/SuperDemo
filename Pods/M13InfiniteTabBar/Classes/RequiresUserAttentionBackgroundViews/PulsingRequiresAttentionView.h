//
//  PulsingRequiresAttentionView.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 1/17/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "M13InfiniteTabBarRequiresAttentionBackgroundView.h"

/**A subclass of `M13InfiniteTabBarRequiresAttentionBacckgroundView`. It uses pulsing chevrons to alert users that an off screen tab requires user attention.*/
@interface PulsingRequiresAttentionView : M13InfiniteTabBarRequiresAttentionBackgroundView

/**@name Appearance*/
/**The color of the pulses.*/
@property (nonatomic, retain) UIColor *pulseColor;
/**The duration of a pulse.*/
@property (nonatomic, assign) CGFloat pulseDuration;
/**The thickness of the chevron.*/
@property (nonatomic, assign) CGFloat thickness;
/**The distance between chevrons.*/
@property (nonatomic, assign) CGFloat distance;


@end
