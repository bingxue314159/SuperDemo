//
//  TYGMapKitViewController.h
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/18.
//  Copyright (c) 2015年 TYG. All rights reserved.
//
//  系统自带的地图包，显示地图

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TYGMapKitViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
