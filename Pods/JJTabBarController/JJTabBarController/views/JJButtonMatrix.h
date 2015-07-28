//
//  JJButtonMatrix.h
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+JJButton.h"

/**
 *  Object responsible for manage the UIButton#selected state.
 *  Also fires the selection events of JJButtonEventType.
 */
@protocol JJButtonMatrixDelegate;
@interface JJButtonMatrix : NSObject

/**
 *  Array of buttons to be managed by this object.
 *  Default: @[]
 */
@property(nonatomic,copy) IBOutletCollection(UIButton) NSArray *buttonsArray;

/**
 *  The UIButton that is currently selected.
 *  Setting this to nil will deselect the button.
 *  Default: nil
 */
@property(nonatomic,weak) UIButton *selectedButton;

/**
 *  The UIButton#selectedIndex that is currently selected.
 *  Setting this to NSNotFound will deselect the button.
 *  Default: NSNotFound
 */
@property(nonatomic,assign) NSInteger selectedIndex;

/**
 *  Delegate to provide extra control over the matrix.
 */
@property(nonatomic,weak) id<JJButtonMatrixDelegate> delegate;

/**
 *  If YES, it allows when a selected button to be pressed to loose the selection status without other button receiving it.
 *  Default: NO
 */
@property(nonatomic,assign) BOOL allowEmptySelection;

/**
 *  Allow multiple UIButton's to receive the selection status.
 *  Default: NO
 */
@property(nonatomic,assign) BOOL allowMultipleSelection;

/**
 *  If 'allowMultipleSelection' is YES, all the selected buttons are provided by this property.
 *  Otherwise it only have the UIButton that is currently selected.
 */
@property(nonatomic,copy,readonly) NSArray *selectedButtons;

@end

/**
 *  Protocol representing the delegate of JJButtonMatrix.
 */
@protocol JJButtonMatrixDelegate <NSObject>
@optional

/**
 *  Allows to override the selection state of a UIButton used by the buttonMatrix.
 *  Returning NO will not select the button.
 */
- (BOOL)buttonMatrix:(JJButtonMatrix *)buttonMatrix willSelectButton:(UIButton *)button forIndex:(NSInteger)index;

/**
 *  Selector that executes after a sucessfull selection of a UIButton inside a buttonMatrix.
 */
- (void)buttonMatrix:(JJButtonMatrix *)buttonMatrix didSelectButton:(UIButton *)button forIndex:(NSInteger)index;

@end

