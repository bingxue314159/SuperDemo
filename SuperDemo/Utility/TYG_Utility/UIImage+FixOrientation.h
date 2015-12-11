//
//  UIImage+FixOrientation.h
//  2013002-­2
//
//  Created by  tanyg on 13-10-23.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
/**
 *  解决UIImage图片旋转
 *  说明：iOS程序中使用系统相机拍照和从相册选取图片，直接上传后在非mac OS/iOS系统下看到的图片会发生旋转的现象
 *  那是因为我们没有通过图片的旋转属性修改图片导致的。
 *  下面的方法可以很简单的解决旋转问题。
 */

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)

/**
 *  修复图片的方向(如果可以，建议先降低图片分辨率再修复)
 *  @return UIImage
 */
- (UIImage *)fixOrientation;

@end
