//
//  TYGUIButton.m
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/28.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//

#import "TYGUIButton.h"

@implementation TYGUIButton

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

@end
