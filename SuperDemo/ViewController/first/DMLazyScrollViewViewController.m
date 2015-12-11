//
//  DMViewController.m
//  DMLazyScrollViewExample
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//

#import "DMLazyScrollViewViewController.h"
#import "DMLazyScrollView.h"
#import "CommonHeader.h"

#define ARC4RANDOM_MAX	0x100000000


@interface DMLazyScrollViewViewController () <DMLazyScrollViewDelegate> {
    DMLazyScrollView* lazyScrollView;
    NSMutableArray*    viewControllerArray;
}
@end

@implementation DMLazyScrollViewViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // PREPARE PAGES
    NSUInteger numberOfPages = 10;
    viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        [viewControllerArray addObject:[NSNull null]];
    }
    
    UIView *conView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavBarHeight - 50)];
    conView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:conView];
    // PREPARE LAZY VIEW
    lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:conView.bounds];
    [lazyScrollView setEnableCircularScroll:YES];
    [lazyScrollView setAutoPlay:YES];
    
    __weak __typeof(&*self)weakSelf = self;
    lazyScrollView.dataSource = ^(NSUInteger index) {
        return [weakSelf controllerAtIndex:index];
    };
    lazyScrollView.numberOfPages = numberOfPages;
   // lazyScrollView.controlDelegate = self;
    [conView addSubview:lazyScrollView];
    
    // MOVE BY 3 FORWARD
    UIButton*btn_moveForward = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_moveForward setTitle:@"MOVE BY 3" forState:UIControlStateNormal];
    [btn_moveForward addTarget:self action:@selector(btn_moveForward:) forControlEvents:UIControlEventTouchUpInside];
    [btn_moveForward setFrame:CGRectMake(SCREEN_WIDTH/2.0f,CGRectGetMaxY(conView.frame)+5, SCREEN_WIDTH/2.0f,40)];
    [self.view addSubview:btn_moveForward];
    
    // MOVE BY -3 BACKWARD
    UIButton*btn_moveBackward = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_moveBackward setTitle:@"MOVE BY -3" forState:UIControlStateNormal];
    [btn_moveBackward addTarget:self action:@selector(btn_moveBack:) forControlEvents:UIControlEventTouchUpInside];
    [btn_moveBackward setFrame:CGRectMake(0,CGRectGetMaxY(conView.frame)+5, SCREEN_WIDTH/2.0f,40)];
    [self.view addSubview:btn_moveBackward];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) btn_moveBack:(id) sender {
    [lazyScrollView moveByPages:-3 animated:YES];
}

- (void) btn_moveForward:(id) sender {
    [lazyScrollView moveByPages:3 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (UIViewController *) controllerAtIndex:(NSInteger) index {
    if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null]) {
        UIViewController *contr = [[UIViewController alloc] init];
        contr.view.backgroundColor = [UIColor colorWithRed: (CGFloat)arc4random()/ARC4RANDOM_MAX
                                                      green: (CGFloat)arc4random()/ARC4RANDOM_MAX
                                                       blue: (CGFloat)arc4random()/ARC4RANDOM_MAX
                                                     alpha: 1.0f];
        
        UILabel* label = [[UILabel alloc] initWithFrame:contr.view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%ld",(long)index];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:50];
        [contr.view addSubview:label];
        
        [viewControllerArray replaceObjectAtIndex:index withObject:contr];
        return contr;
    }
    return res;
}

/*
- (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView {
    NSLog(@"Now visible: %@",lazyScrollView.visibleViewController);
}
*/
@end
