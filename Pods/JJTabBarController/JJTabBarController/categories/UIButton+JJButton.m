//
//  UIButton+JButton.m
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import "UIButton+JJButton.h"
#import <objc/runtime.h>


@implementation UIButton (JJButton)

static const NSString *KEY_ASSOC_JJButtonEventDeselect = @"JJButton.JJButtonEventDeselect";
static const NSString *KEY_ASSOC_JJButtonEventSelect = @"JJButton.JJButtonEventSelect";
static const NSString *KEY_ASSOC_JJButtonEventReselect = @"JJButton.JJButtonEventReselect";
static const NSString *KEY_ASSOC_JJButtonEventTouchUpInside = @"JJButton.JJButtonEventTouchUpInside";
static const NSString *KEY_ASSOC_SelectionIndex = @"JJButton.selectionIndex";

#pragma mark - private

-(NSMutableArray *)blockSelectionActionsForEvent:(JJButtonEventType)event {
    
    NSMutableArray* blocks = nil;
    switch (event) {
        case JJButtonEventTouchUpInside:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JJButtonEventTouchUpInside);
            break;
        case JJButtonEventSelect:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JJButtonEventSelect);
            break;
        case JJButtonEventReselect:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JJButtonEventReselect);
            break;
        case JJButtonEventDeselect:
            blocks = (NSMutableArray *)objc_getAssociatedObject(self, &KEY_ASSOC_JJButtonEventDeselect);
            break;
            
        default:
            break;
    }
    
    if (blocks == nil) {
        blocks = [NSMutableArray array];
    }
    return blocks;
}

-(void)setBlockSelectionActions:(NSMutableArray *)blockSelectionActions forEvent:(JJButtonEventType)event {
    
    if ( blockSelectionActions.count == 0 ) {
        blockSelectionActions = nil;
    }
    
    switch (event) {
        case JJButtonEventTouchUpInside:
            objc_setAssociatedObject(self, &KEY_ASSOC_JJButtonEventTouchUpInside, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            if (blockSelectionActions) {
                [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case JJButtonEventSelect:
            objc_setAssociatedObject(self, &KEY_ASSOC_JJButtonEventSelect, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            break;
        case JJButtonEventReselect:
            objc_setAssociatedObject(self, &KEY_ASSOC_JJButtonEventReselect, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            break;
        case JJButtonEventDeselect:
            objc_setAssociatedObject(self, &KEY_ASSOC_JJButtonEventDeselect, blockSelectionActions, OBJC_ASSOCIATION_RETAIN);
            break;
            
        default:
            break;
    }
}


@dynamic selectionIndex;
- (NSInteger)selectionIndex {
    NSNumber *indexNumber = (NSNumber *)objc_getAssociatedObject(self, &KEY_ASSOC_SelectionIndex);
    if (indexNumber == nil) {
        return NSNotFound;
    }else
        return [indexNumber integerValue];
}

- (void)setSelectionIndex:(NSInteger)selectionIndex {
    NSNumber *indexNumber = [NSNumber numberWithInteger:selectionIndex];
    objc_setAssociatedObject(self, &KEY_ASSOC_SelectionIndex, indexNumber, OBJC_ASSOCIATION_RETAIN);
}

- (void)addBlockSelectionAction:(JJButtonSelectionBlock)action forEvent:(JJButtonEventType)event {
    if (action) {
        NSMutableArray *blocks = [self blockSelectionActionsForEvent:event];
        [blocks addObject:action];
        [self setBlockSelectionActions:blocks forEvent:event];
    }
}

- (void)removeBlockSelectionAction:(JJButtonSelectionBlock)action forEvent:(JJButtonEventType)event {
    if (action) {
        NSMutableArray *blocks = [self blockSelectionActionsForEvent:event];
        [blocks removeObject:action];
        [self setBlockSelectionActions:blocks forEvent:event];
    } else {
        [self setBlockSelectionActions:nil forEvent:event];
    }
}

- (void)removeAllBlocks {
    [self setBlockSelectionActions:nil forEvent:JJButtonEventTouchUpInside];
    [self setBlockSelectionActions:nil forEvent:JJButtonEventDeselect];
    [self setBlockSelectionActions:nil forEvent:JJButtonEventSelect];
    [self setBlockSelectionActions:nil forEvent:JJButtonEventReselect];
}

- (void)performBlockSelectionForEvent:(JJButtonEventType)event {
    NSMutableArray *blocks = [self blockSelectionActionsForEvent:event];
    for (JJButtonSelectionBlock eventBlock in blocks) {
        eventBlock(self, event);
    }
}

- (void)onTouchUpInside:(UIButton *)sender {
    [self performBlockSelectionForEvent:JJButtonEventTouchUpInside];
}

@end
