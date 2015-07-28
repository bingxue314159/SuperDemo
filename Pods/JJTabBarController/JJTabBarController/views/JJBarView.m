//
//  JJBarView.m
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import "JJBarView.h"

#define ValueNotDefine 0

@interface JJBarView () <UIScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *separatorImageViews;
@property(nonatomic,strong) UIImageView *backgroundView;
@property(nonatomic,strong) UIScrollView *scrollContainer;
@property(nonatomic,weak) UIView *subViewsContainer;
@property(nonatomic,assign) CGFloat scrollBoxFixSize;
@property(nonatomic,assign) NSInteger scrollViewsCounter;
@property(nonatomic,assign) float partialViewPercentage;

@end


@implementation JJBarView

@synthesize scrollContainer = _scrollContainer;

#pragma mark - Initialization

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, 320, 44)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupJJBarView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupJJBarView];
    }
    return self;
}

- (void)setupJJBarView {
    _alignment = JJBarViewAlignmentHorizontal;
    self.subViewsContainer = self;
    self.autoResizeChilds = YES;
    self.separatorImageViews = nil;
    _childViews = @[];
}


#pragma mark - public properties

@dynamic backgroundImage;
- (UIImage *)backgroundImage {
    return _backgroundView.image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if ( backgroundImage ) {
        
        if (self.backgroundView == nil) {
            _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
            _backgroundView.contentMode = UIViewContentModeScaleToFill;
            _backgroundView.backgroundColor = [UIColor clearColor];
            _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self insertSubview:_backgroundView atIndex:0];
        }
        
        _backgroundView.image = backgroundImage;
        
    } else {
        [_backgroundView removeFromSuperview];
    }
}

- (void)setAlignment:(JJBarViewAlignment)alignment {
    _alignment = alignment;
    [self setNeedsLayout];
}

- (void)setChildEdges:(UIEdgeInsets)childEdges {
    _childEdges = childEdges;
    [self setNeedsLayout];
}

- (void)setImageSeparator:(UIImage *)imageSeparator {
    if ( imageSeparator == nil || _imageSeparator != imageSeparator ) {
        for (UIImageView *separatorView in self.separatorImageViews) {
            [separatorView removeFromSuperview];
        }
    }
    
    _imageSeparator = imageSeparator;
    self.separatorImageViews = nil;
    
    [self setNeedsLayout];
}

- (void)setAutoResizeChilds:(BOOL)autoResizeChilds {
    _autoResizeChilds = autoResizeChilds;
    [self setNeedsLayout];
}

- (void)setChildViews:(NSArray *)childViews {
    
    // remove all tabViews
    for (UIView *subBarView in _childViews) {
        [subBarView removeFromSuperview];
    }
    
    for (UIImageView *separatorView in self.separatorImageViews) {
        [separatorView removeFromSuperview];
    }
    
    self.separatorImageViews = nil;
    
    // get a copy of array
    _childViews = [childViews copy];
    if (_childViews == nil) {
        _childViews = @[];
    }
    
    [self setNeedsLayout];
}


#pragma mark - scroll

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;

    if (_scrollEnabled && self.scrollContainer == nil) {
        _scrollContainer = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollContainer.backgroundColor = [UIColor clearColor];
        _scrollContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollContainer.showsHorizontalScrollIndicator = NO;
        _scrollContainer.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollContainer];
    }
    self.subViewsContainer = (_scrollEnabled ? self.scrollContainer : self );

    self.scrollViewsCounter = ValueNotDefine;
    self.scrollBoxFixSize = ValueNotDefine;

    [self setNeedsLayout];
}

- (void)setScrollEnabledWithNumberOfChildsVisible:(float)numberOfChildsVisible {
    
    NSAssert( numberOfChildsVisible > 0, @"numberOfChildsVisible must be great than 0" );
    
    self.scrollEnabled = YES;
    self.autoResizeChilds = YES;
    self.scrollViewsCounter = (int)numberOfChildsVisible;
    self.partialViewPercentage = fmodf(numberOfChildsVisible, 1.0);
    self.scrollBoxFixSize = ValueNotDefine;
    [self setNeedsLayout];
}

- (void)setScrollEnabledWithChildSize:(CGFloat)childsSize {
    self.scrollEnabled = YES;
    self.autoResizeChilds = YES;
    self.scrollViewsCounter = ValueNotDefine;
    self.scrollBoxFixSize = childsSize;
    [self setNeedsLayout];
}


#pragma mark - private methods

- (void)prepareImageSeparators {
    if ( _childViews.count > 1 && _imageSeparator && self.separatorImageViews == nil ) {
        
        _separatorImageViews = [[NSMutableArray alloc] initWithCapacity: _childViews.count - 1];
        for ( NSInteger i = 0; i < _childViews.count - 1; i++ ) {
            UIImageView *imageSeparatorView = [[UIImageView alloc] initWithImage:_imageSeparator];
            imageSeparatorView.contentMode = UIViewContentModeScaleToFill;
            UIView *container = (self.isScrollEnabled ? _scrollContainer : self);
            [container addSubview:imageSeparatorView];
            [_separatorImageViews addObject:imageSeparatorView];
        }
    }
}

- (void)verifyChangesOfContainer {
    
    if ( _childViews.count > 0 ) {
        
        UIView *fatherView = _childViews[0];
        fatherView = fatherView.superview;
        if ( fatherView != self.subViewsContainer ) {
            
            for ( UIView *subView in _childViews ) {
                [self.subViewsContainer addSubview:subView];
            }
            
            for ( UIView *subView in self.separatorImageViews ) {
                [self.subViewsContainer addSubview:subView];
            }
        }
    }
    
    if (_scrollViewsCounter > _childViews.count) {
        _scrollViewsCounter = _childViews.count;
    }
}

- (CGRect)childFrameSlotWithScrollEnabled:(BOOL)scrollEnabled {
    
    CGRect frame = CGRectZero;
    CGRect bounds = self.bounds;
    
    // CGRectNull no change in frame
    if ( self.alignment == JJBarViewAlignmentNone ) {
        return CGRectNull;
    }
    
    // CGRectZero no change in size
    if ( (scrollEnabled && self.scrollViewsCounter == ValueNotDefine && self.scrollBoxFixSize == ValueNotDefine) ) {
        return CGRectZero;
    }
    
    if ( scrollEnabled  && self.scrollBoxFixSize != ValueNotDefine ) {
        
        switch (self.alignment) {
            case JJBarViewAlignmentHorizontal:
                frame.size.width = self.scrollBoxFixSize;
                frame.size.height = bounds.size.height;
                break;
                
            case JJBarViewAlignmentVertical:
                frame.size.width = bounds.size.width;
                frame.size.height = self.scrollBoxFixSize;
                break;
                
            default:
                return CGRectNull;
        }
    } else {
        
        CGFloat boxCount = _childViews.count;
        int separatorCount = boxCount - 1;
        CGSize separatorSize = _imageSeparator.size;
        CGFloat totalSpace = 0;
        
        if ( scrollEnabled && self.scrollViewsCounter != ValueNotDefine ) {
            boxCount = self.scrollViewsCounter;
            separatorCount = boxCount - 1;
            
            if (self.partialViewPercentage > 0) {
                separatorCount = boxCount;
                boxCount += self.partialViewPercentage;
            }
        }
        
        switch (_alignment) {
            case JJBarViewAlignmentHorizontal:
                totalSpace = ( _imageSeparator ? bounds.size.width - separatorSize.width * separatorCount : bounds.size.width );
                frame.size.width = totalSpace / boxCount;
                frame.size.height = bounds.size.height;
                break;
                
            case JJBarViewAlignmentVertical:
                totalSpace = ( _imageSeparator ? bounds.size.height - separatorSize.height * separatorCount : bounds.size.height );
                frame.size.width = bounds.size.width;
                frame.size.height = totalSpace / boxCount;
                break;
                
            default:
                return CGRectNull;
        }
        
    }
    
    return frame;
}

- (UIView *)positionChildsWithFrameSlot:(CGRect)frameSlot allowChildChangeSize:(BOOL)allowChildChangeSize {
    
     BOOL hasFrameSlot = !CGRectEqualToRect(frameSlot, CGRectZero);
    
    CGRect bounds = self.bounds;
    UIView *childView = nil;
    UIView *previousChildView = nil;
    
    for ( NSInteger i = 0; i < _childViews.count; i++ ) {
        
        previousChildView = childView;
        childView = _childViews[i];
        UIImageView *imageSeparatorView = nil;
        CGRect imageViewFrame = CGRectZero;
        
        // has image separator
        if ( self.imageSeparator && i < _childViews.count - 1 ) {
            imageSeparatorView = self.separatorImageViews[i];
            imageViewFrame.size = imageSeparatorView.frame.size;
        }
        
        // define child frame
        CGRect frame = frameSlot;
        if ( allowChildChangeSize ) {
            frame = UIEdgeInsetsInsetRect(frame, self.childEdges);
        } else {
            frame = childView.frame;
            frame.origin = CGPointZero;
        }
        
        switch (self.alignment) {
                
            case JJBarViewAlignmentHorizontal:
            {
                CGFloat childViewShift = 0;
                CGFloat imageSeparatorShift = 0;
                CGFloat nextSlot = 0;
                
                if ( hasFrameSlot ) {
                    
                    if ( allowChildChangeSize ) {
                        childViewShift = UIEdgeInsetsInsetRect(frameSlot, self.childEdges).origin.x;
                    } else {
                        childViewShift = (frameSlot.size.width - childView.frame.size.width) / 2.0f;
                    }
                    
                    nextSlot = (frameSlot.size.width * i) + (self.imageSeparator.size.width * i);
                    imageSeparatorShift = nextSlot + frameSlot.size.width;
                    childViewShift = nextSlot + childViewShift;
                    
                } else {
                    
                    nextSlot = ( previousChildView == nil ?
                                0 :
                                CGRectGetMaxX(previousChildView.frame) + self.childEdges.right + imageViewFrame.size.width);
                    childViewShift = nextSlot + self.childEdges.left;
                    imageSeparatorShift = childViewShift + frame.size.width + self.childEdges.right;
                }
                
                frame.origin = CGPointMake(childViewShift, CGRectGetMidY(bounds) - frame.size.height/2.0f);
                
                if ( imageSeparatorView ) {
                    imageViewFrame.origin = CGPointMake( imageSeparatorShift, CGRectGetMidY(bounds) - imageViewFrame.size.height/2.0f);
                    imageSeparatorView.frame = imageViewFrame;
                }
                
            } break;
                
            case JJBarViewAlignmentVertical:
            {
                CGFloat childViewShift = 0;
                CGFloat imageSeparatorShift = 0;
                CGFloat nextSlot = 0;
                
                if ( hasFrameSlot ) {
                    
                    if ( allowChildChangeSize ) {
                        childViewShift = UIEdgeInsetsInsetRect(frameSlot, self.childEdges).origin.y;
                    } else {
                        childViewShift = (frameSlot.size.height - childView.frame.size.height) / 2.0f;
                    }
                    
                    nextSlot = (frameSlot.size.height * i) + (self.imageSeparator.size.height * i);
                    imageSeparatorShift = nextSlot + frameSlot.size.height;
                    childViewShift = nextSlot + childViewShift;
                    
                } else {
                    
                    nextSlot = ( previousChildView == nil ?
                                0 :
                                CGRectGetMaxY(previousChildView.frame) + self.childEdges.bottom + imageViewFrame.size.height);
                    childViewShift = nextSlot + self.childEdges.top;
                    imageSeparatorShift = childViewShift + frame.size.height + self.childEdges.bottom;
                }
                
                frame.origin = CGPointMake(CGRectGetMidX(bounds) - frame.size.width/2.0f, childViewShift);
                
                if (imageSeparatorView) {
                    imageViewFrame.origin = CGPointMake(CGRectGetMidX(bounds) - imageViewFrame.size.width/2.0f, imageSeparatorShift);
                    imageSeparatorView.frame = imageViewFrame;
                }
                
            } break;
                
            default:
                break;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(barView:layoutChild:withFrame:)] ) {
            [self.delegate barView:self layoutChild:childView withFrame:frame];
        }else {
            childView.frame = frame;
        }
    }
    
    // return last child
    return childView;
}

#pragma mark - UIView methods

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    [self verifyChangesOfContainer];
    
    CGRect childFrameSlot = [self childFrameSlotWithScrollEnabled:self.scrollEnabled];
    if (CGRectIsNull(childFrameSlot)) {
        return;
    }
    
    BOOL allowChildChangeSize = self.autoResizeChilds;
    if ( CGRectIsEmpty(childFrameSlot) ) {
        allowChildChangeSize = NO;
    }
    
    [self prepareImageSeparators];
    
    UIView *lastChild = [self positionChildsWithFrameSlot:childFrameSlot allowChildChangeSize:allowChildChangeSize];
    
    _backgroundView.frame = bounds;
    
    if ( _scrollEnabled && _childViews.count > 0 ) {
        
        CGSize size;
        
        if ( _alignment == JJBarViewAlignmentHorizontal ) {
            
            size = CGSizeMake( CGRectGetMaxX(lastChild.frame) + self.childEdges.right, CGRectGetMaxY(bounds));
            
            if (self.scrollEnabled && size.width < bounds.size.width) {
                // too much space available
                // recalculate buttons frame to center
                CGRect subViewFrame = [self childFrameSlotWithScrollEnabled:NO];
                lastChild = [self positionChildsWithFrameSlot:subViewFrame allowChildChangeSize:NO];
                size = CGSizeMake( CGRectGetMaxX(lastChild.frame) + self.childEdges.right, CGRectGetMaxY(bounds));
            }
            
        } else if ( _alignment == JJBarViewAlignmentVertical ) {
            
            size = CGSizeMake( CGRectGetMaxX(bounds), CGRectGetMaxY(lastChild.frame) + self.childEdges.bottom );
            
            if (self.scrollEnabled && size.height < bounds.size.height) {
                // too much space available
                // recalculate buttons frame to center
                CGRect subViewFrame = [self childFrameSlotWithScrollEnabled:NO];
                lastChild = [self positionChildsWithFrameSlot:subViewFrame allowChildChangeSize:NO];
                size = CGSizeMake( CGRectGetMaxX(bounds), CGRectGetMaxY(lastChild.frame) + self.childEdges.bottom );
            }
        }
        
        _scrollContainer.contentSize = size;
    }
}

@end



