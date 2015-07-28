//
//  M13InfiniteTabBar.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@class M13InfiniteTabBarController;
@class M13InfiniteTabBar;
@class M13InfiniteTabBarItem;

/** The delegate protocol for `M13InfiniteTabBar`. */
@protocol M13InfiniteTabBarDelegate <NSObject>

/** Lets the delegate know that an tab bar item has been selected 
 @param tabBar      The instance of `M13InfiniteTabBar` that has been changed.
 @param item        The `M13InfiniteTabBarItem` that has been selected. */
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item;

/** Asks the delegate if the tab that the user selected should be selected.
 @param tabBar      The instance of `M13InfiniteTabBar that is requesting a change.
 @param item        The `M13InfiniteTabBarItem` that will be selected.
 @return            Wether or not the tab bar can select that tab. */
- (BOOL)infiniteTabBar:(M13InfiniteTabBar *)tabBar shouldSelectItem:(M13InfiniteTabBarItem *)item;

/** Preform animations to change the front most view controller here. 
 @warning Do not create your own `UIView` animation. One has already been started for you by the `M13InfiniteTabBarController`.
 @param tabBar      The instance of `M13InfiniteTabBar` that has been changed.
 @param item        The `M13InfiniteTabBarItem that has been selected.
 */
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar animateInViewControllerForItem:(M13InfiniteTabBarItem *)item;

/** Prepare to animate in a new `UIViewController`. Anything in this method will not be animated on screen.
 @param tabBar      The instance of `M13InfiniteTabBar` that has been changed.
 @param item        The `M13InfiniteTabBarItem` that has been selected. */
- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willAnimateInViewControllerForItem:(M13InfiniteTabBarItem *)item;

@end

/** The tab bar. Works like `UITabBar`, but way cooler. */
@interface M13InfiniteTabBar : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

/** @name Initalization */
/** Initalize an instance of M13InfiniteTabBar.
 @param items   The `M13InfiniteTabBarItem`s that will be placed in the tab bar.
 @return An initalized `M13InfiniteTabBar` instance. */
- (id)initWithInfiniteTabBarItems:(NSArray *)items;

/** @name Delegate */
/** Tab bar's delegate. */
@property (nonatomic, retain) id<M13InfiniteTabBarDelegate> tabBarDelegate;

/** @name Selection */
/** The `M13InfiniteTabBarItem` that is selected. */
@property (nonatomic, retain) M13InfiniteTabBarItem *selectedItem;
/**
 Selects the item at the given index.
 
 @param index The index of the item to select.
 */
- (void)selectItemAtIndex:(NSUInteger)index;

/** @name User Attention*/
/** Set wether or not a specific tab requires user attention.
 @param item The tab bar item for the tab that requires attention.
 @param requiresAttention Wether or not the item requires user attention.*/
- (void)item:(M13InfiniteTabBarItem *)item requiresUserAttention:(BOOL)requiresAttention;

/** @name Animation */
/** Method to rotate all the items on the tab bar to the given orientation.
 @param orientation     The orientation the tab bar items shoulb be rotated to. */
- (void)rotateItemsToOrientation:(UIDeviceOrientation)orientation;
/**The number minimum number of items before the infinite scrolling animation occurs. If the number of items is less than this number, then the tab bar acts like a normal tab bar.*/
@property (nonatomic, assign) NSInteger minimumNumberOfTabsForScrolling;
/**
 If set to YES, and the number of tabs is greater than minimumNumberOfTabsForScrolling, the tab bar will scroll infinitly. If set to no, the tab bar will still scroll, but not scroll infinitly.
 */
@property (nonatomic, assign) BOOL enableInfiniteScrolling;

@end
