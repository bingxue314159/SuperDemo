//
//  JJTabBarView.m
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import "JJTabBarView.h"
#import "UIScrollView+JJCenterScroll.h"
#import "JJButtonMatrix.h"


@interface JJTabBarView ()

@property(nonatomic,readwrite) JJButtonMatrix *matrix;
@property(nonatomic,assign) BOOL needsAnimateSelection;
@property(nonatomic,assign) CGRect previousBounds;

@end


@implementation JJTabBarView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupJJTabBarView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupJJTabBarView];
    }
    return self;
}

- (void)setupJJTabBarView {
    _matrix = [[JJButtonMatrix alloc] init];
    self.needsAnimateSelection = NO;
    self.previousBounds = self.bounds;
}

#pragma mark - override super properties

- (void)setChildViews:(NSArray *)childViews {
    
    if (childViews == nil) {
        childViews = @[];
    }
    
    for (UIButton *button in self.matrix.buttonsArray) {
        [button removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    }
    
    NSMutableArray *childsButtons = [NSMutableArray arrayWithCapacity:childViews.count];
    for (UIButton *button in childViews) {
        [button addTarget:self action:@selector(actionSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [childsButtons addObject:button];
    }
    
    self.matrix.buttonsArray = childsButtons;    
    [super setChildViews:childViews];
}


#pragma mark - public properties

@dynamic selectedTabBar;
- (UIButton *)selectedTabBar {
    return self.matrix.selectedButton;
}

- (void)setSelectedTabBar:(UIButton *)selectedTabBar {
    if (selectedTabBar != self.selectedTabBar) {
        self.matrix.selectedButton = selectedTabBar;
        [self setNeedsLayout];
    }
}

@dynamic selectedIndex;
- (NSInteger)selectedIndex {
    return self.matrix.selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex != self.selectedIndex) {
        self.matrix.selectedIndex = selectedIndex;
        [self setNeedsLayout];
    }
}

- (void)setCenterTabBarOnSelect:(BOOL)centerTabBarOnSelect {
    
    if (_centerTabBarOnSelect != centerTabBarOnSelect) {
         [self setNeedsLayout];
    }
    
    _centerTabBarOnSelect = centerTabBarOnSelect;
    
    if (centerTabBarOnSelect && !self.scrollEnabled ) {
        self.scrollEnabled = YES;
    }
}

- (void)setAlwaysCenterTabBarOnSelect:(BOOL)alwaysCenterTabBarOnSelect {
    
    if (_alwaysCenterTabBarOnSelect != alwaysCenterTabBarOnSelect) {
        [self setNeedsLayout];
    }
    
    _alwaysCenterTabBarOnSelect = alwaysCenterTabBarOnSelect;
    
    if ( _alwaysCenterTabBarOnSelect ) {
        self.centerTabBarOnSelect = YES;
    }
}

#pragma mark - public actions

- (void)setSelectedTabBar:(UIButton *)selectedTabBar animated:(BOOL)animated {
    self.needsAnimateSelection = animated;
    self.selectedTabBar = selectedTabBar;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    self.needsAnimateSelection = animated;
    self.selectedIndex = selectedIndex;
}

#pragma mark - private actions

- (void)actionSelectedButton:(UIButton *)button {
    [self positionButton:button animated:YES];
}

- (void)positionButton:(UIButton *)button animated:(BOOL)animated {
    if ( self.centerTabBarOnSelect || self.alwaysCenterTabBarOnSelect ) {
        [_scrollContainer scrollRectToCenter:button.frame animated:animated];
    } else {
        [_scrollContainer scrollRectToVisible:button.frame animated:animated];
    }
}

#pragma mark - UIView methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    NSArray *buttonsArray = self.matrix.buttonsArray;
    NSArray *viewsArray = _scrollContainer.subviews;
    
    if ( self.alwaysCenterTabBarOnSelect && viewsArray.count > 0 ) {
        
        CGRect minRect = ((UIView *)buttonsArray[0]).frame;
        CGRect maxRect = ((UIView *)buttonsArray[buttonsArray.count-1]).frame;
        
        if ( self.alignment == JJBarViewAlignmentHorizontal ) {
            CGFloat minDelta = bounds.size.width/2.0f - minRect.size.width/2.0f;
            CGFloat maxDelta = bounds.size.width/2.0f - maxRect.size.width/2.0f;
            for (UIView *subView in viewsArray) {
                CGRect frame = subView.frame;
                frame.origin.x += minDelta;
                subView.frame = frame;
            }
            CGSize size = _scrollContainer.contentSize;
            size.width += minDelta + maxDelta;
            _scrollContainer.contentSize = size;
            
        }else if ( self.alignment == JJBarViewAlignmentVertical ) {
            CGFloat minDelta = bounds.size.height/2.0f - minRect.size.height/2.0f;
            CGFloat maxDelta = bounds.size.height/2.0f - maxRect.size.height/2.0f;
            for (UIView *subView in viewsArray) {
                CGRect frame = subView.frame;
                frame.origin.y += minDelta;
                subView.frame = frame;
            }
            CGSize size = _scrollContainer.contentSize;
            size.height += minDelta + maxDelta;
            _scrollContainer.contentSize = size;
            
        }
    }
    
    if ( self.selectedTabBar ) {
        [self positionButton:self.selectedTabBar animated:self.needsAnimateSelection];
    }
    
    self.needsAnimateSelection = NO;
    self.previousBounds = bounds;
}

@end
