//
//  TTSwitchDemoViewController.m
//  SuperDemo
//
//  Created by 谈宇刚 on 15/9/1.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "TTSwitchDemoViewController.h"
#import "TTSwitch.h"
#import "TTFadeSwitch.h"

@interface TTSwitchDemoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;

@end

@implementation TTSwitchDemoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[TTSwitch appearance] setTrackImage:[UIImage imageNamed:@"TTSwithc-round-switch-track"]];
    [[TTSwitch appearance] setOverlayImage:[UIImage imageNamed:@"TTSwithc-round-switch-overlay"]];
    [[TTSwitch appearance] setTrackMaskImage:[UIImage imageNamed:@"TTSwithc-round-switch-mask"]];
    [[TTSwitch appearance] setThumbImage:[UIImage imageNamed:@"TTSwithc-round-switch-thumb"]];
    [[TTSwitch appearance] setThumbHighlightImage:[UIImage imageNamed:@"TTSwithc-round-switch-thumb-highlight"]];
    [[TTSwitch appearance] setThumbMaskImage:[UIImage imageNamed:@"TTSwithc-round-switch-mask"]];
    [[TTSwitch appearance] setThumbInsetX:-3.0f];
    [[TTSwitch appearance] setThumbOffsetY:-3.0f];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TTSwitch *defaultSwitch = [[TTSwitch alloc] initWithFrame:(CGRect){ CGPointZero, { 76.0f, 28.0f } }];
    // Default switch uses the appearance setup in AppDelegate
    
    TTSwitch *squareThumbSwitch = [[TTSwitch alloc] initWithFrame:(CGRect){ CGPointZero, { 76.0f, 27.0f } }];
    squareThumbSwitch.trackImage = [UIImage imageNamed:@"TTSwithc-square-switch-track"];
    squareThumbSwitch.overlayImage = [UIImage imageNamed:@"TTSwithc-square-switch-overlay"];
    squareThumbSwitch.thumbImage = [UIImage imageNamed:@"TTSwithc-square-switch-thumb"];
    squareThumbSwitch.thumbHighlightImage = [UIImage imageNamed:@"TTSwithc-square-switch-thumb-highlight"];
    squareThumbSwitch.trackMaskImage = [UIImage imageNamed:@"TTSwithc-square-switch-mask"];
    squareThumbSwitch.thumbMaskImage = nil; // Set this to nil to override the UIAppearance setting
    squareThumbSwitch.thumbInsetX = -3.0f;
    squareThumbSwitch.thumbOffsetY = -3.0f; // Set this to -3 to compensate for shadow
    
    // Use on/off labels if you need to localize you switch
    TTSwitch *roundLabelSwitch = [[TTSwitch alloc] initWithFrame:(CGRect){ CGPointZero, { 76.0f, 28.0f } }];
    roundLabelSwitch.trackImage = [UIImage imageNamed:@"TTSwithc-round-switch-track-no-text"];
    roundLabelSwitch.labelsEdgeInsets = (UIEdgeInsets){ 3.0f, 10.0f, 3.0f, 10.0f };
    roundLabelSwitch.onString = NSLocalizedString(@"ON", nil);
    roundLabelSwitch.offString = NSLocalizedString(@"OFF", nil);
    roundLabelSwitch.onLabel.textColor = [UIColor greenColor];
    roundLabelSwitch.offLabel.textColor = [UIColor redColor];
    
    // Fade mode
    TTFadeSwitch *fadeLabelSwitch = [[TTFadeSwitch alloc] initWithFrame:(CGRect){ CGPointZero, { 70.0f, 24.0f } }];
    fadeLabelSwitch.thumbImage = [UIImage imageNamed:@"TTSwithc-switchToggle"];
    fadeLabelSwitch.thumbHighlightImage = [UIImage imageNamed:@"TTSwithc-switchToggleHigh"];
    fadeLabelSwitch.trackMaskImage = [UIImage imageNamed:@"TTSwithc-switchMask"];
    fadeLabelSwitch.trackImageOn = [UIImage imageNamed:@"TTSwithc-switchGreen"];
    fadeLabelSwitch.trackImageOff = [UIImage imageNamed:@"TTSwithc-switchRed"];
    
    fadeLabelSwitch.thumbInsetX = -3.0;
    fadeLabelSwitch.thumbOffsetY = 0.0;
    
    // Fade mode with Labels
    TTFadeSwitch *fadeLabelSwitchLabel = [[TTFadeSwitch alloc] initWithFrame:(CGRect){ CGPointZero, { 70.0f, 24.0f } }];
    fadeLabelSwitchLabel.thumbImage = [UIImage imageNamed:@"TTSwithc-switchToggle"];
    fadeLabelSwitchLabel.trackMaskImage = [UIImage imageNamed:@"TTSwithc-switchMask"];
    fadeLabelSwitchLabel.thumbHighlightImage = [UIImage imageNamed:@"TTSwithc-switchToggleHigh"];
    fadeLabelSwitchLabel.trackImageOn = [UIImage imageNamed:@"TTSwithc-switchGreen"];
    fadeLabelSwitchLabel.trackImageOff = [UIImage imageNamed:@"TTSwithc-switchRed"];
    fadeLabelSwitchLabel.onString = @"YEAH";
    fadeLabelSwitchLabel.offString = @"NOPE";
    fadeLabelSwitchLabel.onLabel.font = [UIFont boldSystemFontOfSize:11];
    fadeLabelSwitchLabel.offLabel.font = [UIFont boldSystemFontOfSize:11];
    fadeLabelSwitchLabel.onLabel.textColor = [UIColor whiteColor];
    fadeLabelSwitchLabel.offLabel.textColor = [UIColor whiteColor];
    fadeLabelSwitchLabel.onLabel.shadowColor = [UIColor colorWithRed:0.121569 green:0.600000 blue:0.454902 alpha:1.0];
    fadeLabelSwitchLabel.offLabel.shadowColor = [UIColor colorWithRed:0.796078 green:0.211765 blue:0.156863 alpha:1.0];
    fadeLabelSwitchLabel.onLabel.shadowOffset = CGSizeMake(0, 1.0);
    fadeLabelSwitchLabel.offLabel.shadowOffset = CGSizeMake(0, 1.0);
    fadeLabelSwitchLabel.labelsEdgeInsets = UIEdgeInsetsMake(1.0, 10.0, 1.0, 10.0);
    fadeLabelSwitchLabel.thumbInsetX = -3.0;
    fadeLabelSwitchLabel.thumbOffsetY = 0.0;
    
    self.items = @[
                   [TTControlItem itemWithTitle:@"Round" control:defaultSwitch],
                   [TTControlItem itemWithTitle:@"Square" control:squareThumbSwitch],
                   [TTControlItem itemWithTitle:@"Labels" control:roundLabelSwitch],
                   [TTControlItem itemWithTitle:@"Fade" control:fadeLabelSwitch],
                   [TTControlItem itemWithTitle:@"Fade + Labels" control:fadeLabelSwitchLabel],
                   ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTControlCell *cell = (TTControlCell *)[tableView dequeueReusableCellWithIdentifier:[TTControlCell cellIdentifier]];
    if (nil == cell) {
        cell = [[TTControlCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TTControlCell cellIdentifier]];
    }
    return  cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.items[indexPath.row];
    [((TTControlCell *)cell) setControlItem:item];
}



@end

@implementation TTControlItem

+ (id)itemWithTitle:(NSString *)title control:(UIControl *)control
{
    TTControlItem *item = [[self alloc] init];
    item.title = title;
    item.control = control;
    return item;
}

@end

@implementation TTControlCell

#pragma mark - Init/Dealloc

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
    }
    return self;
}

#pragma mark - Accessors

- (void)setControlItem:(TTControlItem *)controlItem
{
    _controlItem = controlItem;
    
    self.textLabel.text = _controlItem.title;
    self.accessoryView = _controlItem.control;
}

#pragma mark - UITableView Helpers

+ (NSString *)cellIdentifier
{
    return @"tt.switch.control.cellIdentifier";
}

@end
