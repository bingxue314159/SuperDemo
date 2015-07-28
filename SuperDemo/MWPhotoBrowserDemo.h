//
//  MWPhotoBrowserDemo.h
//  SuperDemo
//
//  Created by tanyugang on 15/7/28.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  照片浏览器

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MWPhotoBrowserDemo : UITableViewController<MWPhotoBrowserDelegate> {
    UISegmentedControl *_segmentedControl;
    NSMutableArray *_selections;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

- (void)loadAssets;

@end
