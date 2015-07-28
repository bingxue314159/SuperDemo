//
//  M13InfiniteTabBar.m
//  M13InfiniteTabBar
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13InfiniteTabBar.h"
#import "M13InfiniteTabBarItem.h"

@implementation M13InfiniteTabBar
{
    UITapGestureRecognizer *_singleTapGesture;
    UIView *_tabContainerView;
    NSUInteger _previousSelectedIndex;
    NSMutableArray *_visibleIcons; //Icons in the scrollview
    NSArray *_items;
    BOOL _scrollAnimationCheck;
}

- (id)initWithInfiniteTabBarItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, 60)];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.contentSize = self.frame.size;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        _enableInfiniteScrolling = YES;
        
        //Content size
        self.contentSize = CGSizeMake(items.count * ((M13InfiniteTabBarItem *)[items lastObject]).frame.size.width * 4, self.frame.size.height); //Need to iterate 4 times for infinite animation
        _tabContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.contentSize.width, self.contentSize.height)];
        _tabContainerView.backgroundColor = [UIColor clearColor];
        _tabContainerView.userInteractionEnabled = NO;
        [self addSubview:_tabContainerView];
        
        //hide horizontal indicator so the recentering trick is not revealed
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        self.userInteractionEnabled = YES;
        
        //Add gesture for taps
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        _singleTapGesture.cancelsTouchesInView = NO;
        _singleTapGesture.delegate = self;
        _singleTapGesture.delaysTouchesBegan = NO;
        [self addGestureRecognizer:_singleTapGesture];
        
        
        _visibleIcons = [[NSMutableArray alloc] initWithCapacity:items.count];
        _items = items;
        
        //Reindex
        int tag = 0;
        for (M13InfiniteTabBarItem *item in items) {
            item.frame = CGRectMake(2000.0, 10.0, item.frame.size.width, item.frame.size.height);
            item.tag = tag;
            tag += 1;
        }
        
        //Set Previous Index
        _previousSelectedIndex = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 2 : 5;
        //Determine if we have scrolling
        int numberOfItemsForScrolling = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 6 : 15;
        if (_items.count < numberOfItemsForScrolling) {
            _previousSelectedIndex = 0;
        }
        _selectedItem = [_items objectAtIndex:_previousSelectedIndex];
        [((M13InfiniteTabBarItem *)[_items objectAtIndex:_previousSelectedIndex]) setSelected:YES];
        
        //Setup tabs, if less than the scrolling amount
        if (_items.count < numberOfItemsForScrolling) {
            _visibleIcons = [[NSMutableArray alloc] init];
            int tag = 0;
            for (M13InfiniteTabBarItem *anItem in _items) {
                M13InfiniteTabBarItem *item = [anItem copy];
                item.tag = tag;
                anItem.tag = tag;
                [_visibleIcons addObject:item];
                tag ++;
            }
        }
        
        [self rotateItemsToOrientation:[UIDevice currentDevice].orientation];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //Allow the scroll view to work simintaniously with the tap gesture and pull view gesture
    if ((gestureRecognizer == self.panGestureRecognizer || otherGestureRecognizer == self.panGestureRecognizer) || (gestureRecognizer == _singleTapGesture || otherGestureRecognizer == _singleTapGesture)) {
        return YES;
    } else {
        return NO;
    }
}

//recenter peridocially to acheive the impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, 0);
        
        // move content by the same amount so it appears to stay still
        for (M13InfiniteTabBarItem *view in _visibleIcons) {
            CGPoint center = [_tabContainerView convertPoint:view.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            view.center = [self convertPoint:center toView:_tabContainerView];
        }
    }
}

//Retile content
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_items.count >= _minimumNumberOfTabsForScrolling && _enableInfiniteScrolling) {
        //Infinite Scrolling
        [self recenterIfNecessary];
        
        // tile content in visible bounds
        CGRect visibleBounds = [self convertRect:[self bounds] toView:_tabContainerView];
        CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
        CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
        
        [self tileLabelsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
    } else if (_items.count >= _minimumNumberOfTabsForScrolling && !_enableInfiniteScrolling) {
        //Infinte scrolling disabled.
        //Set the new content size, this should be the width of all the tab bar items, plus the width of the frame, so that we have width/2 padding on each side. So that the left and right most items can still reach the center.
        CGFloat itemWidth = ((M13InfiniteTabBarItem *)[_items lastObject]).frame.size.width;
        self.contentSize = CGSizeMake((_items.count * itemWidth) + self.frame.size.width, self.frame.size.height);
        _tabContainerView.frame = CGRectMake(self.frame.size.width / 2.0, 10, self.contentSize.width, self.contentSize.height);
        CGFloat origin = 0.0;
        for (M13InfiniteTabBarItem *item in _visibleIcons) {
            item.frame = CGRectMake(origin, 0, itemWidth, item.frame.size.height);
            origin += itemWidth;
            [_tabContainerView addSubview:item];
        }
    } else {
        //Scrolling Disabled
        
        //Basic Tab Bar
        //Reset content size of scroll view
        self.contentSize = self.frame.size;
        _tabContainerView.frame = CGRectMake(0, -10, self.frame.size.width, self.frame.size.height);
        //Manually lay out the tabs, no scrolling occuring
        CGFloat width = self.frame.size.width / _items.count;
        CGFloat origin = 0;
        for (M13InfiniteTabBarItem *item in _visibleIcons) {
            item.frame = CGRectMake(origin, 0, width, item.frame.size.height);
            origin += width;
            [_tabContainerView addSubview:item];
        }
    }
}

//Handle icon rotation on device rotation
- (void)rotateItemsToOrientation:(UIDeviceOrientation)orientation;
{
    CGFloat angle = 0;
    if ( orientation == UIDeviceOrientationLandscapeRight ) angle = -M_PI_2;
    else if ( orientation == UIDeviceOrientationLandscapeLeft ) angle = M_PI_2;
    else if ( orientation == UIDeviceOrientationPortraitUpsideDown ) angle = M_PI;
    for (M13InfiniteTabBarItem *item in _visibleIcons) {
        [item rotateToAngle:angle];
    }
    for (M13InfiniteTabBarItem *item in _items) {
        [item rotateToAngle:angle];
    }
}

//Set wether or not we should scroll.
- (void)setEnableInfiniteScrolling:(BOOL)enableInfiniteScrolling
{
    _enableInfiniteScrolling = enableInfiniteScrolling;
    
    if (_enableInfiniteScrolling) {
        //Enable infinite
        [self layoutSubviews];
    } else {
        //Disable infinite
        _visibleIcons = [[NSMutableArray alloc] init];
        int tag = 0;
        for (M13InfiniteTabBarItem *anItem in _items) {
            M13InfiniteTabBarItem *item = [anItem copy];
            item.tag = tag;
            anItem.tag = tag;
            [_visibleIcons addObject:item];
            tag ++;
        }
        [self layoutSubviews];
        //center scroll view
        //Need to find the item that is shown, since that has the proper frame.
        M13InfiniteTabBarItem *item = nil;
        for (M13InfiniteTabBarItem *anItem in _tabContainerView.subviews) {
            if (anItem.tag == _selectedItem.tag) {
                item = anItem;
                break;
            }
        }
        [self setSelectedItem:item];
    }
}

//Tiling labels
- (CGFloat)placeNewLabelOnRight:(CGFloat)rightEdge
{
    //Get item of next index
    M13InfiniteTabBarItem *rightMostItem = [_visibleIcons lastObject];
    int rightMostIndex = (int)rightMostItem.tag;
    int indexToInsert = rightMostIndex + 1;
    //Loop back if next index is past end of availableIcons
    if (indexToInsert == [_items count]) {
        indexToInsert = 0;
    }
    M13InfiniteTabBarItem *itemToInsert = [(M13InfiniteTabBarItem *)[_items objectAtIndex:indexToInsert] copy];
    itemToInsert.tag = indexToInsert;
    [_visibleIcons addObject:itemToInsert];
    
    CGRect frame = [itemToInsert frame];
    frame.origin.x = rightEdge;
    frame.origin.y = 0;
    [itemToInsert setFrame:frame];
    
    [_tabContainerView addSubview:itemToInsert];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewLabelOnLeft:(CGFloat)leftEdge
{
    //Get item of next index
    M13InfiniteTabBarItem *leftMostItem = [_visibleIcons objectAtIndex:0];
    int leftMostIndex = (int)leftMostItem.tag;
    int indexToInsert = leftMostIndex - 1;
    //Loop back if next index is past end of availableIcons
    if (indexToInsert == -1) {
        indexToInsert = (int)[_items count] - 1;
    }
    M13InfiniteTabBarItem *itemToInsert = [(M13InfiniteTabBarItem *)[_items objectAtIndex:indexToInsert] copy];
    itemToInsert.tag = indexToInsert;
    [_visibleIcons insertObject:itemToInsert atIndex:0];  // add leftmost label at the beginning of the array
    
    CGRect frame = [itemToInsert frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = 0;
    [itemToInsert setFrame:frame];
    
    [_tabContainerView addSubview:itemToInsert];
    
    return CGRectGetMinX(frame);
}

- (void)tileLabelsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleIcons count] == 0) {
        M13InfiniteTabBarItem *itemToInsert = [(M13InfiniteTabBarItem *)[_items objectAtIndex:0] copy];
        itemToInsert.tag = 0;
        [_visibleIcons addObject:itemToInsert];
        
        CGRect frame = [itemToInsert frame];
        frame.origin.x = minimumVisibleX;
        frame.origin.y = 0;
        [itemToInsert setFrame:frame];
        
        [_tabContainerView addSubview:itemToInsert];
    }
    
    // add labels that are missing on right side
    M13InfiniteTabBarItem *lastItem = [_visibleIcons lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastItem frame]);
    while (rightEdge < maximumVisibleX) {
        rightEdge = [self placeNewLabelOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    M13InfiniteTabBarItem *firstItem = [_visibleIcons objectAtIndex:0];
    CGFloat leftEdge = CGRectGetMinX([firstItem frame]);
    while (leftEdge > minimumVisibleX) {
        leftEdge = [self placeNewLabelOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastItem = [_visibleIcons lastObject];
    while ([lastItem frame].origin.x > maximumVisibleX) {
        [lastItem removeFromSuperview];
        [_visibleIcons removeLastObject];
        lastItem = [_visibleIcons lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstItem = [_visibleIcons objectAtIndex:0];
    while (CGRectGetMaxX([firstItem frame]) < minimumVisibleX) {
        [firstItem removeFromSuperview];
        [_visibleIcons removeObjectAtIndex:0];
        firstItem = [_visibleIcons objectAtIndex:0];
    }
}

//Actions

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    //Calculate the location in _tabBarContainer Coordinates
    CGPoint location = [gesture locationInView:nil];
    location.x += (self.contentOffset.x - _tabContainerView.frame.origin.x);
    
    M13InfiniteTabBarItem *item = (M13InfiniteTabBarItem *)[self itemAtLocation:location];
    if (item != nil) {
        [self setSelectedItem:item];
    }
}

- (void)selectItemAtIndex:(NSUInteger)index
{
    if (index >= _items.count) {
        //Whoops, item doesn't exist.
        return;
    }
    
    //Select the current item
    if (index == _selectedItem.tag) {
        [self setSelectedItem:_selectedItem];
    }
    
    //Get the item at the given position in the tab bar. We will iterate from the left to the right, and look for the item with the same tag. Where will start depends on if we are infinite scrolling.
    CGFloat itemWidth = ((M13InfiniteTabBarItem *)[_items lastObject]).frame.size.width;
    //Calculate the offset of the number of tabs
    CGFloat offset = itemWidth * (index - _selectedItem.tag);
    //Scroll that amount, Auto selects item.
    [self setContentOffset:CGPointMake(self.contentOffset.x + offset, self.contentOffset.y) animated:YES];
}

- (void)setSelectedItem:(M13InfiniteTabBarItem *)selectedItem
{
    if (_items.count >= _minimumNumberOfTabsForScrolling) {
        //Convert the item's frame to self
        CGRect itemFrameInSelf = selectedItem.frame;
        itemFrameInSelf.origin.x += _tabContainerView.frame.origin.x;
        
        //Check to see if it is the center item
        if (self.contentOffset.x == itemFrameInSelf.origin.x - (self.frame.size.width / 2.0) + (itemFrameInSelf.size.width / 2.0)) {
            //Center tab tapped
            [self scrollViewDidEndScrollingAnimation:self];
        } else {
            //Other tab tapped
            [self setContentOffset:CGPointMake((itemFrameInSelf.origin.x + (itemFrameInSelf.size.width / 2.0)) - (self.frame.size.width / 2.0), 0) animated:YES];
        }
    } else {
        //Regular tab bar
        [self selectItem:selectedItem];
    }
}

- (void)item:(M13InfiniteTabBarItem *)item requiresUserAttention:(BOOL)requiresAttention
{
    for (M13InfiniteTabBarItem *anItem in _visibleIcons) {
        if (anItem.tag == item.tag) {
            [anItem setRequiresUserAttention:requiresAttention];
        }
    }
    
    for (M13InfiniteTabBarItem *anItem in _items) {
        if (anItem.tag == item.tag) {
            [anItem setRequiresUserAttention:requiresAttention];
        }
    }
}

- (M13InfiniteTabBarItem *)itemAtLocation:(CGPoint)theLocation {
    //Get the subview at the location given
    for (M13InfiniteTabBarItem *subView in _tabContainerView.subviews) {
        if (CGRectContainsPoint(subView.frame, theLocation)) {
            return subView;
        }
    }
    //Since we didn't tap a view, find the closest tab to the selection point (we need to do this since if we rotate the tabs, there is empty space. Performing this calculation is simpler than changing the frame of every tab.
    CGFloat distance = CGFLOAT_MAX;
    M13InfiniteTabBarItem *closestView;
    for (M13InfiniteTabBarItem *subView in _tabContainerView.subviews) {
        if (distance > [self distanceBetweenRect:subView.frame andPoint:theLocation]) {
            distance = [self distanceBetweenRect:subView.frame andPoint:theLocation];
            closestView = subView;
        }
    }
    return closestView;
}

- (CGFloat)distanceBetweenRect:(CGRect)rect andPoint:(CGPoint)point
{
    // first of all, we check if point is inside rect. If it is, distance is zero
    if (CGRectContainsPoint(rect, point)) return 0.f;
    
    // next we see which point in rect is closest to point
    CGPoint closest = rect.origin;
    if (rect.origin.x + rect.size.width < point.x)
        closest.x += rect.size.width; // point is far right of us
    else if (point.x > rect.origin.x)
        closest.x = point.x; // point above or below us
    if (rect.origin.y + rect.size.height < point.y)
        closest.y += rect.size.height; // point is far below us
    else if (point.y > rect.origin.y)
        closest.y = point.y; // point is straight left or right
    
    // we've got a closest point; now pythagorean theorem
    // distance^2 = [closest.x,y - closest.x,point.y]^2 + [closest.x,point.y - point.x,y]^2
    // i.e. [closest.y-point.y]^2 + [closest.x-point.x]^2
    CGFloat a = powf(closest.y-point.y, 2.f);
    CGFloat b = powf(closest.x-point.x, 2.f);
    return sqrtf(a + b);
}

//Scroll View Delegate Animations
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        //Get the item
        //Convert Superview points, to _tabContainerView points. (want the view in the center
        CGPoint location = CGPointMake((self.frame.size.width / 2.0) , (self.frame.size.height/2.0) + self.contentOffset.y);
        location.x += (self.contentOffset.x - _tabContainerView.frame.origin.x);
        
        M13InfiniteTabBarItem *item = (M13InfiniteTabBarItem *)[self itemAtLocation:location];
        
        //Convert the item's frame to self
        CGRect itemFrameInSelf = item.frame;
        itemFrameInSelf.origin.x = item.frame.origin.x + _tabContainerView.frame.origin.x;
        
        if (self.contentOffset.x != itemFrameInSelf.origin.x - (self.frame.size.width / 2.0) + (itemFrameInSelf.size.width / 2.0)) {
            [self setContentOffset:CGPointMake(itemFrameInSelf.origin.x - (self.frame.size.width / 2.0) + (itemFrameInSelf.size.width / 2.0), 0) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //Convert Superview points, to _tabContainerView points. (want the view in the center
    CGPoint location = CGPointMake((self.frame.size.width / 2.0) , (self.frame.size.height/2.0) + self.contentOffset.y);
    location.x += (self.contentOffset.x - _tabContainerView.frame.origin.x);
    
    M13InfiniteTabBarItem *item = (M13InfiniteTabBarItem *)[self itemAtLocation:location];
    
    //Convert the item's frame to self
    CGRect itemFrameInSelf = item.frame;
    itemFrameInSelf.origin.x = item.frame.origin.x + _tabContainerView.frame.origin.x;
    
    if (self.contentOffset.x != itemFrameInSelf.origin.x - (self.frame.size.width / 2.0) + (itemFrameInSelf.size.width / 2.0)) {
        [self setContentOffset:CGPointMake(itemFrameInSelf.origin.x - (self.frame.size.width / 2.0) + (itemFrameInSelf.size.width / 2.0), 0) animated:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!_scrollAnimationCheck) {
        //Update View Controllers
        //Convert Superview points, to _tabContainerView points. (want the view in the center
        CGPoint location = CGPointMake((self.frame.size.width / 2.0) , (self.frame.size.height/2.0) + self.contentOffset.y);
        location.x += (self.contentOffset.x - _tabContainerView.frame.origin.x);
        
        M13InfiniteTabBarItem *item = (M13InfiniteTabBarItem *)[self itemAtLocation:location];
        [self selectItem:item];
    } else {
        _scrollAnimationCheck = NO;
    }
}

- (void)selectItem:(M13InfiniteTabBarItem *)item
{
    BOOL shouldUpdate = YES;
    if ([_tabBarDelegate respondsToSelector:@selector(infiniteTabBar:shouldSelectItem:)]) {
        shouldUpdate = [_tabBarDelegate infiniteTabBar:self shouldSelectItem:item];
    }
    
    if (shouldUpdate) {
        //Set the opacity of the new view controller to 0 before the animation starts
        if ([_tabBarDelegate respondsToSelector:@selector(infiniteTabBar:willAnimateInViewControllerForItem:)]) {
            [_tabBarDelegate infiniteTabBar:self willAnimateInViewControllerForItem:item];
        }
        
        [UIView beginAnimations:@"TabChangedAnimation" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationDelegate:self];
        
        //Swap Nav controllers
        if ([_tabBarDelegate respondsToSelector:@selector(infiniteTabBar:animateInViewControllerForItem:)]) {
            [_tabBarDelegate infiniteTabBar:self animateInViewControllerForItem:item];
        }
        
        //Change Tabs
        //Set selected highlight tab on every visible tab with tag, and the one in the available array to highlight all icons while scrolling
        [item setSelected:YES];
        M13InfiniteTabBarItem *hiddenItem = [_items objectAtIndex:item.tag];
        [hiddenItem setSelected:YES];
        //Remove highlight on every other tab
        for (M13InfiniteTabBarItem *temp in _items) {
            if (temp.tag != item.tag) {
                [temp setSelected:NO];
            }
        }
        for (M13InfiniteTabBarItem *temp in _visibleIcons) {
            if (temp.tag != item.tag) {
                [temp setSelected:NO];
            }
        }
        
        _previousSelectedIndex = item.tag;
        _selectedItem = item;
        
        [UIView setAnimationDidStopSelector:@selector(didSelectItem)];
        
        [UIView commitAnimations];
    } else {
        if (_items.count >= _minimumNumberOfTabsForScrolling) {
            //Scroll Back to nearest tab with previous index
            M13InfiniteTabBarItem *oldItem = nil;
            for (M13InfiniteTabBarItem *temp in _visibleIcons) {
                if (temp.tag == _previousSelectedIndex) {
                    oldItem = temp;
                }
            }
            if (oldItem == nil) {
                //calculate offset between current center view origin and next previous view origin.
                float offsetX = (_previousSelectedIndex - item.tag) * item.frame.size.width;
                //add this to the current offset
                offsetX += self.contentOffset.x + _tabContainerView.frame.origin.x;
                [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            } else {
                //Use that view if exists
                CGFloat oldX = oldItem.frame.origin.x;
                oldX += _tabContainerView.frame.origin.x;
                
                
                [self setContentOffset:CGPointMake((oldX + (oldItem.frame.size.width / 2.0) - (self.frame.size.width / 2.0)), 0) animated:YES];
            }
            _scrollAnimationCheck = YES;
        }
        //Else, we don't need to scroll, since we are a basic tab bar.
    }
}

//Finished tab change animation
- (void)didSelectItem
{
    if ([_tabBarDelegate respondsToSelector:@selector(infiniteTabBar:didSelectItem:)]) {
        [_tabBarDelegate infiniteTabBar:self didSelectItem:_selectedItem];
    }
}

@end
