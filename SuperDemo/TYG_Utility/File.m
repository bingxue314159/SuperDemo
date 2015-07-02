//
//  File_tyg.m
//  UVCTLib
//
//  Created by 谈宇刚 on 13-6-21.
//  Copyright (c) 2013年 谈宇刚. All rights reserved.
//

#import "File.h"

@interface File()
@end

@implementation File
/**
 * 功能：截屏
 * 参数：view:需要截屏的界面；imageFrame:需要截图的区域
 * 返回：UIImage对象
 **/
+ (UIImage *)ImageGetScreenShotImage:(UIView *)view imageFrame:(CGRect)imageFrame{
    //截图
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);//设置截屏大小
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (CGRectEqualToRect(imageFrame, CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))) {
        return viewImage;
    }
    else if (CGRectEqualToRect(imageFrame, CGRectZero)){
        return viewImage;
    }
    
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect = imageFrame;//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);

    return [UIImage imageWithCGImage:imageRefRect];
}

/*
 *功能：读取沙箱目录下的影像文件,图片等比例缩放
 *参数：imgName-图片名称（从系统中读取图片文件）scale-缩放比例
 *返回：UIImage-缩放后的图片
 */
+(UIImage*)ImageGetImage:(NSString *)imgName scale:(CGFloat)scale{
    if(imgName==nil||imgName==NULL) return nil;
    
    NSArray* arr=[imgName componentsSeparatedByString:@"."];
    NSString* name=[arr objectAtIndex:0];
    NSString* type=[arr objectAtIndex:1];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    UIImage* img=[UIImage imageWithContentsOfFile:path];
    
    if (scale >= 1.0) {
        return img;
    }
    
    CGSize size=CGSizeMake(img.size.width*scale, img.size.height*scale);
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    [img drawInRect:rect];
    UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImg;
}

/*
 *功能：根据给定得图片，从其指定区域截取一张新得图片 
 *参数：image-图片 frame:截取区域
 *返回：UIImage-截取后的图片
 */
+(UIImage *)ImageGetImageFromImage:(UIImage *)image frame:(CGRect)myImageRect{
    //大图image
    //定义myImageRect，截图的区域

    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, myImageRect);
    UIGraphicsBeginImageContextWithOptions(myImageRect.size,NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, imageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return smallImage;
}

/*
 *功能：存储图像
 *参数：image-图片
 *返回：bool-是否存储成功
 */ 
+ (BOOL) ImageSaveImage:(UIImage *)image{
    
//    存储到目录文件
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"image.jpg"];
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    
//    存储到图片库
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    return YES;
}


/*
 * 功能：等比率缩放图片
 * 参数：image-图片 scaleSize-缩放比例
 * 返回：image
 */
+ (UIImage *)ImageScaleImage:(UIImage *)image toScale:(float)scaleSize{
    
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/*
 * 功能：自定长宽
 * 参数：image-图片 reSize-新的size
 * 返回：image
 */
+ (UIImage *)ImageReSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    if (reSize.width == 0) {
        reSize.width = reSize.height *image.size.width/image.size.height;
    }
    if (reSize.height == 0) {
        reSize.height = reSize.width *image.size.height/image.size.width;
    }
    
//    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

/*
 * 功能：自定义图片在内存中的大小
 * 参数：image-图片 newSize-内存中的大小（kb）
 * 返回：image
 **/
+ (UIImage *) ImageReSizeImage:(UIImage *)image newSize:(CGFloat) newSize{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat imageSize = [File getFileSize:data];
    
    CGFloat imageSale = 0.5;//设置图片压缩率
    CGFloat lastSize;
    while (imageSize > newSize) {
        lastSize = imageSize;
        data = UIImageJPEGRepresentation(image, imageSale);
        imageSize = [File getFileSize:data];
        image = [UIImage imageWithData:data];

        if (lastSize == imageSize) {
            break;
        }
    }
    
    return image;
}

/*
 *功能：获取文件大小
 *参数：data文件的二进制
 *返回：文件大小，单位：kb
 */
+(CGFloat)getFileSize:(NSData *)data{
    //如果对象很大的话， 会遇到 内存紧张时 崩溃的情况
    CGFloat fileLong = [data length];
    CGFloat perMBBytes = 1024;
    CGFloat fileSize = (fileLong / perMBBytes) * 10;
    NSLog(@"File message:fileSize = %f",fileSize);
    
    return fileSize;
}

/* 方法一
 * 功能：iOS程序中使用系统相机拍照和从相册选取图片，直接上传后在非mac系统下看到的图片会发生旋转的现象,此处修复此问题
 * 参数：image-image orientation-照片的属性image.imageOrientation
 * 返回: image
 */
+ (UIImage *)imageFixOrientation:(UIImage *)image
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    UIImageOrientation orientation = image.imageOrientation;//图片拍照时的方向
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
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
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


/* 方法二
 * 功能：iOS程序中使用系统相机拍照和从相册选取图片，直接上传后在非mac系统下看到的图片会发生旋转的现象,此处修复此问题
 * 参数：image-image orientation-照片的属性image.imageOrientation
 * 返回: image
 */
+(UIImage *)imageFixOrientation2:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
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
