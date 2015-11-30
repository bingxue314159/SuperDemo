//
//  TYGSignatureViewQuartzQuadratic.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/11/26.
//  Copyright © 2015年 TYG. All rights reserved.
//
/**
 * 手势签名：二次贝塞尔曲线
 * 相对于连点成线，有很大的改观。棱角不见了，但是作为签名似乎有点乏味。每一处曲线都是等宽的，和用一只真正的钢笔签出来的签名效果相违背。
 */

#import <UIKit/UIKit.h>

@interface TYGSignatureViewQuartzQuadratic : UIView

/**
 *  擦除(清空画板)
 */
- (void)erase;

@end
