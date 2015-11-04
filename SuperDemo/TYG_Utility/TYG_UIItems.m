//
//  TYG_UIItems.m
//  2013002-­2
//
//  Created by  tanyg on 13-8-27.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "TYG_UIItems.h"
#import <QuartzCore/QuartzCore.h>
#import "File.h"
#import "CommonHeader.h"
@implementation TYG_UIItems

/**
 * 功能：创建button对象
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType
 * 返回：button对象
 */
+(UIButton *)buttonCreatButton:(NSString *)buttonTitle font:(UIFont *)font buttonType:(UIButtonType)buttonType{
    
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.titleLabel.font = font;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:Color_Text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    CGSize titleSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
   
    button.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    button.showsTouchWhenHighlighted = YES;
    return button;
}

/**
 * 功能：创建导航栏上的退出按钮
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType
 * 返回：button对象
 */
+(UIButton *)buttonCreatExitButton{
    
    CGFloat buttonBackW = 30;
    CGFloat buttonBackH = 30;
    CGFloat buttonBackX = 0;
    CGFloat buttonBackY = 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = GET_IMAGE(@"exit_OFF", @"png");
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    button.frame = CGRectMake(buttonBackX, buttonBackY, buttonBackW, buttonBackH);
    
    button.showsTouchWhenHighlighted = YES;
    return button;
}

/**
 * 功能：创建导航栏上的返回按钮
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType
 * 返回：button对象
 */
+(UIButton *)buttonCreatReturnButton{
    
    CGFloat buttonBackW = 44;
    CGFloat buttonBackH = 44;
    CGFloat buttonBackX = 0;
    CGFloat buttonBackY = 0;
    CGSize imageSize = CGSizeMake(25, 25);
    
    UIImage *backOffImage = GET_IMAGE(@"back_OFF", @"png");
    backOffImage = [File ImageReSizeImage:backOffImage toSize:imageSize];
    UIImage *backOnImage = GET_IMAGE(@"back_ON", @"png");
    backOnImage = [File ImageReSizeImage:backOnImage toSize:imageSize];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:backOffImage forState:UIControlStateNormal];
    [button setImage:backOnImage forState:UIControlStateHighlighted];
    button.frame = CGRectMake(buttonBackX, buttonBackY, buttonBackW, buttonBackH);
    
//    button.backgroundColor = [UIColor yellowColor];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    button.showsTouchWhenHighlighted = YES;
    
    return button;
}

/**
 * 功能：创建导航栏上的更多按钮
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType
 * 返回：button对象
 */
+(UIButton *)buttonCreatMoreButton{
    
//    CGFloat buttonBackW = 30;
//    CGFloat buttonBackH = 30;
//    CGFloat buttonBackX = 0;
//    CGFloat buttonBackY = 0;
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:GET_IMAGE(@"more_ON", @"png") forState:UIControlStateNormal];
//    [button setBackgroundImage:GET_IMAGE(@"more_OFF", @"png") forState:UIControlStateHighlighted];
//    button.frame = CGRectMake(buttonBackX, buttonBackY, buttonBackW, buttonBackH);
//    button.showsTouchWhenHighlighted = YES;
//    
//    return button;
    
    NSString *buttonTitle = @"更多";

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    CGSize titleSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    
    button.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    button.showsTouchWhenHighlighted = YES;
    return button;
    
}

//功能：创建一条直线
+(UIButton *)buttonCreatLine:(CGRect)frame lineColor:(UIColor *)lineColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    if (lineColor) {
        button.backgroundColor = lineColor;
    }
    else{
        button.backgroundColor = [UIColor blackColor];
    }
    return button;
}

/**
 * 功能：创建带 图片 的按钮
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType imageSize-图片大小
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageButton:(UIImage *) buttonImage highlightedImage:(UIImage *) highlightedImage imageSize:(CGSize)imageSize{
    
    CGFloat buttonBackW = imageSize.width;
    CGFloat buttonBackH = imageSize.height;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonBackW, buttonBackH);
    button.showsTouchWhenHighlighted = YES;
    
    buttonImage = [File ImageReSizeImage:buttonImage toSize:imageSize];
    highlightedImage = [File ImageReSizeImage:highlightedImage toSize:imageSize];
    
    //按钮图片
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    
    return button;
}

/*
 * 功能：创建图标
 * 参数：buttonImage-图票 buttonSize-图标大小
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageButton:(UIImage *) buttonImage buttonSize:(CGSize)buttonSize{
    
    CGFloat buttonBackW = buttonSize.width;
    CGFloat buttonBackH = buttonSize.height;
    buttonImage = [File ImageReSizeImage:buttonImage toSize:buttonSize];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonBackW, buttonBackH);
    button.showsTouchWhenHighlighted = YES;
    
    //按钮图片
//    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImage:buttonImage forState:UIControlStateSelected];
    [button setImage:buttonImage forState:UIControlStateNormal];
    return button;
}

/**
 * 功能：创建带 图片+文字 的按钮
 * 参数：按钮标题-buttonTitle 按钮图片-buttonImage，highlightedImage font-文字字体，图片大小根据文字大小自动计算
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageTitleButton:(UIImage *) buttonImage
                        highlightedImage:(UIImage *) highlightedImage
                                   title:(NSString *) buttonTitle
                              titleColor:(UIColor *)titleColor
                                    font:(UIFont *)font
                              buttonType:(UIButtonType)buttonType{
    
    UIButton *button = [UIButton buttonWithType:buttonType];
    
    //标题大小
    CGSize titleSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:font}];
    
    //处理图片，定义其大小
    CGSize imageSize = CGSizeMake(titleSize.height, titleSize.height);
    buttonImage = [File ImageReSizeImage:buttonImage toSize:imageSize];
    highlightedImage = [File ImageReSizeImage:highlightedImage toSize:imageSize];
    
    //按钮图片
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setImage:highlightedImage forState:UIControlStateSelected];
    //    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, titleSize.width/2)];

    //按钮文字
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button.titleLabel setContentMode:UIViewContentModeCenter];
    [button.titleLabel setBackgroundColor:[UIColor clearColor]];
    [button.titleLabel setFont:font];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    else{
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    CGFloat titleOffsetRight = 10;
    //    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, ititleOffsetRight, 0, 0)];
    
    button.frame = CGRectMake(0, 0, imageSize.width + titleSize.width + titleOffsetRight, titleSize.height);
    button.showsTouchWhenHighlighted = YES;
    
    return button;
}

/**
 * 功能：创建带 图片+文字 的按钮
 * 参数：按钮标题-buttonTitle 按钮图片-buttonImage，highlightedImage
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageTitleButton:(UIImage *) buttonImage
                                   title:(NSString *) buttonTitle
                              titleColor:(UIColor *)titleColor
                                    font:(UIFont *)font
                              buttonType:(UIButtonType)buttonType{
    
    UIButton *button = [self buttonCreatImageTitleButton:buttonImage highlightedImage:buttonImage title:buttonTitle titleColor:titleColor font:font buttonType:buttonType];
    return button;
}

/**
 * 功能：创建带 图片按钮(单图,文字左，图右)
 * 参数：按钮标题-buttonTitle 按钮图片-buttonImage
 * 返回：button对象
 */
+(UIButton *)buttonCreatSaiXuanButton:(UIImage *) buttonImage
                                title:(NSString *) buttonTitle
                           titleColor:(UIColor *)titleColor
                                 font:(UIFont *)font
                           buttonType:(UIButtonType)buttonType{
    
    UIButton *button = [UIButton buttonWithType:buttonType];
    
    //标题大小
    CGSize titleSize = [buttonTitle sizeWithAttributes:@{NSFontAttributeName:font}];
    //处理图片，定义其大小
    CGSize imageSize = CGSizeMake(titleSize.height-10, titleSize.height+10);
    buttonImage = [File ImageReSizeImage:buttonImage toSize:imageSize];
    
    //按钮图片
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width*2, 0, 0)];//top,left,bottom,right
    [button.imageView setContentMode:UIViewContentModeRight];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    
    //按钮文字
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button.titleLabel setContentMode:UIViewContentModeLeft];
    [button.titleLabel setBackgroundColor:[UIColor clearColor]];
    [button.titleLabel setFont:font];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    else{
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    CGFloat titleOffsetRight = 0;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imageSize.width*2)];//top,left,bottom,right
    
    button.frame = CGRectMake(0, 0, imageSize.width + titleSize.width + titleOffsetRight, titleSize.height);
    button.showsTouchWhenHighlighted = YES;
    return button;
}

/**
 * 功能：创建label对象（高度根据文本内容长度自适应）
 * 参数：文本内容-text 对象位置和大小-frame
 * 返回：label对象
 */
+(UILabel *)labelCreatMutableLabel:(NSString *)text font:(UIFont *)font frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor  blackColor];
    label.text = text;
    label.numberOfLines = 0;
    
    
    //计算文本宽度，如果文本宽度 小于 frame.width，那么取文本宽度的值
    CGFloat labW = frame.size.width;
    CGSize labelS = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    if (labelS.width < labW) {
        labW = labelS.width;
    }
    
    //计算文本高度
    CGSize labelSize = [text boundingRectWithSize:CGSizeMake(labW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    CGFloat labH = labelSize.height;
    
    //新建新的frame
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, labW, labH);
    label.frame = newFrame;
    
    return label;
}

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
    CGSize labelS = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    if (labelS.width < labW) {
        labW = labelS.width;
    }
    
    //计算字体高度
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    
    //计算文本高度
    CGSize labelSize = [text boundingRectWithSize:CGSizeMake(labW, textSize.height*lines) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    CGFloat labH = labelSize.height;
    
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
        
        if (SystemVersion >= 7.0){
            //iOS 7
            CGRect frame = [text boundingRectWithSize:textSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName:font }
                                              context:nil];
            size = CGSizeMake(frame.size.width, frame.size.height+1);
        }
        else{
            //iOS 6.0
            size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        }
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
