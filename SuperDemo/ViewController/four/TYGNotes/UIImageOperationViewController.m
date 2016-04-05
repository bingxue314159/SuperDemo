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
    
    
    UIImage *image2 = [image addText:@"自定义水印" inRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *image3 = [image2 addImage:[UIImage imageNamed:@"AMPOP-red"] inRect:CGRectMake(20, 30, 50, 50)];

    imageView.image = image3;
}

@end
