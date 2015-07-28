//
//  JJTabBarSegue.m
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import "JJTabBarSegue.h"
#import "JJTabBarController.h"


@implementation JJTabBarSegue

- (void)perform {
    UIViewController *controller = self.sourceViewController;
    if ( [controller isKindOfClass:[JJTabBarController class]] ) {
        JJTabBarController *tabBarController = (JJTabBarController *)controller;
        tabBarController.selectedTabBarChild = self.destinationViewController;
    } else {
        [super perform];
    }
}

@end
