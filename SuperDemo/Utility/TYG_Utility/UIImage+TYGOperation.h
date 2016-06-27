//
//  UIImage+TYGOperation.h
//  SuperDemo
//
//  Created by 谈宇刚 on 16/3/23.
//  Copyright © 2016年 TYG. All rights reserved.
//
/**
 *  描述：对图片的各种操作
 *  作者：谈宇刚
 *  日期：2016年3月23日
 *  版本：1.0
 */

#import <UIKit/UIKit.h>

@interface UIImage (TYGOperation)

/**
 *  添加文字水印
 *  @param text      文字
 *  @param textColor 文字颜色
 *  @param rect      绘制的区域
 *  @return 加好水印的图片
 */
- (UIImage *)addText:(NSString *)text textColor:(UIColor *)textColor inRect:(CGRect)rect;

/**
 *  添加图片水印
 *  @param addImage 水印图片
 *  @param rect     绘制的区域
 *  @return 加好水印的图片
 */
- (UIImage *)addImage:(UIImage *)addImage inRect:(CGRect)rect;

/**
 *  截图
 *  @param view       需要截屏的界面
 *  @param imageFrame 需要截图的区域
 *  @return 截图
 */
- (UIImage *)getScreenShotImage:(UIView *)view imageFrame:(CGRect)imageFrame;

/**
 *  根据给定得图片，从其指定区域截取一张新得图片
 *  @param image       图片
 *  @param myImageRect 截取区域
 *  @return UIImage-截取后的图片
 */
-(UIImage *)getImageFromFrame:(CGRect)myImageRect;

/*
 * 功能：自定长宽
 * 参数：image-图片 reSize-新的size
 * 返回：image
 */
- (UIImage *)reSizeToSize:(CGSize)reSize;

/**
 *  压缩图片到指定文件大小
 *  @param image 原始图片
 *  @param size  指定图片物理大小
 *  @return 图片二进制文件
 */
+ (NSData *)compressOrigianlImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 *  生成纯色图片
 *  @param color 颜色
 *  @param alpha 透明度
 *  @return UIImage
 */
- (UIImage*)imageByColor:(UIColor*)color Alpha:(CGFloat)alpha;

//  解决UIImage图片旋转
//  iOS程序中使用系统相机拍照和从相册选取图片，直接上传后在非mac系统下看到的图片会发生旋转的现象
//  那是因为我们没有通过图片的旋转属性修改图片倒置的。
//  下面的方法可以很简单的解决旋转问题：

/**
 *  修复照片方向(默认方法)
 *  @return image
 */
- (UIImage *)fixOrientation;

/**
 * 修复照片方向(方法一)
 * 返回: image
 */
- (UIImage *)imageFixOrientation1;

/**
 * 修复照片方向(方法二)
 * 返回: image
 */
- (UIImage *)imageFixOrientation2;

@end
