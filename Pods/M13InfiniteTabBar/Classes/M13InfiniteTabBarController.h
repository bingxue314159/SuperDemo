//
//  M13InfiniteTabBarController.h
//  M13InfiniteTabBar
//
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "M13InfiniteTabBar.h"
#import "UIViewController+M13InfiniteTabBarExtension.h"
@class M13InfiniteTabBarController;
@class M13InfiniteTabBarRequiresAttentionBackgroundView;

typedef enum {
    M13InfiniteTabBarPositionBottom,
    M13InfiniteTabBarPositionTop
} M13InfiniteTabBarPosition;

/** Delegate to respond to changes occuring in `M13InfiniteTabBarController` */
@protocol M13InfiniteTabBarControllerDelegate <NSObject>

/**Asks the delegate for the list of view controllers that will be represented in the tab bar controller. This is for a storyboard implementation of M13InfiniteTabBarController;
 @param tabBarController    The instance of `M13TabBarController.
 @return     The view controllers that will be represented in the tab bar. The first view controller will be the displaied view controller.*/
- (NSArray *)infiniteTabBarControllerRequestingViewControllersToDisplay:(M13InfiniteTabBarController *)tabBarController;

/** Asks the delegate if the tab specified by the user should be selected 
 @param tabBarController    The instance of `M13TabBarController.
 @param viewController      The UIViewController requesting to become the main view.
 @return Wether or not the UIViewController should be come the main window.
 */
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController;
/** Lets the delegate know that a tab change occurred. 
 @note This method is called after the animation for the tab change has been completed.
 @param tabBarController    The instance of `M13TabBarController`.
 @param viewController      The new main `UIViewController`. */
- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

/** A controller for `M13InfiniteTabBar`. Preforms similar to `UITabBarController`.*/
@interface M13InfiniteTabBarController : UIViewController <M13InfiniteTabBarDelegate>
/** @name Initalization */
/** Initalize an instance of `M13InfiniteTabBarController` with a set of `UIViewController`s paired with a set of `M13InfiniteTabBarItem`s..
 @note On the iPhone, the third item in the tab bar is selected initally. On the iPad the fifth item is selected initally.
 @param viewControllers  All the view controllers for the tabs in order.
 @param items           The tabs that correspond to the `UIViewControllers` in the other array.
 @return An instance of `M13InfiniteTabBarConroller` */
 - (id)initWithViewControllers:(NSArray *)viewControllers pairedWithInfiniteTabBarItems:(NSArray *)items __attribute((deprecated("Use either initWithViewControllers: or the delegate method infiniteTabBarRequestingViewControllersToDisplay:.")));

/** Initalize an instance of `M13InfiniteTabBarController` with a set of `UIViewController`s. This is for a programatic implementation of the tab bar without a storyboard.
 @note On the iPhone, the third item in the tab bar is selected initally. On the iPad the fifth item is selected initally.
 @param viewControllers  All the view controllers for the tabs in order, the first tab will be the selected tab. Also all of these view controllers should respond
 @return An instance of `M13InfiniteTabBarConroller` */
- (id)initWithViewControllers:(NSArray *)viewControllers;


/** @name Basic Properties */
/** Responds to `M13InfiniteTabBarController`'s delegate methods. */
@property (nonatomic, retain) id<M13InfiniteTabBarControllerDelegate> delegate;
/** The `M13InfiniteTabBar` instance the controller is controlling. This property is accessable to allow apperance customization. */
@property (nonatomic, readonly) M13InfiniteTabBar *infiniteTabBar;
/** The view controller list that the infinite tab bar displays.*/
@property (nonatomic, copy) NSArray *viewControllers;
/** If set to YES, and the number of tabs is greater than minimumNumberOfTabsForScrolling, the tab bar will scroll infinitly. If set to no, the tab bar will still scroll, but not scroll infinitly.*/
@property (nonatomic, assign) BOOL enableInfiniteScrolling;
/**The location that the tab bar is pinned. The bar can be pinned to the top or bottom. Default is the bottom.*/
@property (nonatomic, assign) M13InfiniteTabBarPosition tabBarPosition;

/** @name Selection Handling */
/** The selected `UIViewController` instance. */
@property (nonatomic, assign) UIViewController *selectedViewController;
/** The index of the selected `UIViewController */
@property (nonatomic) NSUInteger selectedIndex;

/** Set the selected `UIViewController` programatically by its index
 @param selectedIndex The index to be selected. */
- (void)setSelectedIndex:(NSUInteger)selectedIndex;
/** Set the selected `UIViewController`. 
 @param selectedViewController The `UIViewController` to be selected. */
- (void)setSelectedViewController:(UIViewController *)selectedViewController;

/** @name User Attention*/
/**Set that the `UIViewController` at the given index requires or does not require user attention.
 @param index The index that requires user attention.
 @param importanceLevel The level of attention the `UIViewController` at the given index requires*/
- (void)viewControllerAtIndex:(NSUInteger)index requiresUserAttentionWithImportanceLevel:(NSInteger)importanceLevel;
/**Set that the given `UIViewController` requires or does not require user attention.
 @param viewController The view controller that requires user attention.
 @param importanceLevel The level of attention the given `UIViewController`requires*/
- (void)viewController:(UIViewController *)viewController requiresUserAttentionWithImportanceLevel:(NSInteger)importanceLevel;
/**Wether or not the tab bar controller automatically sets the selected tab's importance level to 0.*/
@property (nonatomic, assign) BOOL automaticallySetsSelectedTabImportanceLevelToZero;

/** @name Appearance */
/** The background color of the tab bar */
@property (nonatomic, retain) UIColor *tabBarBackgroundColor UI_APPEARANCE_SELECTOR;
/** The background that notifies the user that an off screen tab requires user attention.*/
@property (nonatomic, retain) M13InfiniteTabBarRequiresAttentionBackgroundView *requiresAttentionBackgroundView;

@end
