//
//  TYGMapAnnotation.h
//  testTabBar
//
//  Created by tanyugang on 15/8/10.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//
//  Map的标注

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TYGMapAnnotation : UIView<MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D  coordinate;
@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString  *subtitle;
@property (nonatomic,strong) id obj;

- (id)initWithCoordinate:(CLLocationCoordinate2D)temp_coordinate;

@end
