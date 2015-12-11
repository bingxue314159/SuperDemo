//
//  QBPopupMenuDemo.m
//  SuperDemo
//
//  Created by tanyugang on 15/6/5.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "QBPopupMenuDemo.h"

#import "QBPopupMenu.h"
#import "QBPlasticPopupMenu.h"

@interface QBPopupMenuDemo ()

@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) QBPlasticPopupMenu *plasticPopupMenu;


@end

@implementation QBPopupMenuDemo


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"Hello" target:self action:@selector(action)];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Cut" target:self action:@selector(action)];
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"Copy" target:self action:@selector(action)];
    QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithTitle:@"Delete" target:self action:@selector(action)];
    QBPopupMenuItem *item5 = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"clip"] target:self action:@selector(action)];
    QBPopupMenuItem *item6 = [QBPopupMenuItem itemWithTitle:@"Delete" image:[UIImage imageNamed:@"trash"] target:self action:@selector(action)];
    NSArray *items = @[item, item2, item3, item4, item5, item6];
    
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
    popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    self.popupMenu = popupMenu;
    
    QBPlasticPopupMenu *plasticPopupMenu = [[QBPlasticPopupMenu alloc] initWithItems:items];
    plasticPopupMenu.height = 40;
    self.plasticPopupMenu = plasticPopupMenu;
}


- (IBAction)showPopupMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.popupMenu showInView:self.view targetRect:button.frame animated:YES];
}

- (IBAction)showPlasticPopupMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.plasticPopupMenu showInView:self.view targetRect:button.frame animated:YES];
}

- (void)action
{
    NSLog(@"*** action");
}


@end
