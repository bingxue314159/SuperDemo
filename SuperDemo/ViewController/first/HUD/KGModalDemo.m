//
//  KGModalDemo.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/8/20.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "KGModalDemo.h"
#import "KGModal.h"

@interface KGModalDemo ()

@end

@implementation KGModalDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect showButtonRect = CGRectZero;
    showButtonRect.size = CGSizeMake(200, 62);
    showButtonRect.origin.x = round(CGRectGetMidX(self.view.bounds)-CGRectGetMidX(showButtonRect));
    showButtonRect.origin.y = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(showButtonRect)-10;
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showButton.frame = showButtonRect;
    showButton.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [showButton setTitle:@"Show Modal" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    
    [KGModal sharedInstance].closeButtonLocation = KGModalCloseButtonLocationRight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:KGModalWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShow:) name:KGModalDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide:) name:KGModalWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHide:) name:KGModalDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAction:(id)sender{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
    
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"Welcome to KGModal!";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect) + 50;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text = @"KGModal is an easy drop in control that allows you to display any view "
    "in a modal popup. The modal will automatically scale to fit the content view "
    "and center it on screen with nice animations!";
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    CGFloat btnY = CGRectGetMaxY(infoLabelRect)+5;
    CGFloat btnH = CGRectGetMaxY(contentView.frame)-5 - btnY;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(infoLabelRect.origin.x, btnY, infoLabelRect.size.width, btnH);
    [btn setTitle:@"Close Button Right" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeCloseButtonType:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    
    //    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

- (void)willShow:(NSNotification *)notification{
    NSLog(@"will show");
}

- (void)didShow:(NSNotification *)notification{
    NSLog(@"did show");
}

- (void)willHide:(NSNotification *)notification{
    NSLog(@"will hide");
}

- (void)didHide:(NSNotification *)notification{
    NSLog(@"did hide");
}

- (void)changeCloseButtonType:(id)sender{
    UIButton *button = (UIButton *)sender;
    KGModal *modal = [KGModal sharedInstance];
    KGModalCloseButtonLocation type = modal.closeButtonLocation;
    
    if(type == KGModalCloseButtonLocationLeft){
        modal.closeButtonLocation = KGModalCloseButtonLocationRight;
        [button setTitle:@"Close Button Right" forState:UIControlStateNormal];
    }else{
        modal.closeButtonLocation = KGModalCloseButtonLocationLeft;
        [button setTitle:@"Close Button Left" forState:UIControlStateNormal];
    }
}


@end
