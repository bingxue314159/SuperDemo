//
//  UIImage+TYGOperation.m
//  SuperDemo
//
//  Created by 谈宇刚 on 16/3/23.
//  Copyright © 2016年 TYG. All rights reserved.
//

#import "UIImage+TYGOperation.h"

@implementation UIImage (TYGOperation)

/**
 *  添加文字水印
 *  @param text      文字
 *  @param textColor 文字颜色
 *  @param rect      绘制的区域
 *  @return 加好水印的图片
 */
- (UIImage *)addText:(NSString *)text textColor:(UIColor *)textColor inRect:(CGRect)rect{
    
    NSAssert(text.length != 0, @"text不能为空");
    NSAssert(textColor != nil, @"textColor不能为空");
    
    //UIGraphicsBeginImageContext(self.size);
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    //在画布中绘制内容
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //绘制文字
    //[textColor set];//颜色
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:30],//设置了字体
                          NSObliquenessAttributeName:@0,//倾斜度
                          NSForegroundColorAttributeName:textColor};//颜色
    [text drawInRect:rect withAttributes:dic];
    
    //从画布中得到image
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return returnImage;
}

/**
 *  添加图片水印
 *  @param addImage 水印图片
 *  @param rect     绘制的区域
 *  @return 加好水印的图片
 */
- (UIImage *)addImage:(UIImage *)addImage inRect:(CGRect)rect{
    
    //UIGraphicsBeginImageContext(self.size);
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    
    //在画布中绘制内容
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];//原图
    
    //水印图
    if (CGRectIsNull(rect)) {
        rect = CGRectMake(0, self.size.height-addImage.size.height, addImage.size.width, addImage.size.height);
    }
    
    [addImage drawInRect:rect];
    
    //从画布中得到image
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultingImage;
}

/**
 *  截图
 *  @param view       需要截屏的界面
 *  @param imageFrame 需要截图的区域
 *  @return 截图
 */
- (UIImage *)getScreenShotImage:(UIView *)view imageFrame:(CGRect)imageFrame{
    //截图
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);//设置截屏大小
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (CGRectEqualToRect(imageFrame, view.bounds) || CGRectEqualToRect(imageFrame, CGRectZero)) {
        return viewImage;
    }
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(viewImage.CGImage, imageFrame);
    
    return [UIImage imageWithCGImage:imageRefRect];
}

/**
 *  根据给定得图片，从其指定区域截取一张新得图片
 *  @param image       图片
 *  @param myImageRect 截取区域
 *  @return UIImage-截取后的图片
 */
-(UIImage *)getImageFromFrame:(CGRect)myImageRect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, myImageRect);
    UIGraphicsBeginImageContextWithOptions(myImageRect.size,NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, imageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return smallImage;
}

/*
 * 功能：自定长宽
 * 参数：image-图片 reSize-新的size
 * 返回：image
 */
- (UIImage *)reSizeToSize:(CGSize)reSize{
    
    if (reSize.width == 0) {
        reSize.width = reSize.height *self.size.width/self.size.height;
    }
    if (reSize.height == 0) {
        reSize.height = reSize.width *self.size.height/self.size.width;
    }
    
    //    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height), NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

/**
 *  压缩图片到指定文件大小
 *  @param image 原始图片
 *  @param size  指定图片物理大小
 *  @return 图片二进制文件
 */
+ (NSData *)compressOrigianlImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01) {
        maxQuality -= 0.01;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length/1000.0;
        if (lastData == dataKBytes) {
            break;
        }
        else{
            lastData = dataKBytes;
        }
    }
    return data;
}

/**
 *  生成纯色图片
 *  @param color 颜色
 *  @param alpha 透明度
 *  @return UIImage
 */
- (UIImage*)imageByColor:(UIColor*)color Alpha:(CGFloat)alpha{
    
    CGRect rect = CGRectMake(0, 0,1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetAlpha(ctx, alpha);
    CGContextFillRect(ctx, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  修复照片方向(默认方法)
 *  @return image
 */
- (UIImage *)fixOrientation{
    
    //文案一：修改图片大小
    //    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    //    CGFloat scale = [UIScreen mainScreen].scale;
    //    CGFloat movs = floorf(self.size.width/screenWidth);//缩小倍数
    //    CGSize imageSize = CGSizeMake(scale * self.size.width/movs, scale * self.size.height/movs);
    
    // No-op if the orientation is already correct
    //    if (self.imageOrientation == UIImageOrientationUp) {
    //        //如果为正向照片，则不用修正，此处跳过，是为了修改照片大小
    //        return reSizeImage;
    //    }
    
    //文案一：保持原始大小
    CGSize imageSize = self.size;
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) {
        //如果为正向照片，则不用修正
        return self;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:{
            break;
        }
        case UIImageOrientationDown:{
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        }
        case UIImageOrientationLeft:{
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imageSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        }
        case UIImageOrientationRight:{
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imageSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        }
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imageSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:{
            transform = CGAffineTransformTranslate(transform, imageSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        }
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:{
            break;
        }
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imageSize.width , imageSize.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imageSize.height,imageSize.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imageSize.width,imageSize.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

/**
 *  修复照片方向
 *  @return image
 */
- (UIImage *)normalizedImage {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

/**
 * 修复照片方向(方法一)
 * 返回: image
 */
- (UIImage *)imageFixOrientation1{
    
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    UIImageOrientation orientation = self.imageOrientation;//图片拍照时的方向
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    //    UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


/**
 * 修复照片方向(方法二)
 * 返回: image
 */
- (UIImage *)imageFixOrientation2{
    
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    //    UIGraphicsBeginImageContext(bounds.size);
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
