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

@interface TYG_UIItems : NSObject

/**
 * 功能：创建指定行数的label对象（行数不足的，返回最大实际行数）
 * 参数：text-内容 font--字体 width--行宽 lines--行数
 * 返回：label
 */
+(UILabel *)labelCreatLinesLabel:(NSString *)text font:(UIFont *)font width:(CGFloat)width lines:(NSInteger)lines;

/**
 *  计算文本的size
 *  @param text       原始文本
 *  @param widthValue 最大宽度
 *  @param font       字体
 *  @return size
 */
+ (CGSize)findSizeForText:(NSString *)text maxWidth:(CGFloat)widthValue andFont:(UIFont *)font;

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
