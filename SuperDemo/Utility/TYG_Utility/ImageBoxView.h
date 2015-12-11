//
//  ImageBoxView.h
//  图像显示框，支持缩放、网络图像异步加载等
//  Created by 谈宇刚 on 13-6-21.
//  Copyright (c) 2013年 谈宇刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBoxView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *imageView;

- (void)setImageView:(UIImageView *) imageEgoView;
- (void)showInView:(UIView *)view;
- (void)dissMissWithAnimation:(BOOL)animation;
@end
