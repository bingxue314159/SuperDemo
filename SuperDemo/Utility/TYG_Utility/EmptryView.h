//
//  EmptryView.h
//  2013002-­2
//
//  Created by  tanyg on 13-11-7.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
/**
 * @brief 空白视图，实现点击后自动退出
 * @author 谈宇刚
 * @date 13-11-7
 */

#import <UIKit/UIKit.h>

@interface EmptryView : UIView

/**
 * 传入对象，以让对象释放焦点
 */
@property (nonatomic,strong) id target;

/**
 * 传入对象数组，以让对象释放焦点
 */
@property (nonatomic,strong)NSArray *targetArray;

@end
