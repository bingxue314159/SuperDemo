//
//  UIButton+JJButton.h
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  Specific events to UIButton when using JJButtonMatrix
 */
typedef NS_ENUM(short, JJButtonEventType) {
    /**
     *  Event as same as UIControlEventTouchUpInside. This will execute automatically when add a block selection action with this event.
     */
    JJButtonEventTouchUpInside,
    /**
     *  Event when the button pass from selection to normal (Only if is inside a JJButtonMatrix).
     */
    JJButtonEventDeselect,
    /**
     *  Event when the button pass from normal to selection (Only if is inside a JJButtonMatrix).
     */
    JJButtonEventSelect,
    /**
     *  Event when the button is selected and is press again (Only if is inside a JJButtonMatrix).
     */
    JJButtonEventReselect
};

/**
 *  Block executed when an event JJButtonEventType occurs.
 *
 *  @param UIButton*         button that receives the event
 *  @param JJButtonEventType type of the event
 */
typedef void (^JJButtonSelectionBlock)(UIButton* button, JJButtonEventType type);

/**
 *  Category that add's extra functionality on button with this framework.
 */
@interface UIButton (JJButton)

/**
 *  Index of the UIButton when is inside a JJButtonMatrix.
 *  Default: NSNotFound
 */
@property(nonatomic,assign) NSInteger selectionIndex;

/**
 *  Adds a execution block for a JButtonEventType
 */
- (void)addBlockSelectionAction:(JJButtonSelectionBlock)action forEvent:(JJButtonEventType)event;

/**
 *  Removes a block from an event.
 *  Setting the parameter action to nil will remove all blocks for that event.
 *
 */
- (void)removeBlockSelectionAction:(JJButtonSelectionBlock)action forEvent:(JJButtonEventType)event;

/**
 *  Removes all blocks from all events.
 */
- (void)removeAllBlocks;

/**
 *  Executes all blocks for a specific event.
 */
- (void)performBlockSelectionForEvent:(JJButtonEventType)type;

@end
