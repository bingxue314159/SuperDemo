//
//  TYGSignatureViewQuartzQuadratic.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/11/26.
//  Copyright © 2015年 TYG. All rights reserved.
//

#import "TYGSignatureViewQuartzQuadratic.h"
#import <QuartzCore/QuartzCore.h>

//写一个计算2点中点的方法
static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@interface TYGSignatureViewQuartzQuadratic(){
    UIBezierPath *path;
    CGPoint previousPoint;
}

@end

@implementation TYGSignatureViewQuartzQuadratic

- (void)commonInit {
    path = [UIBezierPath bezierPath];
    
    // Capture touches
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) [self commonInit];
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) [self commonInit];
    return self;
}

- (void)erase {
    path = [UIBezierPath bezierPath];
    [self setNeedsDisplay];
}

//更新手势处理，用二次贝塞尔曲线替换掉之前的直接连接处理
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint midPoint = midpoint(previousPoint, currentPoint);
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [path moveToPoint:currentPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    }
    
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    [path stroke];
}

@end
