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
    CGSize titleSize = [buttonTitle sizeWithFont:button.titleLabel.font];
    
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
 * 功能：创建导航栏上的GPS按钮
 * 参数：按钮标题-buttonTitle type:0,白色图标  1，黑色图标
 * 返回：button对象
 */
+ (UIButton *)buttonCreateGpsButton:(NSString *)buttonTitle type:(NSInteger)type{
    
    UIButton *button;
    if (type == 0) {
        button = [TYG_UIItems buttonCreatImageTitleButton:[UIImage imageNamed:@"定位3_白.png"] title:buttonTitle titleColor:[UIColor whiteColor] font:Font_Button(16) buttonType:UIButtonTypeCustom];
    }
    else{
        button = [TYG_UIItems buttonCreatImageTitleButton:[UIImage imageNamed:@"定位3_黑.png"] title:buttonTitle titleColor:[UIColor blackColor] font:Font_Button(16) buttonType:UIButtonTypeCustom];
    }
    
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
    CGSize titleSize = [buttonTitle sizeWithFont:button.titleLabel.font];
    
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


/**
 * 功能：创建带 图片 可以控制亮灭 的按键
 * 参数：按钮标题-buttonTitle 按钮样式-buttonType buttonSize-buttonSize
 * 返回：button对象
 */
+(UIButton *)buttonCreatImageHighlightedButton:(UIImage *) buttonImage highlightedImage:(UIImage *) highlightedImage buttonSize:(CGSize)buttonSize{
    
    CGFloat buttonBackW = buttonSize.width;
    CGFloat buttonBackH = buttonSize.height;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonBackW, buttonBackH);
    //    button.showsTouchWhenHighlighted = YES;
    //按钮图片
    //    [button.imageView setContentMode:UIViewContentModeScaleToFill];
    [button setImage:buttonImage forState:UIControlStateSelected];
    [button setImage:buttonImage forState:UIControlStateHighlighted];
    [button setImage:highlightedImage forState:UIControlStateNormal];

    button.selected = NO;
    
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
    CGSize titleSize = [buttonTitle sizeWithFont:font];
    
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
    //    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, imageSize.width/2, 0, 0)];
    
    button.frame = CGRectMake(0, 0, imageSize.width + titleSize.width + 10, titleSize.height);
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
    
    UIButton *button = [UIButton buttonWithType:buttonType];
    
    //标题大小
    CGSize titleSize = [buttonTitle sizeWithFont:font];
    //处理图片，定义其大小
    CGSize imageSize = CGSizeMake(titleSize.height, titleSize.height);
    buttonImage = [File ImageReSizeImage:buttonImage toSize:imageSize];
    
    //按钮图片
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    
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
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, titleOffsetRight, 0, 0)];
    
    button.frame = CGRectMake(0, 0, imageSize.width + titleSize.width + titleOffsetRight, titleSize.height);
    button.showsTouchWhenHighlighted = YES;
    return button;
}

/**
 * 功能：创建带 图片的筛选器 的按钮
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
    CGSize titleSize = [buttonTitle sizeWithFont:font];
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
    CGSize labelS = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 0.0) lineBreakMode:NSLineBreakByWordWrapping];
    if (labelS.width < labW) {
        labW = labelS.width;
    }
    
    //计算文本高度
    CGSize labelSize = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(labW, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
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
    CGSize labelS = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 0.0) lineBreakMode:NSLineBreakByWordWrapping];
    if (labelS.width < labW) {
        labW = labelS.width;
    }
    
    //计算字体高度
    CGSize textSize = [text sizeWithFont:label.font];
    
    //计算文本高度
    CGSize labelSize = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(labW, textSize.height*lines) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labH = labelSize.height;
    
    //新建新的frame
    CGRect newFrame = CGRectMake(0, 0, labW, labH);
    label.frame = newFrame;
    
    return label;
}

/*
 * 功能：定义图片pageControl
 * 参数：pageNumber-图片张数
 * 返回：pageControl
 */
+ (UIPageControl *) pageControlCreatPageControl:(NSInteger)pageNumber{
    CGFloat pageContH = 16;
    CGFloat pageContW = pageContH *pageNumber;
    
    CGFloat mainW = [UIScreen mainScreen].applicationFrame.size.width;
    if (pageContW > mainW) {
        pageContH = mainW / pageNumber;
        pageContW = mainW;
    }
    NSLog(@"mainW = %f, pageContW = %f, pageConH = %f",mainW,pageContW,pageContH);
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, pageContW, pageContH)];
    
    [pageControl.layer setCornerRadius:pageContH/2]; // 圆角层
    //    pageControl.layer.masksToBounds = YES;
    //    [pageControl setBounds:CGRectMake(0,0,pageContH*pageNumber,pageContH)]; //页面控件上的圆点间距基本在16左右。
    pageControl.numberOfPages = pageNumber;//指定页面个数
    pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    pageControl.autoresizesSubviews = YES;
    
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];//圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];//被选中的点的颜色
    
    pageControl.hidesForSinglePage = YES;//如果要在仅有一个页面的情况下隐藏指示器
    pageControl.userInteractionEnabled = YES;
    [pageControl setEnabled:YES];
    
    //    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];//添加委托方法，当点击小白点就执行此方法
    
    
    return pageControl;
    
}

/*
 * 功能：绘制用户名，密码输入视图
 * 参数：
 * 返回：
 */
+ (UIView *)drawUserPasswordView:(CGRect)frame{
    return nil;
}

/*
 * 功能：绘制文本输入框
 * 参数：frame-对象大小
 * 返回：UITextField
 */
+ (UITextField *) textFieldCreat:(CGRect)frame{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    //    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.returnKeyType = UIReturnKeyDone;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.contentHorizontalAlignment = NSTextAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;//是否启动自动提醒更正功能
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//键盘自动大小写
    
    return textField;
}

@end
