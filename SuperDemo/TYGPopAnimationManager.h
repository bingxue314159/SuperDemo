//
//  TYGPopAnimationManager.h
//  PopDemos
//
//  Created by kevinzhow on 14-5-16.
//  Copyright (c) 2014年 Piner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <POP/POP.h>

@interface TYGPopAnimationManager : NSObject

/**
 *  定制view的pop动效
 *  @param animation 动画对象
 *  @param type      动画类型
 *  @param animated  是否执行动画
 */
+(void)springPopViewConfigAnimation:(POPPropertyAnimation *)animation WithType:(NSString *)type andAnimated:(BOOL)animated;

/**
 *  定制layer的pop动效
 *  @param layer     layer
 *  @param animation 动画对象
 *  @param type      动画类型
 *  @param animated  是否执行动画
 */
+(void)springObject:(CALayer*)layer configAnimation:(POPPropertyAnimation *)animation WithType:(NSString *)type andAnimated:(BOOL)animated;

+(void)decayObject:(CALayer*)layer configAnimation:(POPDecayAnimation *)animation WithType:(NSString *)type andAnimated:(BOOL)animated andVelocitySlider:(UISlider *)slider;

@end
