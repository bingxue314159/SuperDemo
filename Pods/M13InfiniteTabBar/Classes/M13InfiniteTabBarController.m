//
//  M13InfiniteTabBarController.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBarController.h"
#import <QuartzCore/QuartzCore.h>
#import "M13InfiniteTabBarItem.h"
#import "M13InfiniteTabBarRequiresAttentionBackgroundView.h"
#import "UIViewController+M13InfiniteTabBarExtension.h"


@interface M13InfiniteTabBarController ()
@property (nonatomic, assign) BOOL isCentralViewControllerOpen;
@end

@implementation M13InfiniteTabBarController
{
    UIView *_maskView;
    UIView *_contentView;
    NSArray *_viewControllers;
    NSArray *_tabBarItems;
    CAShapeLayer *borderLayer;
    NSMutableDictionary *_indiciesRequiringAttention;
    BOOL viewDidLoadOccur;
    NSInteger numberOfItemsForScrolling;
}

- (id)initWithViewControllers:(NSArray *)viewControllers pairedWithInfiniteTabBarItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _tabBarItems = items;
        _viewControllers = viewControllers;
        _enableInfiniteScrolling = YES;
    }
    return self;
}

- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = viewControllers;
        _enableInfiniteScrolling = YES;
        NSMutableArray *array = [NSMutableArray array];
        for (UIViewController *vc in viewControllers) {
            [array addObject:vc.infiniteTabBarItem];
        }
        _tabBarItems = [array copy];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableInfiniteScrolling = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _enableInfiniteScrolling = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    viewDidLoadOccur = YES;
    
    if (_viewControllers.count == 0 && _delegate) {
        if ([_delegate respondsToSelector:@selector(infiniteTabBarControllerRequestingViewControllersToDisplay:)]) {
            //Get the view controllers
            _viewControllers = [_delegate infiniteTabBarControllerRequestingViewControllersToDisplay:self];
            //Get the tab bar items
            NSMutableArray *tempTabBarItems = [NSMutableArray array];
            for (UIViewController *vc in _viewControllers) {
                [tempTabBarItems addObject:vc.infiniteTabBarItem];
            }
            _tabBarItems = tempTabBarItems;
        }
    }
    
    [self setup];
}

- (void)setDelegate:(id<M13InfiniteTabBarControllerDelegate>)delegate
{
    _delegate = delegate;
    //Only update view controllers on initial delegate setting.
    if (_viewControllers.count == 0) {
        if ([_delegate respondsToSelector:@selector(infiniteTabBarControllerRequestingViewControllersToDisplay:)]) {
            //Get the view controllers
            _viewControllers = [_delegate infiniteTabBarControllerRequestingViewControllersToDisplay:self];
            //Get the tab bar items
            NSMutableArray *tempTabBarItems = [NSMutableArray array];
            for (UIViewController *vc in _viewControllers) {
                [tempTabBarItems addObject:vc.infiniteTabBarItem];
            }
            _tabBarItems = tempTabBarItems;
        }
        [self setup];
    }
}

- (void)setup
{
    //All the frames here are temporary. They will be layed out during handleInterfaceChange:
    if (viewDidLoadOccur && _viewControllers.count > 0) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        //create content view to hold view controllers
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50.0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        
        //Determine if we have scrolling
        numberOfItemsForScrolling = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 6 : 15;
        
        //Set up the selection
        _selectedIndex = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 2 : 5;
        //No Scrolling, select first item.
        if (_viewControllers.count < numberOfItemsForScrolling) {
            _selectedIndex = 0;
        } else {
            //Rotate the view controllers and tab bar items, so the center tab is the first one
            NSMutableArray *tempViewControllers = [NSMutableArray array];
            NSMutableArray *tempTabBarItems = [NSMutableArray array];
            for (int i = (int)_viewControllers.count - (int)_selectedIndex; i < _viewControllers.count - _selectedIndex + _viewControllers.count; i++) {
                int j = i % _viewControllers.count;
                [tempViewControllers addObject:_viewControllers[j]];
                [tempTabBarItems addObject:_tabBarItems[j]];
            }
            _tabBarItems = tempTabBarItems;
            _viewControllers = tempViewControllers;
        }
        
        //Set selected view controller
        _selectedViewController = [_viewControllers objectAtIndex:_selectedIndex];
        
        //initalize the tab bar
        _infiniteTabBar = [[M13InfiniteTabBar alloc] initWithInfiniteTabBarItems:_tabBarItems];
        _infiniteTabBar.minimumNumberOfTabsForScrolling = numberOfItemsForScrolling;
        _infiniteTabBar.tabBarDelegate = self;
        _infiniteTabBar.enableInfiniteScrolling = _enableInfiniteScrolling;
        _indiciesRequiringAttention = [[NSMutableDictionary alloc] init];
        
        //Create mask for tab bar
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60.0, self.view.frame.size.width, 80.0)];
        
        //Apply iOS 7 style border
        borderLayer = [CAShapeLayer layer];
        borderLayer.lineWidth = 1.0;
        borderLayer.strokeColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1].CGColor;
        
        //Combine views
        
        if (!_tabBarBackgroundColor) {
            _tabBarBackgroundColor = [UIColor whiteColor];
        }
        _maskView.backgroundColor = _tabBarBackgroundColor;
        
        [self.view addSubview:_maskView];
        [_maskView addSubview:_infiniteTabBar];
        [self.view addSubview:_contentView];
        [self.view.layer addSublayer:borderLayer];
        
        //Add user interaction view if not added to superview. This is for when the attention view is set before the view appears.
        if (_requiresAttentionBackgroundView && _requiresAttentionBackgroundView.superview == nil) {
            [self setRequiresAttentionBackgroundView:_requiresAttentionBackgroundView];
        }
        _automaticallySetsSelectedTabImportanceLevelToZero = YES;
        
        //Catch rotation changes for tabs
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterfaceChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        //Set the inifinite tab bar controller for each view controller.
        for (UIViewController *vc in self.viewControllers) {
            vc.infiniteTabBarController = self;
        }
        
        _selectedViewController.view.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        _selectedViewController.view.contentScaleFactor = [UIScreen mainScreen].scale;
        [_contentView addSubview:_selectedViewController.view];
        
        //Update mask
        [self handleInterfaceChange:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_selectedViewController viewWillAppear:animated];
    
    //Update mask
    [self handleInterfaceChange:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_selectedViewController viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_selectedViewController viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_selectedViewController viewDidDisappear:animated];
}

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Handle rotating all view controllers
- (void)handleInterfaceChange:(NSNotification *)notification
{
    //If notification is nil, we manually called for a redraw
    if (_selectedViewController.shouldAutorotate || notification == nil) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        //If face down, face up, or unknow, force portrait, otherwise no triangle will be drawn
        if (!UIDeviceOrientationIsPortrait(orientation) && !UIDeviceOrientationIsLandscape(orientation)) {
            orientation = UIDeviceOrientationPortrait;
        }
        
        //check to see if we should rotate, and set proper rotation values for animation
        UIInterfaceOrientationMask mask = _selectedViewController.supportedInterfaceOrientations;
        CGFloat angle = 0.0;
        UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
        BOOL go = FALSE;
        if (((mask == UIInterfaceOrientationMaskPortrait || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationPortrait)) {
            go = TRUE;
        } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeLeft || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationLandscapeLeft)) {
            go = TRUE;
            angle = M_PI_2;
            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        } else if (((mask == UIInterfaceOrientationMaskPortraitUpsideDown ||  mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationPortraitUpsideDown)) {
            go = TRUE;
            angle = M_PI;
            interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeRight ||  mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && orientation == UIDeviceOrientationLandscapeRight)) {
            go = TRUE;
            angle = -M_PI_2;
            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        }
        
        //Update frames
        if (go) {
            //Start Animation
            [UIView beginAnimations:@"HandleInterfaceChange" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            
            CGSize totalSize = [UIScreen mainScreen].bounds.size;
            CGFloat triangleDepth = 10.0;
            
            //Rotate Status Bar
            [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation];
            //Rotate tab bar items
            [_infiniteTabBar rotateItemsToOrientation:orientation];
            
            //Global values
            CGRect tempFrame;
            
            if (interfaceOrientation == UIInterfaceOrientationPortrait) {
                //Code that needs to be separate based on top or bottom
                if (_tabBarPosition == M13InfiniteTabBarPositionBottom) {
                    tempFrame = CGRectMake(0, 0, totalSize.width, totalSize.height - 50.0);
                    _maskView.frame = CGRectMake(0, totalSize.height - 50.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                } else {
                    tempFrame = CGRectMake(0, 65, totalSize.width, totalSize.height - 65.0);
                    _maskView.frame = CGRectMake(0, 5, _maskView.frame.size.width, _maskView.frame.size.height);
                }
                
                _contentView.frame = tempFrame;
                _selectedViewController.view.frame = CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height);
                _infiniteTabBar.frame = CGRectMake(0, 0, _infiniteTabBar.frame.size.width, _infiniteTabBar.frame.size.height);
                
                //Rotate the child view controller if it supports the orientation
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height);
                }
                
            } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                if (_tabBarPosition == M13InfiniteTabBarPositionBottom) {
                    tempFrame = CGRectMake(0, 0, totalSize.width, totalSize.height - 70.0);
                    _maskView.frame = CGRectMake(0, totalSize.height - 70.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                } else {
                    tempFrame = CGRectMake(0, 50, totalSize.width, totalSize.height - 50.0);
                    _maskView.frame = CGRectMake(0, -10, _maskView.frame.size.width, _maskView.frame.size.height);
                }
                
                _contentView.frame = tempFrame;
                _selectedViewController.view.frame = CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height);
                _infiniteTabBar.frame = CGRectMake(0, 0, _infiniteTabBar.frame.size.width, _infiniteTabBar.frame.size.height);
                
                //If the child view controller supports this interface orientation.
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortraitUpsideDown) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height);
                }
                
            } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                if (_tabBarPosition == M13InfiniteTabBarPositionBottom) {
                    tempFrame = CGRectMake(0, 0, totalSize.width, totalSize.height - 50.0);
                    _maskView.frame = CGRectMake(0, totalSize.height - 50.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                } else {
                    tempFrame = CGRectMake(0, 50.0, totalSize.width, totalSize.height - 50.0);
                    _maskView.frame = CGRectMake(0, -10, _maskView.frame.size.width, _maskView.frame.size.height);
                }
                
                _contentView.frame = tempFrame;
                _selectedViewController.view.frame = CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height);
                _infiniteTabBar.frame = CGRectMake(0, 0, _infiniteTabBar.frame.size.width, _infiniteTabBar.frame.size.height);
                
                //If the child view controller supports this interface orientation
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeRight) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, tempFrame.size.height, tempFrame.size.width);
                }
                
            } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                if (_tabBarPosition == M13InfiniteTabBarPositionBottom) {
                    tempFrame = CGRectMake(0, 0, totalSize.width , totalSize.height - 50.0);
                    _maskView.frame = CGRectMake(0, totalSize.height - 50.0 - triangleDepth, _maskView.frame.size.width, _maskView.frame.size.height);
                } else {
                    tempFrame = CGRectMake(0, 50, totalSize.width , totalSize.height - 50.0);
                    _maskView.frame = CGRectMake(0, -10, _maskView.frame.size.width, _maskView.frame.size.height);
                }
                
                _contentView.frame = tempFrame;
                _infiniteTabBar.frame = CGRectMake(0, 0, _infiniteTabBar.frame.size.width, _infiniteTabBar.frame.size.height);
                _selectedViewController.view.frame = CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height);
                
                //If the child view controller supports this interface orientation
                if (_selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || _selectedViewController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeLeft) {
                    //Rotate View Bounds
                    _selectedViewController.view.transform = CGAffineTransformMakeRotation(angle);
                    _selectedViewController.view.bounds = CGRectMake(0, 0, tempFrame.size.height, tempFrame.size.width);
                }
            }
            
            //Create the mask for the content view
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, 0); //Top left
            if (_tabBarPosition == M13InfiniteTabBarPositionTop && _viewControllers.count >= numberOfItemsForScrolling) {
                //Add the triangle
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) - triangleDepth, 0);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0), triangleDepth);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) + triangleDepth, 0);
            }
            CGPathAddLineToPoint(path, NULL, tempFrame.size.width, 0); //Top Right
            CGPathAddLineToPoint(path, NULL, tempFrame.size.width, tempFrame.size.height); //Bottom Right
            if (_tabBarPosition == M13InfiniteTabBarPositionBottom && _viewControllers.count >= numberOfItemsForScrolling) {
                //Add the triangle
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) + triangleDepth, tempFrame.size.height);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0), tempFrame.size.height - triangleDepth);
                CGPathAddLineToPoint(path, NULL, (tempFrame.size.width / 2.0) - triangleDepth, tempFrame.size.height);
            }
            CGPathAddLineToPoint(path, NULL, 0, tempFrame.size.height); //Bottom LEft
            CGPathCloseSubpath(path); //Close
            [maskLayer setPath:path];
            CGPathRelease(path);
            _contentView.layer.mask = maskLayer;
            
            //Complete animations
            [UIView commitAnimations];
        }
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)setRequiresAttentionBackgroundView:(M13InfiniteTabBarRequiresAttentionBackgroundView *)requiresAttentionBackgroundView
{
    if (requiresAttentionBackgroundView == nil) {
        [_requiresAttentionBackgroundView removeFromSuperview];
    } else {
        requiresAttentionBackgroundView.frame = CGRectMake(0, 10, [[UIScreen mainScreen] applicationFrame].size.width, 50);
        [_maskView insertSubview:requiresAttentionBackgroundView belowSubview:_infiniteTabBar];
    }
    _requiresAttentionBackgroundView= requiresAttentionBackgroundView;
}

//Tab bar delegate
- (BOOL)infiniteTabBar:(M13InfiniteTabBar *)tabBar shouldSelectItem:(M13InfiniteTabBarItem *)item
{
    BOOL should = YES;
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:shouldSelectViewContoller:)]) {
        should = [_delegate infiniteTabBarController:self shouldSelectViewContoller:[_viewControllers objectAtIndex:item.tag]];
    }
    return should;
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar didSelectItem:(M13InfiniteTabBarItem *)item
{
    //Clean up animation
    if (_contentView.subviews.count > 1) {
        UIView *aView = [_contentView.subviews objectAtIndex:0];
        aView.layer.opacity = 0.0;
        [aView removeFromSuperview];
    }
    
    if ([_delegate respondsToSelector:@selector(infiniteTabBarController:didSelectViewController:)]) {
        [_delegate infiniteTabBarController:self didSelectViewController:[_viewControllers objectAtIndex:item.tag]];
    }
    
    //Reset importance level if needed
    if (_automaticallySetsSelectedTabImportanceLevelToZero) {
        //Remove the item for the selected tab, and redraw
        [self viewControllerAtIndex:item.tag requiresUserAttentionWithImportanceLevel:0];
    } else {
        //Redo animation based off of what tabs are on screen.
        [self resetRequiresAttentionBackgroundView];
    }
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar willAnimateInViewControllerForItem:(M13InfiniteTabBarItem *)item
{
    UIViewController *newController = [_viewControllers objectAtIndex:item.tag];
    
    //Return if its the selected view controller
    if (newController == _selectedViewController) {
        return;
    }
    
    //check to see if we should rotate, and set proper rotation values
    UIInterfaceOrientationMask mask = _selectedViewController.supportedInterfaceOrientations;
    CGFloat angle = 0.0;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (((mask == UIInterfaceOrientationMaskPortrait || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationPortrait)) {
    } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeLeft || mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {
        angle = -M_PI_2;
    } else if (((mask == UIInterfaceOrientationMaskPortraitUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationMaskPortraitUpsideDown)) {
        angle = -M_PI;
    } else if (((mask == UIInterfaceOrientationMaskLandscape || mask == UIInterfaceOrientationMaskLandscapeRight ||  mask == UIInterfaceOrientationMaskAllButUpsideDown || mask == UIInterfaceOrientationMaskAll) && interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        angle = M_PI_2;
    }
    
    CGSize totalSize = [UIScreen mainScreen].bounds.size;
    
    //Rotate Status Bar
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation];
    //Rotate tab bar items
    //Recreate mask and adjust frames to make room for status bar.
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - 50.0);
        
        //If the child view controller supports this orientation
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortrait) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.width, totalSize.height - 50.0);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - 50);
        
        //If the child view controller supports this interface orientation.
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskPortraitUpsideDown) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.width, totalSize.height - 50.0);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - 50.0);
        
        //If the child view controller supports this interface orientation
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeLeft) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.height - 50.0, totalSize.width);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //Resize View
        newController.view.frame = CGRectMake(0, 0, totalSize.width, totalSize.height - 50.0);
        
        //If the child view controller supports this interface orientation
        if (newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape || newController.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscapeRight) {
            //Rotate View Bounds
            newController.view.bounds = CGRectMake(0, 0, totalSize.height - 50.0, totalSize.width);
            newController.view.transform = CGAffineTransformMakeRotation(angle);
        }
    }
    
    //Set up for transition
    newController.view.layer.opacity = 0;
}

- (void)infiniteTabBar:(M13InfiniteTabBar *)tabBar animateInViewControllerForItem:(M13InfiniteTabBarItem *)item
{
    if ([[_viewControllers objectAtIndex:item.tag] isKindOfClass:[UINavigationController class]] && item.tag == _selectedIndex) {
        //Pop to root controller when tapped
        UINavigationController *controller = [_viewControllers objectAtIndex:item.tag];
        [controller popToRootViewControllerAnimated:YES];
    } else {
        UIViewController *newController = [_viewControllers objectAtIndex:item.tag];
        [_contentView addSubview:newController.view];
        newController.view.layer.opacity = 1.0;
        _selectedViewController = newController;
        _selectedIndex = [_viewControllers indexOfObject:newController];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [_infiniteTabBar selectItemAtIndex:selectedIndex];
    [_infiniteTabBar item:_tabBarItems[selectedIndex] requiresUserAttention:NO];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [self setSelectedIndex:[_viewControllers indexOfObject:selectedViewController]];
}

- (void)viewControllerAtIndex:(NSUInteger)index requiresUserAttentionWithImportanceLevel:(NSInteger)importanceLevel
{
    [_infiniteTabBar item:[_tabBarItems objectAtIndex:index] requiresUserAttention:(importanceLevel > 0)];
    
    if (importanceLevel > 0) {
        [_indiciesRequiringAttention setObject:[NSNumber numberWithInteger:importanceLevel] forKey:[NSNumber numberWithUnsignedInteger:index]];
    } else {
        [_indiciesRequiringAttention removeObjectForKey:[NSNumber numberWithUnsignedInteger:index]];
    }
    
    [self resetRequiresAttentionBackgroundView];
}

- (void)viewController:(UIViewController *)viewController requiresUserAttentionWithImportanceLevel:(NSInteger)importanceLevel
{
    [self viewControllerAtIndex:[_viewControllers indexOfObject:viewController] requiresUserAttentionWithImportanceLevel:importanceLevel];
}

//Appearance
- (void)setTabBarBackgroundColor:(UIColor *)tabBarBackgroundColor
{
    _maskView.backgroundColor = tabBarBackgroundColor;
    _tabBarBackgroundColor = tabBarBackgroundColor;
}

- (void)resetRequiresAttentionBackgroundView
{
    if (!_requiresAttentionBackgroundView) {
        return;
    }
    //Create the search array
    NSMutableArray *searchArray = [NSMutableArray array];
    for (int i = (int)_selectedIndex + 1; i <= (int)_viewControllers.count + (int)_selectedIndex - 1; i++) {
        [searchArray addObject:[NSNumber numberWithInt:(i % _viewControllers.count)]];
    }
    
    //Figure out the maximum importance level for each side
    NSInteger leftImportanceLevel = 0;
    NSInteger rightImportanceLevel = 0;
    for (NSNumber *index in _indiciesRequiringAttention.allKeys) {
        //The selected index will return NSNotFound
        if (![index isEqualToNumber:[NSNumber numberWithUnsignedInteger:_selectedIndex]]) {
            //Find the indesx in the search array
            NSInteger indexSearchArray = [searchArray indexOfObject:index inRange:NSMakeRange(0, _viewControllers.count - 1)];
            NSInteger leftDistance = searchArray.count - indexSearchArray;
            NSInteger rightDistance = indexSearchArray + 1;
            
            NSInteger minDistance = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 2 : 5;
            if (leftDistance < rightDistance && leftDistance > minDistance) {
                NSInteger tempImportanceLevel = ((NSNumber *)_indiciesRequiringAttention[index]).integerValue;
                if (tempImportanceLevel > leftImportanceLevel) {
                    leftImportanceLevel = tempImportanceLevel;
                }
            } else if (rightDistance < leftDistance && rightDistance > minDistance) {
                NSInteger tempImportanceLevel = ((NSNumber *)_indiciesRequiringAttention[index]).integerValue;
                if (tempImportanceLevel > rightImportanceLevel) {
                    rightImportanceLevel = tempImportanceLevel;
                }
            }
        }
    }
    
    [_requiresAttentionBackgroundView showAnimationOnLeftEdgeWithImportanceLevel:leftImportanceLevel];
    [_requiresAttentionBackgroundView showAnimationOnRightEdgeWithImportanceLevel:rightImportanceLevel];
    
}

- (void)setEnableInfiniteScrolling:(BOOL)enableInfiniteScrolling
{
    _enableInfiniteScrolling = enableInfiniteScrolling;
    _infiniteTabBar.enableInfiniteScrolling = _enableInfiniteScrolling;
}

- (void)setTabBarPosition:(M13InfiniteTabBarPosition)tabBarPosition
{
    _tabBarPosition = tabBarPosition;
    if (self.viewControllers.count > 0) {
        [self handleInterfaceChange:nil];
    }
}

@end
