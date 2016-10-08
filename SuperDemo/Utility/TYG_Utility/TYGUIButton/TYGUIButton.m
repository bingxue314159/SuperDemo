//
//  TYGUIButton.m
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/28.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//

#import "TYGUIButton.h"

@implementation TYGUIButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.midSpacing = 8;
    }
    return self;
}

/**
 * 系统发生触摸事件的时候会从window到父控件到子控件一个个检测触摸点是否在其中
 * 如果在其中，则返回YES，最后返回YES的子控件作为响应事件的控件。
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL res = [super pointInside:point withEvent:event];
    BOOL flag = NO;
    
    if (res) {
        switch (self.tygButtonType) {
            case TYGUIButtonTypeDefalut:{
                //矩形
                UIBezierPath* path = [UIBezierPath bezierPathWithRect: self.bounds];
                if ([path containsPoint:point]) {
                    //如果在path区域内，返回YES
                    flag = YES;
                }
                break;
            }
            case TYGUIButtonTypeRound:{
                //圆形 - 绘制一个圆形path
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
                if ([path containsPoint:point]) {
                    //如果在path区域内，返回YES
                    flag = YES;
                }
                break;
            }
            case TYGUIButtonTypeTriangleUp:{
                //三角形按钮(▲)
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.bounds.size.width/2,0)];
                [path addLineToPoint:CGPointMake(0,self.bounds.size.height)];
                [path addLineToPoint:CGPointMake(self.bounds.size.width,self.bounds.size.height)];
                [path addLineToPoint:CGPointMake(self.bounds.size.width/2,0)];
                if ([path containsPoint:point]) {
                    //如果在path区域内，返回YES
                    flag = YES;
                }
                break;
            }
            case TYGUIButtonTypeTriangleDown:{
                //三角形(▼)
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.bounds.size.width/2,self.bounds.size.height)];
                [path addLineToPoint:CGPointMake(0,0)];
                [path addLineToPoint:CGPointMake(self.bounds.size.width,0)];
                [path addLineToPoint:CGPointMake(self.bounds.size.width/2,self.bounds.size.height)];
                if ([path containsPoint:point]) {
                    //如果在path区域内，返回YES
                    flag = YES;
                }
                break;
            }
            case TYGUIButtonTypeTriangleLeft:{
                //三角形(◀)
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0,self.bounds.size.height/2)];
                [path addLineToPoint:CGPointMake(self.bounds.size.width,0)];
                [path addLineToPoint:CGPointMake(self.bounds.size.width,self.bounds.size.height)];
                [path addLineToPoint:CGPointMake(0,self.bounds.size.height/2)];
                if ([path containsPoint:point]) {
                    //如果在path区域内，返回YES
                    flag = YES;
                }
                break;
            }
            case TYGUIButtonTypeTriangleRight:{
                //三角形(▶)
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0,0)];
                [path addLineToPoint:CGPointMake(self.bounds.size.width,self.bounds.size.height/2)];
                [path addLineToPoint:CGPointMake(0,self.bounds.size.height)];
                [path addLineToPoint:CGPointMake(0,0)];
                if ([path containsPoint:point]) {
                    //如果在path区域内，返回YES
                    flag = YES;
                }
                break;
            }
            default:
                break;
        }
    }
    
    return flag;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    switch (self.layoutStyle) {
        case JXLayoutButtonStyleLeftImageRightTitle:
            [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
            break;
        case JXLayoutButtonStyleLeftTitleRightImage:
            [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
            break;
        case JXLayoutButtonStyleUpImageDownTitle:
            [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
            break;
        case JXLayoutButtonStyleUpTitleDownImage:
            [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
            break;
        default:
            break;
    }
}

- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    CGRect leftViewFrame = leftView.frame;
    CGRect rightViewFrame = rightView.frame;
    
    CGFloat totalWidth = CGRectGetWidth(leftViewFrame) + self.midSpacing + CGRectGetWidth(rightViewFrame);
    
    leftViewFrame.origin.x = (CGRectGetWidth(self.frame) - totalWidth) / 2.0;
    leftViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(leftViewFrame)) / 2.0;
    leftView.frame = leftViewFrame;
    
    rightViewFrame.origin.x = CGRectGetMaxX(leftViewFrame) + self.midSpacing;
    rightViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(rightViewFrame)) / 2.0;
    rightView.frame = rightViewFrame;
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView {
    CGRect upViewFrame = upView.frame;
    CGRect downViewFrame = downView.frame;
    
    CGFloat totalHeight = CGRectGetHeight(upViewFrame) + self.midSpacing + CGRectGetHeight(downViewFrame);
    
    upViewFrame.origin.y = (CGRectGetHeight(self.frame) - totalHeight) / 2.0;
    upViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(upViewFrame)) / 2.0;
    upView.frame = upViewFrame;
    
    downViewFrame.origin.y = CGRectGetMaxY(upViewFrame) + self.midSpacing;
    downViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(downViewFrame)) / 2.0;
    downView.frame = downViewFrame;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setNeedsLayout];
}

@end
