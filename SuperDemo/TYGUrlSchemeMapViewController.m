//
//  TYGUrlSchemeMapViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/18.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TYGUrlSchemeMapViewController.h"
#import "TYGDinwei.h"
#import <MapKit/MapKit.h>

@interface TYGUrlSchemeMapViewController ()

@end

@implementation TYGUrlSchemeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//系统处事地图应用
- (IBAction)buttonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    switch (sender.tag) {
        case 1:{
            //标注一个点
            NSString *city1 = [self.textField10 text];
            [TYGDinwei getCoordinateByAddress:city1 completionHandler:^(CLPlacemark *placemark, NSError *error) {
                MKPlacemark *mkPlacemake1 = [[MKPlacemark alloc] initWithPlacemark:placemark];
                
                NSDictionary *options = @{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
                MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:mkPlacemake1];
                [mapItem1 openInMapsWithLaunchOptions:options];
            }];
            break;
        }
        case 2:{
            //标注两个点
            NSString *city1 = [self.textField20 text];
            NSString *city2 = [self.textField21 text];
            [TYGDinwei getCoordinateByAddress:city1 completionHandler:^(CLPlacemark *placemark, NSError *error) {
                MKPlacemark *mkPlacemake1 = [[MKPlacemark alloc] initWithPlacemark:placemark];
                
                
                [TYGDinwei getCoordinateByAddress:city2 completionHandler:^(CLPlacemark *placemark2, NSError *error) {
                    MKPlacemark *mkPlacemake2 = [[MKPlacemark alloc] initWithPlacemark:placemark2];
                    
                    NSDictionary *options = @{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};//地图
                    //                    NSDictionary *options2=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};//导航
                    
                    //MKMapItem *mapItem1=[MKMapItem mapItemForCurrentLocation];//当前位置
                    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:mkPlacemake1];
                    MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:mkPlacemake2];
                    [MKMapItem openMapsWithItems:@[mapItem1,mapItem2] launchOptions:options];
                }];
            }];
            
            break;
        }
        case 3:{
            
            [self actionSheet];
            
            break;
        }
        default:
            break;
    }
    
}

//URL Scheme跳转方式地图导航
- (void)actionSheet{
    __block NSString *urlScheme = @"testTabBar://";
    __block NSString *appName = @"testTabBar";
    __block CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(28.66879,115.925436);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //这个判断其实是不需要的
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]){
        
        /**
         * 苹果地图
         * 官方文档：https://developer.apple.com/library/prerelease/ios/documentation/MapKit/Reference/MKMapItem_class/index.html
         * 是否可跳回APP：否
         * 参数说明：
         */
        
        /*
         //方法一
         //NSString *urlString2 = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=Current+Location",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         
         NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=slat,slng",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//不能以当前位置为起点
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
         */
        
        //方法二
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        
        /**
         * 百度地图
         * 官方文档：http://developer.baidu.com/map/index.php?title=uri/api/ios
         * 是否可跳回APP：否
         * 参数说明：
         */
        
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",urlString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        
        /**
         * 高德地图
         * 官方文档：http://lbs.amap.com/api/uri-api/ios-uri-explain/
         * 是否可跳回APP：是
         * 参数说明：
         */
        
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",urlString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        
        /**
         * 谷歌地图
         * 官方文档：https://developers.google.com/maps/documentation/ios/urlscheme
         * 是否可跳回APP：是
         * 参数说明：
         */
        
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",urlString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]){
        
        /**
         * 腾讯地图
         * 官方文档：http://lbs.qq.com/uri_v1/guide-route.html
         * 是否可跳回APP：
         * 参数说明：
         */
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=%f,%f&coord_type=1&policy=0",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",urlString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


@end
