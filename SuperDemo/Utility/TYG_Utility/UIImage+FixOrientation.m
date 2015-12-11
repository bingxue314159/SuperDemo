//
//  UIImage+FixOrientation.m
//  2013002-­2
//
//  Created by  tanyg on 13-10-23.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "UIImage+FixOrientation.h"

@implementation UIImage (FixOrientation)

/**
 *  修复图片的方向(如果可以，建议先降低图片分辨率再修复)
 *  @return UIImage
 */
- (UIImage *)fixOrientation {
    
    /*
    //缩小图片分辨率，如果分辨率太大，一次性处理图片过多，会导致内存暴涨
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat movs = floorf(self.size.width/screenWidth);//缩小倍数
    CGSize imageSize = CGSizeMake(scale * self.size.width/movs, scale * self.size.height/movs);//图片最终大小
    */
    
    CGSize imageSize = self.size;
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp && CGSizeEqualToSize(imageSize, self.size)) {
        //如果为正向照片，且如果最终分辨率大小为原始大小，则不用修正
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
//    CGContextRef ctx = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst);
    
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
    
//    NSData *data2 = UIImageJPEGRepresentation(img, 1.0);
//    NSLog(@"FixOrientation imageWidth = %f, imageHeight = %f \n lenght = %lu",img.size.width,img.size.height,(unsigned long)[data2 length]);
    return img;
}

@end
