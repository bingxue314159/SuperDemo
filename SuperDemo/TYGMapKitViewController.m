//
//  TYGMapKitViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/18.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGMapKitViewController.h"
#import "TYGMapAnnotation.h"

@interface TYGMapKitViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    
    CLLocationCoordinate2D location;
    CLLocationManager *locationManager;
}

@end

@implementation TYGMapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化位置
    CLLocationDegrees latitude=28.66879;
    CLLocationDegrees longitude=115.925436;
    location=CLLocationCoordinate2DMake(latitude, longitude);
    
    [self drawMainView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    // iPhone OS SDK 8.0 以后版本的处理
    if ([CLLocationManager locationServicesEnabled]) {
        //定位功能
        locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            //用户尚未做出决定是否启用定位服务
            //使用此方法前在要在info.plist中配置NSLocationWhenInUseUsageDescription
            [locationManager requestWhenInUseAuthorization];//iOS8
        }
#else
        // iPhone OS SDK 8.0 之前版本的处理
        
#endif
#endif
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMainView{
    
    self.mapView.zoomEnabled = YES;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //    [self.mapView setCenterCoordinate:location];
    //设置显示区域，所在位置的1000米所在区域
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000 ,1000 );
    
    //如果要显示经纬度表示的(0.05,0.05)范围
    //    MKCoordinateSpan  span=MKCoordinateSpanMake(0.05,0.05);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(location,span);
    
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    //标注
    TYGMapAnnotation *anno = [[TYGMapAnnotation alloc] initWithCoordinate:location];
    anno.title = @"test";
    anno.subtitle = @"test-subTitle";
    [self addAnnotation:anno];
}

//添加标注
- (void)addAnnotation:(TYGMapAnnotation *)anno{
    [self.mapView addAnnotation:anno];
}

#pragma mark - MKMapViewDelegate
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    //地图加载
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    //当成功地取得地图后
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    //当取得地图失败后
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    /**
     * 用户位置发生改变时触发（第一次定位到用户位置也会触发该方法）
     * a.在iOS6或者iOS7中代理方法中设置地图中心区域及显示范围
     * b.在iOS6或者iOS7中,配置通过配置Privacy - Location Usage Description告诉用户使用的目的，同时这个配置是可选的
     * b.iOS8中不需要进行中心点的指定，默认会将当前位置设置中心点并自动设置显示区域范围。
     * c.iOS8中定位功能在设计发生了变化,可以通过配置NSLocationAlwaysUsageDescription或者NSLocationWhenInUseUsageDescription来告诉用户使用定位服务的目的，并且注意这个配置是必须的
     */
    
}

#pragma mark - MKAnnotationView
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    //添加标注
    for (MKPinAnnotationView *mkview in views)
    {
        //判断是否是自己
        if ([mkview.annotation isKindOfClass:[TYGMapAnnotation class]]==NO){
            continue;
        }
        else{
            UIImageView *headImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的_ON"] ];
            //            [headImageView setFrame:CGRectMake(1, 1, 30, 32)];
            mkview.leftCalloutAccessoryView=headImageView;
            
            UIButton  *  rightbutton=[UIButton  buttonWithType:UIButtonTypeDetailDisclosure];
            mkview.rightCalloutAccessoryView=rightbutton;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[TYGMapAnnotation class]]){
        //设置显示的视图的内容
        TYGMapAnnotation * annotation=(TYGMapAnnotation *)view.annotation;
        
        //        UIImageView *headImageView= (UIImageView *) view.leftCalloutAccessoryView ;
        //        UIImageView *headImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VIP_ON@3x"] ];
        //        view.leftCalloutAccessoryView = headImageView;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *placemarkIdentifier = @"MyAnnotationIdentifier";
    
    if ([annotation isKindOfClass:[TYGMapAnnotation class]]) {
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
        if (nil == view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
        }
        else{
            view.annotation = annotation;
        }
        
        [view setImage:[UIImage imageNamed:@"定位3_绿"]];
        view.canShowCallout = YES;
        view.centerOffset = CGPointMake(0, -13);
        
        return view;
    }
    else{
        
        TYGMapAnnotation *mapAnno = (TYGMapAnnotation*)annotation;
        mapAnno.title = @"当前位置";
        
        return nil;
    }
    
}

@end
