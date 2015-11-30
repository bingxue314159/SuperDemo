//
//  TYGSignatureLineView.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/11/30.
//  Copyright © 2015年 TYG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYGSignatureLineView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) BOOL empty;

/**
 *  擦除(清空画板)
 */
- (void)erase;

@end
