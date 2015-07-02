//
//  ImageBoxView.m
//
//  Created by 谈宇刚 on 13-6-21.
//  Copyright (c) 2013年 谈宇刚. All rights reserved.
//

#import "ImageBoxView.h"

@interface ImageBoxView(){
    CGFloat width,height;
    UIScrollView* scrollViewMain;
    
    CGSize imageSize;
}

@end

@implementation ImageBoxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        width=frame.size.width;
        height=frame.size.height;
  
        //设置背景
        self.frame = frame;
        self.backgroundColor=[UIColor colorWithRed:0.0000 green:0.0000 blue:0.0000 alpha:0.6];
        
        //创建滚动视图
        scrollViewMain=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        scrollViewMain.autoresizesSubviews=YES;
        scrollViewMain.minimumZoomScale=1.0;
        scrollViewMain.maximumZoomScale=4.0;
        scrollViewMain.delegate=self;
        
        //滚动视图加入控件当中
        [self addSubview:scrollViewMain];
    }
    return self;
}


/**
 * 功能：向控件添加显示的UIImageView(如EGOImage)
 * 参数：UIImageView 图像对象
 * 返回值：无
 */
- (void)setImageView:(UIImageView *) imageEgoView{
    _imageView = imageEgoView;

    if(_imageView!=nil&&_imageView!=NULL){
        /*
        //获取imageSize
        UIImage *image = _imageView.image;
        imageSize = image.size;
        if (imageSize.width > width) {
            CGFloat sale = width/imageSize.width;
            imageSize.width *= sale;
            imageSize.height *= sale;
        }
        
        if (imageSize.height > height) {
            CGFloat sale = height/imageSize.height;
            imageSize.width *= sale;
            imageSize.height *= sale;
        }
         */
        _imageView.frame = CGRectMake(0, 0, width, height);
        _imageView.userInteractionEnabled = YES;
        _imageView.autoresizesSubviews = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.center=scrollViewMain.center;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        tapGes.numberOfTapsRequired = 1; // 连续点击次数
        tapGes.numberOfTouchesRequired = 1;// 手指数
        [_imageView addGestureRecognizer:tapGes];
        
        [scrollViewMain addSubview:_imageView];
    }
}

/*
 *功能：图片被点击后，在被双击的位置放大图片
 *参数：tagGes-点击事件
 *返回：null
 */
- (void) imageClick:(UITapGestureRecognizer *)tagGes{
    if (tagGes.numberOfTouchesRequired == 1 && tagGes.numberOfTapsRequired == 1) {
        NSLog(@"ImageBox报文：图片被单击");
        [self dissMissWithAnimation:YES];
        return;
    }
    else if (tagGes.numberOfTouchesRequired == 1 && tagGes.numberOfTapsRequired == 2){
        NSLog(@"ImageBox报文：图片被双击");
    }
    else{
        return;
    }
    
    UIImageView *imageViewTagGes = (UIImageView *)tagGes.view;
    CGFloat imgW=imageViewTagGes.frame.size.width;
    CGFloat imgH=imageViewTagGes.frame.size.height;
    CGFloat maxZoom = scrollViewMain.maximumZoomScale;//设置放大倍率
    
    //动画效果
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.38f];
    
    if (imgW > width || imgH > height) {
        //图片大于容器
        imageViewTagGes.frame=CGRectMake(0, 0, imageSize.width, imageSize.height);
    }
    else{
        imageViewTagGes.frame=CGRectMake(0, 0, imageSize.width * maxZoom, imageSize.height * maxZoom);
    }

    scrollViewMain.contentSize = imageViewTagGes.frame.size;
    
    //scrollView的中心点
    CGFloat cx=scrollViewMain.contentSize.width/2;
    CGFloat cy=scrollViewMain.contentSize.height/2;
    
    //被点击的点的位置
    CGPoint touchPoint = CGPointMake(0, 0);
    for (NSUInteger touchCounter = 0;touchCounter < tagGes.numberOfTouchesRequired;touchCounter++){
        // 循环获得每个手指在view中的坐标点
        touchPoint =[tagGes locationOfTouch:touchCounter inView:tagGes.view];
    }
    
    //设置imageView的中心点
    if(cx>width/2&&cy>height/2){
        CGPoint dd = [imageViewTagGes convertPoint:touchPoint fromView:scrollViewMain];
        scrollViewMain.contentOffset = CGPointMake(dd.x * (maxZoom - 1), dd.y * (maxZoom - 1));
    }
    else{
        imageViewTagGes.center=scrollViewMain.center;
    }
    
    [UIView commitAnimations];
}

#pragma mark - 工具
- (void)showInView:(UIView *)view{
    //动画效果
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.38f];
    
    [view addSubview:self];
    
    [UIView commitAnimations];
}

- (void)dissMissWithAnimation:(BOOL)animation{
    //动画效果
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.38f];
    
    [self removeFromSuperview];
    
    [UIView commitAnimations];
}

#pragma mark - UIScrollViewDelegate

/**
 * 功能：实现接口，用于图像缩放
 */

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

/**
 * 功能：实现接口，用于图像缩放完毕后图像居中显示
 */
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{

    CGFloat cx=scrollView.contentSize.width/2;
    CGFloat cy=scrollView.contentSize.height/2;
    
    if(cx>width/2&&cy>height/2){
        view.center=CGPointMake(cx, cy);
    }
    else{
        view.center=scrollView.center;
    }

}

@end
