//
//  RTLabelTableViewController.m
//  SuperDemo
//
//  Created by tanyugang on 15/7/24.
//  Copyright (c) 2015年 TYG. All rights reserved.
//

#import "RTLabelTableViewController.h"
#import "RTLabel.h"
#import "RTLabelTableViewCell.h"

@interface RTLabelTableViewController ()<RTLabelDelegate>

@end

@implementation RTLabelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self drawMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMainView{
    
    _dataArray = [NSMutableArray array];
    NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setObject:@"<b>bold</b> and <i>italic</i> style" forKey:@"text"];
    [self.dataArray addObject:row1];
    
    NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
    [row2 setObject:@"<font face='HelveticaNeue-CondensedBold' size=20><u color=blue>underlined</u> <uu color=red>text</uu></font>" forKey:@"text"];
    [self.dataArray addObject:row2];
    
    NSMutableDictionary *row3 = [NSMutableDictionary dictionary];
    [row3 setObject:@"clickable link - <a href='http://store.apple.com'>link to apple store</a> <a href='http://www.google.com'>link to google</a> <a href='http://www.yahoo.com'>link to yahoo</a> <a href='https://github.com/honcheng/RTLabel'>link to RTLabel in GitHub</a> <a href='http://www.wiki.com'>link to wiki.com website</a>" forKey:@"text"];
    [self.dataArray addObject:row3];
    
    NSMutableDictionary *row4 = [NSMutableDictionary dictionary];
    [row4 setObject:@"<font face='HelveticaNeue-CondensedBold' size=20 color='#CCFF00'>Text with</font> <font face=AmericanTypewriter size=16 color=purple>different colours</font> <font face=Futura size=32 color='#dd1100'>and sizes</font>" forKey:@"text"];
    [self.dataArray addObject:row4];
    
    NSMutableDictionary *row5 = [NSMutableDictionary dictionary];
    [row5 setObject:@"<font face='HelveticaNeue-CondensedBold' size=20 stroke=1>Text with strokes</font> " forKey:@"text"];
    [self.dataArray addObject:row5];
    
    NSMutableDictionary *row6 = [NSMutableDictionary dictionary];
    [row6 setObject:@"<font face='HelveticaNeue-CondensedBold' size=20 kern=35>KERN</font> " forKey:@"text"];
    [self.dataArray addObject:row6];
    
    NSMutableDictionary *row7 = [NSMutableDictionary dictionary];
    [row7 setObject:@"<font face='HelveticaNeue-CondensedBold' size=14><p align=justify><font color=red>JUSTIFY</font> Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Ut enim ad minim </p> <p align=left><font color=red>LEFT ALIGNED</font> veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p><br><p align=right><font color=red>RIGHT ALIGNED</font> Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p><br><p align=center><font color=red>CENTER ALIGNED</font> Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum</p></font> " forKey:@"text"];
    [self.dataArray addObject:row7];
    
    NSMutableDictionary *row20 = [NSMutableDictionary dictionary];
    [row20 setObject:@"<p indent=20>Indented bla bla <bi>bla bla bla bla</bi> bla bla bla bla bla bla bla</p>" forKey:@"text"];
    [self.dataArray addObject:row20];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *rowInfo = [self.dataArray objectAtIndex:indexPath.row];
    if ([rowInfo objectForKey:@"cell_height"])
    {
        return [[rowInfo objectForKey:@"cell_height"] floatValue];
    }
    else
    {
        RTLabel *rtLabel = [RTLabelTableViewCell textLabel];
        rtLabel.lineSpacing = 20.0;
        [rtLabel setText:[rowInfo objectForKey:@"text"]];
        CGSize optimumSize = [rtLabel optimumSize];
        [rowInfo setObject:[NSNumber numberWithFloat:optimumSize.height+20] forKey:@"cell_height"];
        return [[rowInfo objectForKey:@"cell_height"] floatValue];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DemoTableViewCell";
    RTLabelTableViewCell *cell = (RTLabelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[RTLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.rtLabel setDelegate:self];
    }
    [cell.rtLabel setText:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"text"]];
    cell.rtLabel.lineSpacing = 20.0;
    return cell;
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"did select url %@", url);
}

@end
