//
//  JJButtonMatrix.m
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import "JJButtonMatrix.h"

@interface JJButtonMatrix ()

@end

@implementation JJButtonMatrix
{
    NSMutableArray *_selectedButtons;
}

@synthesize selectedButtons = _selectedButtons;

- (id)init {
    self = [super init];
    if (self) {
        _buttonsArray = @[];
        _selectedButtons = [NSMutableArray array];
    }
    return self;
}

#pragma mark  - public methods

@dynamic selectedButton;
- (UIButton *)selectedButton {
    if ( _selectedButtons.count == 0 ) {
        return nil;
    } else {
        return _selectedButtons[0];
    }
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    if ( selectedButton == nil ) {
        if ( self.allowMultipleSelection == NO ) {
            self.selectedButton.selected = NO;
            [self.selectedButton performBlockSelectionForEvent:JJButtonEventDeselect];
        }
        [_selectedButtons removeAllObjects];
    } else {
        [self pressedButton:selectedButton];
    }
}

- (void)setButtonsArray:(NSArray *)buttonsArray
{
    for (UIButton *button in _buttonsArray) {
        [button removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (buttonsArray == nil) {
        _buttonsArray = @[];
        self.selectedButton = nil;
    } else {
        _buttonsArray = [buttonsArray copy];
        NSInteger i = 0;
        for (UIButton *button in _buttonsArray) {
            button.selectionIndex = i;
            i++;
        }
    }
    
    for (UIButton *button in _buttonsArray) {
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.selectedButton = nil;
}

@dynamic selectedIndex;
- (NSInteger)selectedIndex {
    UIButton *selection = self.selectedButton;
    if (selection) {
        return self.selectedButton.selectionIndex;
    }else {
        return NSNotFound;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (selectedIndex == NSNotFound) {
        self.selectedButton = nil;
        return;
    }
    
    if (selectedIndex < 0 || selectedIndex >= _buttonsArray.count) {
        [NSException raise:@"Invalid selected index" format:@"Selection index %ld is invalid", (long)selectedIndex];
        return;
    }
    self.selectedButton = _buttonsArray[selectedIndex];
}

#pragma mark - action

- (void)pressedButton:(UIButton *)sender
{
    if ( self.allowMultipleSelection ) {
        
        BOOL isSelecting = ( sender && sender.selected == NO );
        BOOL allowSelection = YES;
        if ( isSelecting && [self.delegate respondsToSelector:@selector(buttonMatrix:willSelectButton:forIndex:)] ) {
            allowSelection = [self.delegate buttonMatrix:self willSelectButton:sender forIndex:sender.selectionIndex];
        }
        
        if ( !allowSelection ) {
            return;
        }

        sender.selected = isSelecting;
        if ( isSelecting ) {
            [_selectedButtons addObject:sender];
            [sender performBlockSelectionForEvent:JJButtonEventSelect];
            
            if ( [self.delegate respondsToSelector:@selector(buttonMatrix:didSelectButton:forIndex:)] ) {
                [self.delegate buttonMatrix:self didSelectButton:sender forIndex:sender.selectionIndex];
            }
            
        } else {
            [_selectedButtons removeObject:sender];
            [sender performBlockSelectionForEvent:JJButtonEventDeselect];
        }
        
    } else {

        UIButton *previousSelected = self.selectedButton;
        if ( previousSelected == sender ) {
            if ( self.allowEmptySelection || sender == nil) {
                self.selectedButton = nil;
            } else {
                [sender performBlockSelectionForEvent:JJButtonEventReselect];
            }
            return;
        }
        
        BOOL allowSelection = YES;
        if ( [self.delegate respondsToSelector:@selector(buttonMatrix:willSelectButton:forIndex:)] ) {
            allowSelection = [self.delegate buttonMatrix:self willSelectButton:sender forIndex:sender.selectionIndex];
        }
        
        if ( !allowSelection ) {
            return;
        }
        
        previousSelected.selected = NO;
        if (previousSelected) {
            [_selectedButtons replaceObjectAtIndex:0 withObject:sender];
        } else {
            [_selectedButtons addObject:sender];
        }
        sender.selected = YES;
        
        [previousSelected performBlockSelectionForEvent:JJButtonEventDeselect];
        [sender performBlockSelectionForEvent:JJButtonEventSelect];
        
        if ( [self.delegate respondsToSelector:@selector(buttonMatrix:didSelectButton:forIndex:)] ) {
            [self.delegate buttonMatrix:self didSelectButton:sender forIndex:sender.selectionIndex];
        }

    }
    
}

@end
