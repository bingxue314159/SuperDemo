//
//  UIImageOperationViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 16/3/23.
//  Copyright © 2016年 TYG. All rights reserved.
//

#import "UIImageOperationViewController.h"
#import <Masonry.h>
#import "UIImage+TYGOperation.h"

#import "TYG_allHeadFiles.h"

@interface UIImageOperationViewController ()

@end

@implementation UIImageOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    [self drawMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMainView{
    

    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(self.view);

    }];
    
    UIImage *image = [UIImage imageNamed:@"blue.jpg"];
    imageView.image = image;
    
    //添加图片水印
    CGFloat imageW = 150;
    CGFloat imageH = 150;
    CGFloat imageX = (image.size.width - imageW)/2.0;
    CGFloat imageY = (image.size.height - imageW)/2.0;
    UIImage *image2 = [image addImage:[UIImage imageNamed:@"SuperDemoIcon"] inRect:CGRectMake(imageX, imageY, imageW, imageH)];
    
    //添加文字水印
    NSString *text = @"自定义水印";
    CGSize titleSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}];
    
    CGFloat textW = titleSize.width;
    CGFloat textH = titleSize.height;
    CGFloat textX = (image.size.width - textW)/2.0;
    CGFloat textY = imageY + imageH + 4;
    
    UIImage *image3 = [image2 addText:@"自定义水印" textColor:[UIColor whiteColor] inRect:CGRectMake(textX, textY, textW, textH)];
    ;

    imageView.image = image3;
}

@end
