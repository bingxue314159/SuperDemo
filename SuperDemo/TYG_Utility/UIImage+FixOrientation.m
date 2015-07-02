//
//  UIImage+FixOrientation.m
//  2013002-­2
//
//  Created by  tanyg on 13-10-23.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//

#import "UIImage+FixOrientation.h"

@implementation UIImage (FixOrientation)

- (UIImage *)fixOrientation {
    
//    NSData *data = UIImageJPEGRepresentation(self, 1.0);
//    NSLog(@"FixOrientation imageWidth = %f, imageHeight = %f \n length = %lu",self.size.width,self.size.height,(unsigned long)[data length]);
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    NSLog(@"screeW = %f",screenWidth);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat movs = floorf(self.size.width/screenWidth);//缩小倍数
    CGSize imageSize = CGSizeMake(scale * self.size.width/movs, scale * self.size.height/movs);
    
    // No-op if the orientation is already correct
//    if (self.imageOrientation == UIImageOrientationUp) {
//        //如果为正向照片，则不用修正，此处跳过，是为了修改照片大小
//        return reSizeImage;
//    }
    
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
