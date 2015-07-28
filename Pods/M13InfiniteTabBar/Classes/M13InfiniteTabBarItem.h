//
//  M13InfiniteTabBarItem.h
//  M13InfiniteTabBar
/*
 Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 One does not claim this software as ones own.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

/** This class is similar to the `UITabBarItem` class. */
@interface M13InfiniteTabBarItem : UIView

/** @name Initalization */
/** Initalize the `M13InfiniteTabBarItem`.
 @warning The icon should be 30x30px or 60x60px for @2x, specifing a larger image will incur noticeable performance costs.
 @note The icon is treated as a mask. Anything that should be transparant make white. Anything solid make black. You can use gray for semi transparant. 
 @param title   The text that should be displayed, usually the title of the UIViewController.
 @param selectedIconMask The icon to be displayed when the item is selected.
 @param unselectedIconMask The icon to be displayed when the item is unselected.
 @return An instance of `M13InfiniteTabBarItem`. */
- (id)initWithTitle:(NSString *)title selectedIconMask:(UIImage *)selectedIconMask unselectedIconMask:(UIImage *)unselectedIconMask;

/** @name Appearance */
/** The image that will show as the tab bar item's background.
 @note The Background Image moves with the tabs. The default is no background, the image would show instead of the tab bar's background. This image should be 64x50px on the retina iPhone, and 70x50px on the retina iPad, I trust that you can divide by two to get the non retina values. */
@property (nonatomic, retain) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;
/** The font of the titles. When changing the font, the font size should be left at the default size (7.0) */
@property (nonatomic, retain) UIFont *titleFont UI_APPEARANCE_SELECTOR;
/** The image that is overlayed onto the icon when it is selected. This should be the same size as the icon. */
@property (nonatomic, retain) UIImage *selectedIconOverlayImage UI_APPEARANCE_SELECTOR;
/** The tint color that is overlayed onto the icon when it is selected. This will show if the `selectedIconOverlayImage` is `nil`. */
@property (nonatomic, retain) UIColor *selectedIconTintColor UI_APPEARANCE_SELECTOR;
/** The image that is overlayed onto the icon when it is unselected. This should be the same size as the icon. */
@property (nonatomic, retain) UIImage *unselectedIconOverlayImage UI_APPEARANCE_SELECTOR;
/** The tint color that is overlayed onto the icon when it is unselected. This will show if the `unselectedIcoOverlayImage` is 'nil`. */
@property (nonatomic, retain) UIColor *unselectedIconTintColor UI_APPEARANCE_SELECTOR;
/**The image that is overlayed onto the icon when the tab requires user attention.*/
@property (nonatomic, retain) UIImage *attentionIconOverlayImage UI_APPEARANCE_SELECTOR;
/**The tint color that is overlayed onto the icon the tab requires user attention.*/
@property (nonatomic, retain) UIColor *attentionIconTintColor UI_APPEARANCE_SELECTOR;
/** The color of the title text when the item is selected. */
@property (nonatomic, retain) UIColor *selectedTitleColor UI_APPEARANCE_SELECTOR;
/** The color of the title text when the item is unselected. */
@property (nonatomic, retain) UIColor *unselectedTitleColor UI_APPEARANCE_SELECTOR;
/** The color of the icon text when the tab requires user attention.*/
@property (nonatomic, retain) UIColor *attentionTitleColor UI_APPEARANCE_SELECTOR;

/** @name Other */
/** Used to set wether the item is selected or not. 
 @warning This should only be used by `M13InfiniteTabBar`, using this method will result in unexpected behavior. If you want to select a tab, go through `M13InfinteTabBar`.
 @param selected    Wether or not that tab is selected.*/
- (void)setSelected:(BOOL)selected;
/** Duplicate a `M13InfiniteTabBarItem`. */
- (id)copy;
/** Rotate the item to the given angle.
 @warning This should only be used by `M13InfiniteTabBar`, using this method will result in unexpected behavior. Rotation of the items is handled by `M13InfiniteTabBar`.
 @param angle   The angle to rotate the item to. */
- (void)rotateToAngle:(CGFloat)angle; //handling view rotation
/** Used to set wether the view controller the tab represents requires user attention.
 @warning This should only be used by `M13InfiniteTabBar`, using this method will result in unexpected behavior. If you want a tab to ask for user attention, go through `M13InfinteTabBar`.
 @param requiresAttention    Wether or not the tab should display that it requires user attention.*/
- (void)setRequiresUserAttention:(BOOL)requiresAttention;

@end
