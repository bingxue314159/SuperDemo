//
//  UIImage+FixOrientation.h
//  2013002-­2
//
//  Created by  tanyg on 13-10-23.
//  Copyright (c) 2013年 2013002-­2. All rights reserved.
//
//  解决UIImage图片旋转
//  iOS程序中使用系统相机拍照和从相册选取图片，直接上传后在非mac系统下看到的图片会发生旋转的现象
//  那是因为我们没有通过图片的旋转属性修改图片倒置的。
//  下面的方法可以很简单的解决旋转问题：

#import <UIKit/UIKit.h>

@interface UIImage (FixOrientation)

- (UIImage *)fixOrientation;

@end
