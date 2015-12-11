//
//  TYGSignatureViewQuartz.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/11/26.
//  Copyright © 2015年 TYG. All rights reserved.
//
/**
 *  手势签名：连点成线
 *  当签名速度较慢时，iOS可以捕获到足够的touch位置信息，让连接起来的直线看起来不那么明显。但是当手指移动速度很快时就有麻烦了。
 */

#import <UIKit/UIKit.h>

@interface TYGSignatureViewQuartz : UIView

/**
 *  擦除(清空画板)
 */
- (void)erase;

@end
