//
//  File_tyg.h
//  UVCTLib
//
//  Created by 谈宇刚 on 13-6-21.
//  Copyright (c) 2013年 谈宇刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface File : NSObject

/**
 * 功能：截屏
 * 参数：view:需要截屏的界面；imageFrame:需要截图的区域
 * 返回：UIImage对象
 **/
+ (UIImage *)ImageGetScreenShotImage:(UIView *)view imageFrame:(CGRect)imageFrame;


/**
 * 功能：读取沙箱目录下的影像文件
 * 参数：imgName影像文件名；scale:缩放倍率
 * 返回：UIImage对象
 */
+ (UIImage*)ImageGetImage:(NSString*)imgName scale:(CGFloat)scale;

/*
 * 功能：等比率缩放图片
 * 参数：image-图片 scaleSize-缩放比例
 * 返回：image
 */
+ (UIImage *)ImageScaleImage:(UIImage *)image toScale:(float)scaleSize;

/*
 * 功能：自定长宽
 * 参数：image-图片 reSize-新的size
 * 返回：image
 */
+ (UIImage *)ImageReSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/*
 *功能：根据给定得图片，从其指定区域截取一张新得图片
 *参数：image-图片 frame:截取区域
 *返回：UIImage-截取后的图片
 */
+(UIImage *)ImageGetImageFromImage:(UIImage *)image frame:(CGRect)myImageRect;

/*
 *功能：存储图像
 *参数：image-图片
 *返回：bool-是否存储成功
 */
+ (BOOL) ImageSaveImage:(UIImage *)image;

@end
