//
//  TYGMapAnnotation.m
//  testTabBar
//
//  Created by tanyugang on 15/8/10.
//  Copyright (c) 2015年 tanyugang. All rights reserved.
//

#import "TYGMapAnnotation.h"

@implementation TYGMapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)temp_coordinate{
    if ([super  init])
    {
        self.coordinate = temp_coordinate;
    }
    return  self;
}

@end
