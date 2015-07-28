//
//  PulsingRequiresAttentionView.m
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 1/17/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "PulsingRequiresAttentionView.h"


@implementation PulsingRequiresAttentionView
{
    NSInteger _leftImportanceLevel;
    NSInteger _rightImportanceLevel;
    
    CAShapeLayer *_leftShapeLayer;
    CAShapeLayer *_rightShapeLayer;
    UIView *_leftMaskView;
    UIView *_rightMaskView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    _leftMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2.0, self.frame.size.height)];
    _rightMaskView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, self.frame.size.height)];
    _leftMaskView.clipsToBounds = YES;
    _rightMaskView.clipsToBounds = YES;
    _leftMaskView.backgroundColor = [UIColor clearColor];
    _rightMaskView.backgroundColor = [UIColor clearColor];
    [self addSubview:_leftMaskView];
    [self addSubview:_rightMaskView];
    
    _leftShapeLayer = [CAShapeLayer layer];
    _rightShapeLayer = [CAShapeLayer layer];
    _leftShapeLayer.fillColor = [UIColor colorWithRed:0.75 green:0.24 blue:0.15 alpha:0.5].CGColor;
    _rightShapeLayer.fillColor = [UIColor colorWithRed:0.75 green:0.24 blue:0.15 alpha:0.5].CGColor;
    
    [_leftMaskView.layer addSublayer:_leftShapeLayer];
    [_rightMaskView.layer addSublayer:_rightShapeLayer];
    
    _thickness = 1.0;
    _distance = 5.0;
}

- (void)showAnimationOnLeftEdgeWithImportanceLevel:(NSInteger)importanceLevel
{
    _leftImportanceLevel = importanceLevel;
    [self createAnimation];
}

- (void)showAnimationOnRightEdgeWithImportanceLevel:(NSInteger)importanceLevel
{
    _rightImportanceLevel = importanceLevel;
    [self createAnimation];
}

- (void)setPulseColor:(UIColor *)pulseColor
{
    _leftShapeLayer.fillColor = pulseColor.CGColor;
    _rightShapeLayer.fillColor = pulseColor.CGColor;
    [self createAnimation];
}

- (void)setPulseDuration:(CGFloat)pulseDuration
{
    _pulseDuration = pulseDuration;
    [self createAnimation];
}

- (void)layoutSubviews
{
    _leftMaskView.frame = CGRectMake(0, 0, self.frame.size.width / 2.0, self.frame.size.height);
    _rightMaskView.frame = CGRectMake(self.frame.size.width / 2.0, 0, self.frame.size.width / 2.0, self.frame.size.height);
    //Need to recreate the animation with the correct float values.
    [self createAnimation];
}

- (void)createAnimation
{
    //Animation key
    static NSString *pulseAnimationKey = @"pulseAnimation";
    //Create the new paths
    if (_leftImportanceLevel == 0) {
        _leftShapeLayer.path = nil;
        //Remove the animation if it exists
        if ([_leftShapeLayer animationForKey:pulseAnimationKey] != nil) {
            [_leftShapeLayer removeAnimationForKey:pulseAnimationKey];
        }
    } else {
        //// Bezier Drawing
        CGFloat initialX = 0.0;
        CGMutablePathRef pathRef = CGPathCreateMutable();
        for (int i = 0; i < _leftImportanceLevel; i++) {
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(initialX + (self.frame.size.height / 2.0), self.frame.size.height)];
            [bezierPath addLineToPoint: CGPointMake(initialX, self.frame.size.height / 2.0)];
            [bezierPath addLineToPoint: CGPointMake(initialX + (self.frame.size.height / 2.0), 0)];
            [bezierPath addLineToPoint: CGPointMake(initialX + (self.frame.size.height / 2.0) + _thickness, 0)];
            [bezierPath addLineToPoint: CGPointMake(initialX + _thickness, self.frame.size.height / 2.0)];
            [bezierPath addLineToPoint: CGPointMake(initialX + (self.frame.size.height / 2.0) + _thickness, self.frame.size.height)];
            [bezierPath addLineToPoint: CGPointMake(initialX + (self.frame.size.height / 2.0), self.frame.size.height)];
            [bezierPath closePath];
            
            CGPathAddPath(pathRef, nil, bezierPath.CGPath);
            initialX += _distance + _thickness;
        }
        _leftShapeLayer.frame = CGRectMake(0, 0, initialX + (self.frame.size.height / 2.0) +_thickness, self.frame.size.height);
        _leftShapeLayer.path = pathRef;
        
		CGPathRelease(pathRef);
        if ([_leftShapeLayer animationForKey:pulseAnimationKey] != nil) {
            [_leftShapeLayer removeAnimationForKey:pulseAnimationKey];
        }
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
        opacityAnimation.keyPath = @"opacity";
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.duration = 0.3;
        opacityAnimation.repeatCount = 1.0;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
        
        CABasicAnimation *postitionAnimation = [[CABasicAnimation alloc] init];
        postitionAnimation.keyPath = @"position";
        postitionAnimation.removedOnCompletion = NO;
        postitionAnimation.duration = 1.0;
        postitionAnimation.repeatCount = 1.0;
        postitionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_leftMaskView.frame.size.width, self.frame.size.height / 2.0)];
        postitionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(- _leftShapeLayer.frame.size.width, self.frame.size.height / 2.0)];
        postitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[opacityAnimation, postitionAnimation];
        animationGroup.duration = 1.0;
        animationGroup.repeatCount = MAXFLOAT;
        
        [_leftShapeLayer addAnimation:animationGroup forKey:pulseAnimationKey];
    }
    
    if (_rightImportanceLevel == 0) {
        _rightShapeLayer.path = nil;
        
        //Remove the animation if it exists
        if ([_rightShapeLayer animationForKey:pulseAnimationKey] != nil) {
            [_rightShapeLayer removeAnimationForKey:pulseAnimationKey];
        }
    } else {
        //// Bezier Drawing
        CGFloat initialX = 0.0;
        CGMutablePathRef pathRef = CGPathCreateMutable();
        for (int i = 0; i < _rightImportanceLevel; i++) {
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(initialX + _thickness, self.frame.size.height)];
            [bezierPath addLineToPoint: CGPointMake(initialX + (self.frame.size.height / 2.0) + _thickness, self.frame.size.height / 2.0)];
            [bezierPath addLineToPoint: CGPointMake(initialX + _thickness, 0)];
            [bezierPath addLineToPoint: CGPointMake(initialX, 0)];
            [bezierPath addLineToPoint: CGPointMake(initialX + (self.frame.size.height / 2.0), self.frame.size.height / 2.0)];
            [bezierPath addLineToPoint: CGPointMake(initialX, self.frame.size.height)];
            [bezierPath addLineToPoint: CGPointMake(initialX + _thickness, self.frame.size.height)];
            [bezierPath closePath];
            
            CGPathAddPath(pathRef, nil, bezierPath.CGPath);
            initialX += _distance + _thickness;
        }
        _rightShapeLayer.frame = CGRectMake(0, 0, initialX + (self.frame.size.height / 2.0) + _thickness, self.frame.size.height);
        _rightShapeLayer.path = pathRef;
		CGPathRelease(pathRef);
        
        if ([_rightShapeLayer animationForKey:pulseAnimationKey] != nil) {
            [_rightShapeLayer removeAnimationForKey:pulseAnimationKey];
        }
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
        opacityAnimation.keyPath = @"opacity";
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.duration = 0.3;
        opacityAnimation.repeatCount = 1.0;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
        
        CABasicAnimation *postitionAnimation = [[CABasicAnimation alloc] init];
        postitionAnimation.keyPath = @"position";
        postitionAnimation.removedOnCompletion = NO;
        postitionAnimation.duration = 1.0;
        postitionAnimation.repeatCount = 1.0;
        postitionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(- _rightShapeLayer.frame.size.width, self.frame.size.height / 2.0)];
        postitionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_rightMaskView.frame.size.width + _rightShapeLayer.frame.size.width, self.frame.size.height / 2.0)];
        postitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[opacityAnimation, postitionAnimation];
        animationGroup.duration = 1.0;
        animationGroup.repeatCount = MAXFLOAT;
        
        [_rightShapeLayer addAnimation:animationGroup forKey:pulseAnimationKey];
    }
}

@end
