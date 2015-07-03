//
//  CubeController.h
//
//  Version 1.2.1
//
//  Created by Nick Lockwood on 30/06/2013.
//  Copyright (c) 2013 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/CubeController
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wauto-import"
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


#import <UIKit/UIKit.h>


#undef weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


@protocol CubeControllerDataSource, CubeControllerDelegate;


@interface CubeController : UIViewController

@property (nonatomic, weak_delegate) IBOutlet id<CubeControllerDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet id<CubeControllerDelegate> delegate;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) NSInteger numberOfViewControllers;
@property (nonatomic, assign) NSInteger currentViewControllerIndex;
@property (nonatomic, getter = isWrapEnabled) BOOL wrapEnabled;

- (void)reloadData;
- (void)reloadViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)scrollToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollForwardAnimated:(BOOL)animated;
- (void)scrollBackAnimated:(BOOL)animated;

@end


@protocol CubeControllerDataSource <NSObject>

- (NSInteger)numberOfViewControllersInCubeController:(CubeController *)cubeController;
- (UIViewController *)cubeController:(CubeController *)cubeController
               viewControllerAtIndex:(NSInteger)index;

@end


@protocol CubeControllerDelegate <NSObject>
@optional

- (void)cubeControllerDidScroll:(CubeController *)cubeController;
- (void)cubeControllerCurrentViewControllerIndexDidChange:(CubeController *)cubeController;
- (void)cubeControllerWillBeginDragging:(CubeController *)cubeController;
- (void)cubeControllerDidEndDragging:(CubeController *)cubeController willDecelerate:(BOOL)decelerate;
- (void)cubeControllerWillBeginDecelerating:(CubeController *)cubeController;
- (void)cubeControllerDidEndDecelerating:(CubeController *)cubeController;
- (void)cubeControllerDidEndScrollingAnimation:(CubeController *)cubeController;

@end


@interface UIViewController (CubeController)

@property (nonatomic, readonly) CubeController *cubeController;

@end


#pragma GCC diagnostic pop
