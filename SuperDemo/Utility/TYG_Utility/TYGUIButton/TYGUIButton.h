//
//  TYGUIButton.h
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/28.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//
//  自定义不规则按钮的点击事件的响应区域

#import <UIKit/UIKit.h>

/**
 *  按钮样式
 */
typedef NS_ENUM(NSInteger, TYGUIButtonType){
    
    TYGUIButtonTypeDefalut = 0, /**< 矩形按钮（▢） */
    TYGUIButtonTypeRound = 1,   /**< 圆形按钮（○） */
    TYGUIButtonTypeTriangleUp = 2,    /**< 三角形按钮(▲) */
    TYGUIButtonTypeTriangleDown = 3,    /**< 三角形按钮(▼) */
    TYGUIButtonTypeTriangleLeft = 4,    /**< 三角形按钮(◀) */
    TYGUIButtonTypeTriangleRight = 5    /**< 三角形按钮(▶) */
};

@interface TYGUIButton : UIButton

@property(nonatomic, assign) TYGUIButtonType tygButtonType;

@end
