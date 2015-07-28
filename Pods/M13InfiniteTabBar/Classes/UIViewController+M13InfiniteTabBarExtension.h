//
//  UIViewController+M13InfiniteTabBarExtension.h
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 3/3/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13InfiniteTabBarItem.h"
#import "M13InfiniteTabBarController.h"

/**Extension for UIViewControllers to allow setting of their infinite tab bar item, like one would for a UITabBarItem.*/
@interface UIViewController (M13InfiniteTabBarExtension)

/**Set the infinite tab bar item for the view controller.
 @param item The new tab bar item for the view controller.*/
- (void)setInfiniteTabBarItem:(M13InfiniteTabBarItem *)item;
/**Get the infinite tab bar item for the view controller.
 @return The infinite tab bar item for the view controller.*/
- (M13InfiniteTabBarItem *)infiniteTabBarItem;

/**Set the infinite tab bar controller for the view controller.
 @param item The new tab bar controller for the view controller.*/
- (void)setInfiniteTabBarController:(M13InfiniteTabBarController *)controller;
/**Get the infinite tab bar controller for the view controller.
 @return The infinite tab bar controller for the view controller.*/
- (M13InfiniteTabBarController *)infiniteTabBarController;

@end
