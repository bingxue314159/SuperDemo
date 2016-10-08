//
//  TYGUIButton.h
//  testTabBar
//
//  Created by 谈宇刚 on 15/8/28.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//
/**
 *  自定义不规则按钮的点击事件的响应区域
 *  实现UIButton的上图下文、上文下图、左图右文、右图左文的布局需求
 *
 */


#import <UIKit/UIKit.h>

/**
 *  按钮变形样式
 */
typedef NS_ENUM(NSInteger, TYGUIButtonType){
    
    TYGUIButtonTypeDefalut = 0, /**< 矩形按钮（▢） */
    TYGUIButtonTypeRound = 1,   /**< 圆形按钮（○） */
    TYGUIButtonTypeTriangleUp = 2,    /**< 三角形按钮(▲) */
    TYGUIButtonTypeTriangleDown = 3,    /**< 三角形按钮(▼) */
    TYGUIButtonTypeTriangleLeft = 4,    /**< 三角形按钮(◀) */
    TYGUIButtonTypeTriangleRight = 5    /**< 三角形按钮(▶) */
};


/**
 按钮样式（图片与文字的位置）
 */
typedef NS_ENUM(NSUInteger, JXLayoutButtonStyle) {
    JXLayoutButtonStyleLeftImageRightTitle,
    JXLayoutButtonStyleLeftTitleRightImage,
    JXLayoutButtonStyleUpImageDownTitle,
    JXLayoutButtonStyleUpTitleDownImage
};

@interface TYGUIButton : UIButton

@property (nonatomic, assign) TYGUIButtonType tygButtonType;/**< 按钮变形样式 */
@property (nonatomic, assign) JXLayoutButtonStyle layoutStyle;/**< 按钮布局方式 */
@property (nonatomic, assign) CGFloat midSpacing;/**< 图片和文字的间距，默认值8 */

@end
