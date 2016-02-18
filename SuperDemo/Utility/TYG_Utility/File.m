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

@end
