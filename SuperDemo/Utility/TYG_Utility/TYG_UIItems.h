//
//  TYG_UIItems.h
//  2013002-­2
//
//  Created by  tanyg on 13-8-27.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
/**
 *  描述：自定义各类UI控件
 *  作者：谈宇刚
 *  日期：2013年8月27日
 *  版本：1.0
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "File.h"

@interface TYG_UIItems : NSObject

/**
 * 功能：创建纯文字按钮
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType fontSize-文字大小
 * 返回：button对象
 */
+(UIButton *)buttonCreatButton:(NSString *)buttonTitle font:(UIFont *)font buttonType:(UIButtonType)buttonType;//创建button对象

+(UIButton *)buttonCreatReturnButton;//创建导航栏上的返回按钮
+(UIButton *)buttonCreatMoreButton;//创建导航栏上的更多按钮
+(UIButton *)buttonCreatExitButton;//创建导航栏上的退出按钮

/**
 * 创建一条直线
 */
+(UIButton *)buttonCreatLine:(CGRect)frame lineColor:(UIColor *)lineColor;

/**
 * 功能：创建带 图片 的按钮
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType imageSize-图片大小
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageButton:(UIImage *) buttonImage highlightedImage:(UIImage *) highlightedImage imageSize:(CGSize)imageSize;

/**
 * 功能：创建图标
 * 参数：buttonImage-图票 buttonSize-图标大小
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageButton:(UIImage *) buttonImage buttonSize:(CGSize)buttonSize;

/**
 * 功能：创建带 图片+文字 的按钮(双图,图左，文字右)
 * 参数：按钮标题-buttonTitle 按钮图片-buttonImage，highlightedImage fontSize-文字字体大小，图片大小根据文字大小自动计算
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageTitleButton:(UIImage *) buttonImage
                        highlightedImage:(UIImage *) highlightedImage
                                   title:(NSString *) buttonTitle
                              titleColor:(UIColor *)titleColor
                                    font:(UIFont *)font
                              buttonType:(UIButtonType)buttonType;

/**
 * 功能：创建带 图片+文字 的按钮(单图,图左，文字右)
 * 参数：按钮标题-buttonTitle 按钮图片-buttonImage，highlightedImage fontSize-文字字体大小，图片大小根据文字大小自动计算
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageTitleButton:(UIImage *) buttonImage
                                   title:(NSString *) buttonTitle
                              titleColor:(UIColor *)titleColor
                                    font:(UIFont *)font
                              buttonType:(UIButtonType)buttonType;

/**
 * 功能：创建带 图片按钮(单图,文字左，图右)
 * 参数：按钮标题-buttonTitle 按钮图片-buttonImage
 * 返回：button对象
 */
+(UIButton *)buttonCreatSaiXuanButton:(UIImage *) buttonImage
                                title:(NSString *) buttonTitle
                           titleColor:(UIColor *)titleColor
                                 font:(UIFont *)font
                           buttonType:(UIButtonType)buttonType;


/**
 * 功能：创建label对象（高度根据文本内容长度自适应）
 * 参数：text-内容 font--字体 frame--frame
 * 返回：label
 */
+(UILabel *)labelCreatMutableLabel:(NSString *)text font:(UIFont *)font frame:(CGRect)frame;

/**
 * 功能：创建指定行数的label对象（行数不足的，返回最大实际行数）
 * 参数：text-内容 font--字体 width--行宽 lines--行数
 * 返回：label
 */
+(UILabel *)labelCreatLinesLabel:(NSString *)text font:(UIFont *)font width:(CGFloat)width lines:(NSInteger)lines;

/**
 *  创建虚线
 *  @param lineViewFrame 虚线frame
 *  @param lineLength    虚线每段的长度
 *  @param lineSpacing   虚线每段的间隔
 *  @param lineColor     虚线颜色
 *  @return 虚线
 */
+ (UIView *)drawDashLineWithLineFrame:(CGRect)lineViewFrame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
@end
