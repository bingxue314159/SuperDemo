//
//  CubeController.m
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


#pragma GCC diagnostic ignored "-Wauto-import"
#pragma GCC diagnostic ignored "-Wreceiver-is-weak"
#pragma GCC diagnostic ignored "-Warc-repeated-use-of-weak"
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"
#pragma GCC diagnostic ignored "-Wconversion"
#pragma GCC diagnostic ignored "-Wgnu"


#import "CubeController.h"
#import <QuartzCore/QuartzCore.h>


@implementation NSObject (CubeControllerDelegate)

- (void)cubeControllerDidScroll:(__unused CubeController *)cc {}
- (void)cubeControllerCurrentViewControllerIndexDidChange:(__unused CubeController *)cc {}
- (void)cubeControllerWillBeginDragging:(__unused CubeController *)cc {}
- (void)cubeControllerDidEndDragging:(__unused CubeController *)cc willDecelerate:(__unused BOOL)dc {}
- (void)cubeControllerWillBeginDecelerating:(__unused CubeController *)cc {}
- (void)cubeControllerDidEndDecelerating:(__unused CubeController *)cc {}
- (void)cubeControllerDidEndScrollingAnimation:(__unused CubeController *)cc {}

@end


@interface CubeController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *controllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger numberOfViewControllers;
@property (nonatomic, assign) CGFloat scrollOffset;
@property (nonatomic, assign) CGFloat previousOffset;
@property (nonatomic, assign) BOOL suppressScrollEvent;

@end


@implementation CubeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    
    [self reloadData];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        CGRect frame = [self isViewLoaded]? self.view.bounds: [UIScreen mainScreen].bounds;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.autoresizesSubviews = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)setWrapEnabled:(BOOL)wrapEnabled
{
    _wrapEnabled = wrapEnabled;
    [self.view layoutIfNeeded];
}

- (void)setCurrentViewControllerIndex:(NSInteger)currentViewControllerIndex
{
    [self scrollToViewControllerAtIndex:currentViewControllerIndex animated:NO];
}

- (void)scrollToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated
{
    CGFloat offset = (CGFloat)index;
    if (_wrapEnabled)
    {
        //using > here instead of >= may look like a fencepost bug, but it isn't
        if (offset > _numberOfViewControllers)
        {
            offset = (NSInteger)offset % _numberOfViewControllers;
        }
        offset = MAX(-1, offset) + 1;
    }
    else if (animated && _scrollView.bounces)
    {
        offset = MAX(-0.1f, MIN(offset, _numberOfViewControllers - 0.9f));
    }
    else
    {
        offset = MAX(0, MIN(offset, _numberOfViewControllers - 1));
    }
    [_scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * offset, 0) animated:animated];
}

- (void)scrollForwardAnimated:(BOOL)animated
{
    [self scrollToViewControllerAtIndex:_currentViewControllerIndex + 1 animated:animated];
}

- (void)scrollBackAnimated:(BOOL)animated
{
    [self scrollToViewControllerAtIndex:_currentViewControllerIndex - 1 animated:animated];
}

- (void)reloadData
{
    for (UIViewController *controller in [_controllers allValues])
    {
        [controller viewWillDisappear:NO];
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        [controller viewDidDisappear:NO];
    }
    _controllers = [NSMutableDictionary dictionary];
    _numberOfViewControllers = [self.dataSource numberOfViewControllersInCubeController:self];
    [self.view layoutIfNeeded];
}

- (void)reloadViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated
{
    UIViewController *controller = _controllers[@(index)];
    if (controller)
    {
        CATransform3D transform = controller.view.layer.transform;
        CGPoint center = controller.view.center;
        
        if (animated)
        {
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFade;
            [_scrollView.layer addAnimation:animation forKey:nil];
        }
        
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        controller = [_dataSource cubeController:self viewControllerAtIndex:index];
        [_controllers setObject:controller forKey:@(index)];
        controller.view.layer.doubleSided = NO;
        [self addChildViewController:controller];
        [_scrollView addSubview:controller.view];
        
        controller.view.layer.transform = transform;
        controller.view.center = center;
        controller.view.userInteractionEnabled = (index == _currentViewControllerIndex);
    }
}

- (void)updateContentOffset
{
    CGFloat offset = _scrollOffset;
    if (_wrapEnabled && _numberOfViewControllers > 1)
    {
        offset += 1.0f;
        while (offset < 1.0f) offset += 1;
        while (offset >= _numberOfViewControllers + 1) offset -= _numberOfViewControllers;
    }
    _previousOffset = offset;
    
    _suppressScrollEvent = YES;
    _scrollView.contentOffset = CGPointMake(self.view.bounds.size.width * offset, 0.0f);
    _suppressScrollEvent = NO;
}

- (void)updateLayout
{
    for (NSNumber *index in _controllers)
    {
        UIViewController *controller = _controllers[index];
        if (controller && !controller.parentViewController)
        {
            controller.view.autoresizingMask = UIViewAutoresizingNone;
            controller.view.layer.doubleSided = NO;
            [self addChildViewController:controller];
            [_scrollView addSubview:controller.view];
        }
        
        NSInteger i = [index integerValue];
        CGFloat angle = (_scrollOffset - i) * M_PI_2;
        while (angle < 0) angle += M_PI * 2;
        while (angle > M_PI * 2) angle -= M_PI * 2;
        CATransform3D transform = CATransform3DIdentity;
        if (angle != 0.0f)
        {
            transform.m34 = -1.0/500;
            transform = CATransform3DTranslate(transform, 0, 0, -self.view.bounds.size.width / 2.0f);
            transform = CATransform3DRotate(transform, -angle, 0, 1, 0);
            transform = CATransform3DTranslate(transform, 0, 0, self.view.bounds.size.width / 2.0f);
        }
        
        CGPoint contentOffset = CGPointZero;
        BOOL isScrollView = [controller.view isKindOfClass:[UIScrollView class]];
        if (isScrollView)
        {
            contentOffset = ((UIScrollView *)controller.view).contentOffset;
        }
        controller.view.bounds = self.view.bounds;
        controller.view.center = CGPointMake(self.view.bounds.size.width / 2.0f + _scrollView.contentOffset.x, self.view.bounds.size.height / 2.0f);
        controller.view.layer.transform = transform;
        if (isScrollView)
        {
            ((UIScrollView *)controller.view).contentOffset = contentOffset;
        }
    }
}

- (void)loadUnloadControllers
{
    //calculate visible indices
    NSMutableSet *visibleIndices = [NSMutableSet setWithObject:@(_currentViewControllerIndex)];
    if (_wrapEnabled || _currentViewControllerIndex < _numberOfViewControllers - 1)
    {
        [visibleIndices addObject:@(_currentViewControllerIndex + 1)];
    }
    if (_currentViewControllerIndex > 0)
    {
        [visibleIndices addObject:@(_currentViewControllerIndex - 1)];
    }
    else if (_wrapEnabled)
    {
        [visibleIndices addObject:@(-1)];
    }
    
    //remove hidden controllers
    for (NSNumber *index in [_controllers allKeys])
    {
        if (![visibleIndices containsObject:index])
        {
            UIViewController *controller = _controllers[index];
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
            [_controllers removeObjectForKey:index];
        }
    }
    
    //load controllers
    for (NSNumber *index in visibleIndices)
    {
        NSInteger i = [index integerValue];
        UIViewController *controller = _controllers[index];
        if (!controller && _numberOfViewControllers)
        {
            controller = [self.dataSource cubeController:self viewControllerAtIndex:(i + _numberOfViewControllers) % _numberOfViewControllers];
            _controllers[index] = controller;
        }
    }
}

- (void)updateInteraction
{
    for (NSNumber *index in _controllers)
    {
        UIViewController *controller = _controllers[index];
        NSInteger i = [index integerValue];
        controller.view.userInteractionEnabled = (i == _currentViewControllerIndex);
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_scrollView)
    {
        NSInteger pages = _numberOfViewControllers;
        if (_wrapEnabled && _numberOfViewControllers > 1) pages += 2;
        _suppressScrollEvent = YES;
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * pages, self.view.bounds.size.height);
        _suppressScrollEvent = NO;
        [self updateContentOffset];
        [self loadUnloadControllers];
        [self updateLayout];
        [self updateInteraction];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_suppressScrollEvent)
    {
        //update scroll offset
        CGFloat offset = scrollView.contentOffset.x / self.view.bounds.size.width;
        _scrollOffset += (offset - _previousOffset);
        if (_wrapEnabled)
        {
            while (_scrollOffset < 0.0f) _scrollOffset += _numberOfViewControllers;
            while (_scrollOffset >= _numberOfViewControllers) _scrollOffset -= _numberOfViewControllers;
        }
        _previousOffset = offset;
        
        //prevent error accumulation
        if (offset - floor(offset) == 0.0f) _scrollOffset = round(_scrollOffset);
        
        //update index
        NSInteger previousViewControllerIndex = _currentViewControllerIndex;
        _currentViewControllerIndex = MAX(0, MIN(_numberOfViewControllers - 1, (NSInteger)(round(_scrollOffset))));
        
        //update content
        [self updateContentOffset];
        [self loadUnloadControllers];
        [self updateLayout];
        
        //update delegate
        [_delegate cubeControllerDidScroll:self];
        if (_currentViewControllerIndex != previousViewControllerIndex)
        {
            [_delegate cubeControllerCurrentViewControllerIndexDidChange:self];
        }
        
        //enable/disable interaction
        [self updateInteraction];
    }
}

- (void)scrollViewWillBeginDragging:(__unused UIScrollView *)scrollView
{
    if (!_suppressScrollEvent) [_delegate cubeControllerWillBeginDragging:self];
}

- (void)scrollViewDidEndDragging:(__unused UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!_suppressScrollEvent) [_delegate cubeControllerDidEndDragging:self willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(__unused UIScrollView *)scrollView
{
    if (!_suppressScrollEvent) [_delegate cubeControllerWillBeginDecelerating:self];
}

- (void)scrollViewDidEndDecelerating:(__unused UIScrollView *)scrollView
{
    if (!_suppressScrollEvent) [_delegate cubeControllerDidEndDecelerating:self];
}

- (void)scrollViewDidEndScrollingAnimation:(__unused UIScrollView *)scrollView
{
    CGFloat nearestIntegralOffset = roundf(_scrollOffset);
    if (ABS(_scrollOffset - nearestIntegralOffset) > 0.0f)
    {
        [self scrollToViewControllerAtIndex:_currentViewControllerIndex animated:YES];
    }
    if (!_suppressScrollEvent) [_delegate cubeControllerDidEndScrollingAnimation:self];
}

@end


@implementation UIViewController (CubeController)

- (CubeController *)cubeController
{
    if ([self.parentViewController isKindOfClass:[CubeController class]])
    {
        return (CubeController *)self.parentViewController;
    }
    return [self.parentViewController cubeController];
}

@end
