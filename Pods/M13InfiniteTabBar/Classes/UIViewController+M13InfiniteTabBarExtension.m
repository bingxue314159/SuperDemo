//
//  UIViewController+M13InfiniteTabBarExtension.m
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 3/3/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "UIViewController+M13InfiniteTabBarExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (M13InfiniteTabBarExtension)

- (void)setInfiniteTabBarItem:(M13InfiniteTabBarItem *)item
{
    objc_setAssociatedObject(self, @"infiniteTabBarItemObject", item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (M13InfiniteTabBarItem *)infiniteTabBarItem
{
    return objc_getAssociatedObject(self, @"infiniteTabBarItemObject");
}

- (void)setInfiniteTabBarController:(M13InfiniteTabBarController *)controller
{
    objc_setAssociatedObject(self, @selector(setInfiniteTabBarItem:), controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (M13InfiniteTabBarController *)infiniteTabBarController
{
    return objc_getAssociatedObject(self, @selector(setInfiniteTabBarItem:));
}

@end
