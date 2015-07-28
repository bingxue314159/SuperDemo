//
//  JJBarView.h
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Type that describes the position of the child's views relative to the bar.
 */
typedef NS_ENUM(short, JJBarViewAlignment) {
    /**
     *  Defines the alignment as horizontal
     */
    JJBarViewAlignmentHorizontal,
    /**
     *  Defines the alignment as vertical
     */
    JJBarViewAlignmentVertical,
    /**
     *  No alignment, freeform.
     */
    JJBarViewAlignmentNone
};

/**
 *  A bar that reposition it's child views relative to the alignment choosen.
 *  By default will try to put all childs views inside with the same size.
 *  It can be transform to a scroll bar by defining it's size child's or the number of childs visible.
 *  Or by just setting the scrollEnabled property to YES will not change the child's size.
 */
@protocol JJBarViewDelegate;
@interface JJBarView : UIView {
    
    UIScrollView *_scrollContainer;
}

/**
 *  Delegate of the bar to adjust better the position and size of the child views.
 *  Default: nil
 */
@property(nonatomic,weak) id<JJBarViewDelegate> delegate;

/**
 *  Array of UIView's that are going to rearrange it's position and size.
 *  Default: @[]
 */
@property(nonatomic,copy) IBOutletCollection(UIView) NSArray *childViews;

/**
 *  Type of position of the child's views relative to the bar. 
 *  Default: JJBarViewAlignmentHorizontal
 */
@property(nonatomic,assign) JJBarViewAlignment alignment;

/**
 *  To dynamic create a image as background. Will streach the image to bounds size.
 *  Default: nil
 */
@property(nonatomic,strong) UIImage *backgroundImage;

/**
 *  Add's a image between each child view.
 *  Default: nil
 */
@property(nonatomic,strong) UIImage *imageSeparator;

/**
 *  Add's edge inset to each child view.
 *  Default: {0, 0, 0, 0}
 */
@property(nonatomic,assign) UIEdgeInsets childEdges;

/**
 *  If YES will resize it's subviews accordling to it's policy. If NO, just the position is going to be changed, overriding the scroll policy.
 *  Default: YES
 */
@property(nonatomic,assign) BOOL autoResizeChilds;


#pragma mark - bar view scroll enable

/**
 *  If there is a scroll policy for manage the child views.
 *  Setting this property to YES will transform the bar as a scroll by mantain it's child size's.
 *  Default: NO
 */
@property(nonatomic,assign,getter = isScrollEnabled) BOOL scrollEnabled;

/**
 *  Enable scroll with a number visible of childs. Each child will be resized to reach the effect desired.
 *  If the number has a fraction part then will add that part of the child.
 *
 *  @param numberOfBarSubViewsVisible number visible of childs
 */
- (void)setScrollEnabledWithNumberOfChildsVisible:(float)numberOfChildsVisible;

/**
 *  Enable scroll where each child view has a specific size (on horizontal is  width, on vertical is height)
 *
 *  @param barSubViewsSize fixed width or height of each child subview
 */
- (void)setScrollEnabledWithChildSize:(CGFloat)childsSize;

@end

/**
 *  Protocol representing the delegate of the JBarView.
 */
@protocol JJBarViewDelegate <NSObject>
@optional

/**
 *  Custom position of the tab views. The frame is the space of the tab container divided with the number of tabViews.
 *
 *  @param barView   owner of the delegate
 *  @param childView child being layout
 *  @param frame     frame of the child
 */
- (void)barView:(JJBarView *)barView layoutChild:(UIView *)childView withFrame:(CGRect)frame;

@end

