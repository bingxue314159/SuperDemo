//
//  TYG_UIItems.m
//  2013002-­2
//
//  Created by  tanyg on 13-8-27.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "TYG_UIItems.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+TYGOperation.h"
#import "CommonHeader.h"
@implementation TYG_UIItems

/**
 * 功能：创建指定行数的label对象（行数不足的，返回最大实际行数）
 * 参数：text-内容 font--字体 width--行宽 lines--行数
 * 返回：label
 */
+(UILabel *)labelCreatLinesLabel:(NSString *)text font:(UIFont *)font width:(CGFloat)width lines:(NSInteger)lines{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor  blackColor];
    label.text = text;
    label.numberOfLines = lines;
    
    //计算文本宽度，如果文本宽度 小于 frame.width，那么取文本宽度的值
    CGFloat labW = width;
    CGSize labelS = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    if (labelS.width < labW) {
        labW = labelS.width;
    }
    
    //计算字体高度
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    
    CGFloat labH = labelS.height;//不限高
    if (lines > 0) {
        //限高
        labH = MIN(labH, textSize.height * lines);
    }
    
    //新建新的frame
    CGRect newFrame = CGRectMake(0, 0, labW, labH);
    label.frame = newFrame;
    
    return label;
}

/**
 *  计算文本的size
 *  @param text       原始文本
 *  @param widthValue 最大宽度
 *  @param font       字体
 *  @return size
 */
+ (CGSize)findSizeForText:(NSString *)text maxWidth:(CGFloat)widthValue andFont:(UIFont *)font{
    CGSize size = CGSizeZero;
    if (text){
        CGSize textSize = { widthValue, CGFLOAT_MAX };       //Width and height of text area
        
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        //iOS 7
        CGRect frame = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:font }
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height+1);
#else
        //iOS 6.0
        size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
#endif
        
    }
    return size;
}

/**
 *  创建虚线
 *  @param lineViewFrame 虚线frame
 *  @param lineLength    虚线每段的长度
 *  @param lineSpacing   虚线每段的间隔
 *  @param lineColor     虚线颜色
 *  @return 虚线
 */
+ (UIView *)drawDashLineWithLineFrame:(CGRect)lineViewFrame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor{
    
    UIView *lineView = [[UIView alloc] initWithFrame:lineViewFrame];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2.0, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
    
    return lineView;
}


@end
