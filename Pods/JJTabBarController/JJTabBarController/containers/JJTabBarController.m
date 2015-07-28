//
//  JTabBarController.m
//  JJTabBarController
//
//  Created by João Jesus on 05/03/2014.
//  Copyright (c) 2014 João Jesus. All rights reserved.
//

#import "JJTabBarController.h"
#import <objc/runtime.h>
#import "JJTabBarSegue.h"

@interface JJTabBarController () <JJButtonMatrixDelegate>

@property(nonatomic,assign) CGSize tabBarSize;
@property(atomic,assign) BOOL isChangingChildViewControllers;

@end

@implementation JJTabBarController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarSize = CGSizeMake(88, 44);
    }
    return self;
}

- (id)initWithTabBarSize:(CGSize)size {
    return [self initWithTabBarSize:size andDockPosition:JJTabBarDockBottom];
}

- (id)initWithTabBarSize:(CGSize)size andDockPosition:(JJTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        _tabBar = nil;
        _tabBarDock = dockPosition;
        self.tabBarSize = size;
    }
    return self;
}

- (id)initWithTabBar:(JJTabBarView *)tabbar andDockPosition:(JJTabBarDock)dockPosition {
    self = [super init];
    if (self) {
        _tabBar = tabbar;
        _tabBarDock = dockPosition;
        if (_tabBarDock != JJTabBarDockNone) {
            _tabBar.alignment = ( JJTabBarDockIsHorizontal(_tabBarDock) ? JJBarViewAlignmentHorizontal : JJBarViewAlignmentVertical);
            self.tabBarSize = tabbar.frame.size;
        }else {
            _tabBar.alignment = JJBarViewAlignmentNone;
            self.tabBarSize = CGSizeZero;
        }
    }
    return self;
}

#pragma mark - public properties

- (void)setTabBarChilds:(NSArray *)tabBarChilds {
    [self setTabBarChilds:tabBarChilds animation:JJTabBarAnimationNone completion:nil];
}

- (void)setSelectedTabBarChild:(UIViewController *)selectedChildViewController {
    [self setSelectedTabBarChild:selectedChildViewController animation:JJTabBarAnimationNone completion:nil];
}

@dynamic selectedTabBarIndex;
- (NSInteger)selectedTabBarIndex {
    UIViewController *viewController = self.selectedTabBarChild;
    if (viewController == nil) {
        return NSNotFound;
    }
    return [_tabBarChilds indexOfObject:self.selectedTabBarChild];
}

- (void)setSelectedTabBarIndex:(NSInteger)selectedIndex {
    [self setSelectedTabBarIndex:selectedIndex animation:JJTabBarAnimationNone completion:nil];
}

- (void)setTabBar:(JJTabBarView *)associatedTabBar {
    _tabBar = associatedTabBar;
    
    if ( ![self isViewLoaded] ) {
        return;
    }
    
    if ( _tabBar.superview != self.view ) {
        [self.view addSubview:_tabBar];
        [self.view bringSubviewToFront:_tabBar];
    }
    
    _tabBar.frame = [self frameForTabBarWithTabbarHidden:_tabBar.hidden];
    _tabBar.alignment = [self alignmentForTabBar];
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar {
    [self setHiddenTabBar:hiddenTabBar animation:JJTabBarAnimationNone completion:nil];
}

- (void)setTabBarDock:(JJTabBarDock)tabBarDock {
    _tabBarDock = tabBarDock;
    
    if ( [self isViewLoaded] ) {
        [self viewWillLayoutSubviews];
    }
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ( _tabBar == nil ) {
        [self createTabBar];
        [self.view addSubview:_tabBar];
    } else {
        _tabBar.frame = [self frameForTabBarWithTabbarHidden:_tabBar.hidden];
        _tabBar.alignment = [self alignmentForTabBar];
        [self.view addSubview:_tabBar];
    }
    
    if ( _viewContainer == nil ) {
        [self createViewContainer];
    }
    
    if ( _tabBarChilds == nil && _tabBar.matrix.buttonsArray.count > 0 ) {
        // initialize from storyboard
        [self prepareTabBarChildsArray];
        UIButton *selectedButton = _tabBar.matrix.selectedButton;
        if ( selectedButton == nil ) {
            _tabBar.matrix.selectedIndex = 0;
            selectedButton = _tabBar.matrix.selectedButton;
        }
        NSString *segueIdentifier = [NSString stringWithFormat:@"%@%ld", JJTabBarSegueIndex, (long)selectedButton.selectionIndex];
        [self performSegueWithIdentifier:segueIdentifier sender:selectedButton];
        
    } else {
        
        [self createButtonsForViewControllers];
    
        if ( _tabBarChilds.count > 0 ) {
            
            NSUInteger index = 0;
            if (_selectedTabBarChild) {
                index = [_tabBarChilds indexOfObject:_selectedTabBarChild];
            }
            
            _tabBar.selectedIndex = index;
            
            UIViewController *controller = _tabBarChilds[index];
            [self changeToViewController:controller withAnimation:JJTabBarAnimationNone completion:nil];
        }
    }
}

- (void)viewWillLayoutSubviews {
    _tabBar.frame = [self frameForTabBarWithTabbarHidden:_tabBar.hidden];
    _tabBar.alignment = [self alignmentForTabBar];
    _viewContainer.frame = [self frameForContainerWithTabbarHidden:(_tabBar ? _tabBar.hidden : NO)];
    self.selectedTabBarChild.view.frame = _viewContainer.bounds;
}


- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
    // Remove non-active child's views
    for (UIViewController *childController in _tabBarChilds) {
        if ( childController != _selectedTabBarChild ) {
            if ( [childController isViewLoaded] && [self.view window] == nil ) {
                childController.view = nil;
            }
        }
    }
    
    [super didReceiveMemoryWarning];
}

#pragma mark - animation functions

- (void)setSelectedTabBarIndex:(NSInteger)selectedIndex animation:(JJTabBarAnimation)animation completion:(void (^)(void))completion {

    if (selectedIndex >= 0 && selectedIndex < _tabBarChilds.count) {
        UIViewController *viewController = [_tabBarChilds objectAtIndex:selectedIndex];
        if ( viewController == nil ) {
            UIButton *button = self.tabBar.matrix.buttonsArray[selectedIndex];
            NSString *segueIdentifier = [NSString stringWithFormat:@"%@%ld", JJTabBarSegueIndex, (long)button.selectionIndex];
            [self performSegueWithIdentifier:segueIdentifier sender:button];
        }
        
        if ( [self isViewLoaded] ) {
            
            _tabBar.selectedIndex = selectedIndex;
            
            if (viewController != _selectedTabBarChild) {
                [self changeToViewController:viewController withAnimation:animation completion:completion];
            }
            
        } else {
            _selectedTabBarChild = viewController;
        }
    }
}

- (void)setTabBarChilds:(NSArray *)childViewControllers animation:(JJTabBarAnimation)animation completion:(void (^)(void))completion {

    for (UIViewController *child in _tabBarChilds) {
        child.jjTabBarController = nil;
    }
    
    if ( [self isViewLoaded] ) {
        self.selectedTabBarChild = nil;
    }
    
    _tabBarChilds = [childViewControllers mutableCopy];
    
    for (UIViewController *child in _tabBarChilds) {
        child.jjTabBarController = self;
    }
    
    if ( [self isViewLoaded] ) {
        [self createButtonsForViewControllers];
        [self setSelectedTabBarIndex:0 animation:animation completion:completion];
    }
}

- (void)setHiddenTabBar:(BOOL)hiddenTabBar animation:(JJTabBarAnimation)animation completion:(void (^)(void))completion {
    
    _hiddenTabBar = hiddenTabBar;
    CGRect frame = CGRectZero;
    
    if ( [self isViewLoaded] && self.tabBar && animation != JJTabBarAnimationNone ) {
        
        frame = [self frameForContainerWithTabbarHidden:YES];
        self.selectedTabBarChild.view.frame = frame;
        
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        if ( animation == JJTabBarAnimationCrossDissolve ) {
            frame = [self frameForTabBarWithTabbarHidden:NO];
            self.tabBar.frame = frame;
            self.tabBar.alpha = (hiddenTabBar ? 1.0f : 0.0f);

        }else if ( animation == JJTabBarAnimationSlide ) {
            frame = [self frameForTabBarWithTabbarHidden:!_hiddenTabBar];
            self.tabBar.frame = frame;
            self.tabBar.alpha = 1.0f;
        }
        
        self.tabBar.hidden = NO;
        
        [UIView animateWithDuration:0.3f delay:0.0f options:options animations:^{
            
            if ( animation == JJTabBarAnimationSlide ) {
                CGRect frame = [self frameForTabBarWithTabbarHidden:_hiddenTabBar];
                self.tabBar.frame = frame;
            } else if ( animation == JJTabBarAnimationCrossDissolve ) {
                self.tabBar.alpha = (hiddenTabBar ? 0.0f : 1.0f);
            }
            
            _viewContainer.frame = [self frameForContainerWithTabbarHidden:(_tabBar ? _tabBar.hidden : NO)];
            self.selectedTabBarChild.view.frame = _viewContainer.bounds;
            
        } completion:^(BOOL finished) {
            self.tabBar.alpha = 1.0f;
            self.tabBar.hidden = _hiddenTabBar;
            [self viewWillLayoutSubviews];

            if ( completion ) {
                completion();
            }
        }];
    } else {

        self.tabBar.alpha = 1.0f;
        self.tabBar.hidden = _hiddenTabBar;
        [self viewWillLayoutSubviews];
    }
}

- (void)setSelectedTabBarChild:(UIViewController *)selectedChildViewController animation:(JJTabBarAnimation)animation completion:(void (^)(void))completion {

    NSInteger index = [_tabBarChilds indexOfObject:selectedChildViewController];
    if (index == NSNotFound) {
        return;
    }
    
    if ( [self isViewLoaded] ) {
        
        self.tabBar.selectedIndex = index;
        
        if (selectedChildViewController != _selectedTabBarChild) {
            [self changeToViewController:selectedChildViewController withAnimation:animation completion:nil];
        }
        
    } else {
        _selectedTabBarChild = selectedChildViewController;
    }
}

#pragma mark - Perform Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ( [identifier hasPrefix:(NSString *)JJTabBarSegueIndex] ) {
        NSString *stringIndex = [identifier substringFromIndex:[identifier rangeOfString:(NSString *)JJTabBarSegueIndex].length];
        NSInteger parsedIndex = [stringIndex integerValue];
        return (parsedIndex >= 0 && parsedIndex < _tabBar.childViews.count);
    }
    
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue isKindOfClass:[JJTabBarSegue class]] && [sender isKindOfClass:[UIButton class]] ) {

        UIButton *button = (UIButton *)sender;
        UIViewController *vc = segue.destinationViewController;
        vc.jjTabBarController = self;
        vc.jjTabBarButton = button;
        [((NSMutableArray *)_tabBarChilds) replaceObjectAtIndex:button.selectionIndex withObject:segue.destinationViewController];
    }
}

#pragma mark - JButtonMatrixDelegate

- (BOOL)buttonMatrix:(JJButtonMatrix *)buttonMatrix willSelectButton:(UIButton *)button forIndex:(NSInteger)index {
    BOOL shouldSelect = YES;
    if ( [self.delegate respondsToSelector:@selector(tabBarController:willSelectTabBarChild:forIndex:)] ) {
        shouldSelect = [self.delegate tabBarController:self willSelectTabBarChild:_tabBarChilds[index] forIndex:index];
    }
    return shouldSelect;
}

- (void)buttonMatrix:(JJButtonMatrix *)buttonMatrix didSelectButton:(UIButton *)button forIndex:(NSInteger)index {
    UIViewController *viewController = _tabBarChilds[index];
    if (viewController != _selectedTabBarChild) {
        [self changeToViewController:viewController withAnimation:self.defaultSelectedControllerAnimation completion:nil];
    }
    
    if ( [self.delegate respondsToSelector:@selector(tabBarController:didSelectTabBarChild:forIndex:)] ) {
        [self.delegate tabBarController:self didSelectTabBarChild:viewController forIndex:index];
    }
}

#pragma mark - private functions

- (void)prepareTabBarChildsArray {
    NSMutableArray *array = [NSMutableArray array];
    for (UIButton *button in self.tabBar.matrix.buttonsArray) {
        [array addObject:[NSNull null]];
    }
    _tabBarChilds = array;
}

- (void)createTabBar {
    JJTabBarView *tabbar = [[JJTabBarView alloc] initWithFrame:CGRectZero];
    self.tabBar = tabbar;
}

- (void)createViewContainer {
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    container.clipsToBounds = YES;
    _viewContainer = container;
    [self.view addSubview:container];
    [self.view sendSubviewToBack:container];
    
    _viewContainer.frame = [self frameForContainerWithTabbarHidden:_tabBar.hidden];
}

- (CGRect)frameForTabBarWithTabbarHidden:(BOOL)tabbarHidden {
    CGRect viewBounds = [self frameForContainerWithTabbarHidden:tabbarHidden];
    CGRect tabBarFrame = self.tabBar.frame;
    CGPoint offsetHidden = CGPointZero;
    if ( tabbarHidden ) {
        offsetHidden = CGPointMake( -self.tabBarSize.width, -self.tabBarSize.height);
    }
    
    switch (self.tabBarDock) {
        case JJTabBarDockTop:
            tabBarFrame = CGRectMake(0, offsetHidden.y, viewBounds.size.width, self.tabBarSize.height);
            break;
            
        case JJTabBarDockBottom:
            tabBarFrame = CGRectMake(0, viewBounds.size.height, viewBounds.size.width, self.tabBarSize.height);
            break;
            
        case JJTabBarDockLeft:
            tabBarFrame = CGRectMake(offsetHidden.x, 0, self.tabBarSize.width, viewBounds.size.height);
            break;
            
        case JJTabBarDockRight:
            tabBarFrame = CGRectMake(viewBounds.size.width, 0, self.tabBarSize.width, viewBounds.size.height);
            break;
            
        case JJTabBarDockNone:
            break;
    }
    
    return tabBarFrame;
}

- (JJBarViewAlignment)alignmentForTabBar {
    if ( JJTabBarDockIsHorizontal(self.tabBarDock) ) {
        return JJBarViewAlignmentHorizontal;
    } else if ( JJTabBarDockIsVertical(self.tabBarDock) ) {
        return JJBarViewAlignmentVertical;
    } else {
        return JJBarViewAlignmentNone;
    }
}

- (CGRect)frameForContainerWithTabbarHidden:(BOOL)tabbarHidden {
    CGRect viewBounds = self.view.bounds;
    CGSize tabBarSize = self.tabBarSize;
    if ( tabbarHidden ) {
        tabBarSize = CGSizeZero;
    }
    
    CGRect containerFrame = viewBounds;
    
    switch (self.tabBarDock) {
        case JJTabBarDockTop:
            containerFrame = CGRectMake(0, tabBarSize.height, viewBounds.size.width, viewBounds.size.height - tabBarSize.height);
            break;
            
        case JJTabBarDockBottom:
            containerFrame = CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height - tabBarSize.height);
            break;
            
        case JJTabBarDockLeft:
            containerFrame = CGRectMake(tabBarSize.width, 0, viewBounds.size.width - tabBarSize.width, viewBounds.size.height);
            break;
            
        case JJTabBarDockRight:
            containerFrame = CGRectMake(0, 0, viewBounds.size.width - tabBarSize.width, viewBounds.size.height);
            break;
            
        case JJTabBarDockNone:
            break;
    }
    
    return containerFrame;
}

- (void)createButtonsForViewControllers {

    NSMutableArray *tabBarButtons = [NSMutableArray arrayWithCapacity:_tabBarChilds.count];
    NSInteger i = 0;
    BOOL needToAssociateNewButtons = NO;
    self.tabBar.matrix.delegate = self;
    
    for (UIViewController *childViewController in _tabBarChilds) {
        
        UIButton *button = nil;
        
        if ( [self.delegate respondsToSelector:@selector(tabBarController:tabBarButtonForTabBarChild:forIndex:)] ) {
            button = [self.delegate tabBarController:self tabBarButtonForTabBarChild:childViewController forIndex:i];
            needToAssociateNewButtons = YES;
        }
        
        UIButton *customButton = childViewController.jjTabBarButton;
        if ( customButton ) {
            button = customButton;
            needToAssociateNewButtons = YES;
        }
        
        if ( button == nil ) {
            NSArray *buttonsAvaiable = _tabBar.matrix.buttonsArray;
            button = (i < buttonsAvaiable.count ? buttonsAvaiable[i] : nil);
        }
        
        if ( button == nil ) {
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:[NSString stringWithFormat:@"%ld", (long)i] forState:UIControlStateNormal];
            needToAssociateNewButtons = YES;
        }
        
        if ( childViewController.tabBarItem ) {
            [button setTitle:childViewController.tabBarItem.title forState:UIControlStateNormal];
            [button setImage:childViewController.tabBarItem.image forState:UIControlStateNormal];
            if ([childViewController.tabBarItem respondsToSelector:@selector(selectedImage)]) {
                [button setImage:childViewController.tabBarItem.selectedImage forState:UIControlStateSelected];
            }
        }
        
        childViewController.jjTabBarButton = button;
        [tabBarButtons addObject:button];
        i++;
    }
    
    if (needToAssociateNewButtons) {
        
        if (_tabBar) {
            _tabBar.childViews = tabBarButtons;
        }
    }
}

- (void)changeToViewController:(UIViewController *)viewController withAnimation:(JJTabBarAnimation)animation completion:(void (^)(void))completion {
    
    if ( self.isChangingChildViewControllers ) {
        return;
    }
    
    self.isChangingChildViewControllers = YES;
    BOOL allowAnimation = (animation != JJTabBarAnimationNone && _selectedTabBarChild != nil && viewController != nil);
    
    if ( allowAnimation ) {
        
        viewController.view.frame = self.viewContainer.bounds;
        [self addChildViewController:viewController];
        [_selectedTabBarChild willMoveToParentViewController:nil];
        
        UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
        
        if ( animation == JJTabBarAnimationCrossDissolve ) {
            options |= UIViewAnimationOptionTransitionCrossDissolve;
            
        } else if ( animation == JJTabBarAnimationSlide ) {
            
            CGRect initialFrame = self.viewContainer.bounds;
            switch (self.tabBarDock) {
                case JJTabBarDockTop:
                    initialFrame.origin.y -= initialFrame.size.height;
                    break;
                    
                case JJTabBarDockBottom:
                    initialFrame.origin.y += initialFrame.size.height;
                    break;
                    
                case JJTabBarDockLeft:
                    initialFrame.origin.x -= initialFrame.size.width;
                    break;
                    
                case JJTabBarDockRight:
                    initialFrame.origin.x += initialFrame.size.width;
                    break;
                    
                default:
                    break;
            }
            viewController.view.frame = initialFrame;
        }
        
        [self transitionFromViewController:_selectedTabBarChild
                          toViewController:viewController
                                  duration:0.3
                                   options:options
                                animations:^{
                                    if ( animation == JJTabBarAnimationSlide ) {
                                        CGRect finalFrame = self.viewContainer.bounds;
                                        viewController.view.frame = finalFrame;
                                    }
                                }
                                completion:^(BOOL finished){
                                    [_selectedTabBarChild removeFromParentViewController];
                                    [viewController didMoveToParentViewController:self];
                                    _selectedTabBarChild = viewController;
                                    [self viewWillLayoutSubviews];
                                    
                                    if ( completion ) {
                                        completion();
                                    }
                                    
                                     self.isChangingChildViewControllers = NO;
                                }];
        
    } else {
        
        // remove old viewController
        if ( _selectedTabBarChild ) {
            [_selectedTabBarChild willMoveToParentViewController:nil];
            [_selectedTabBarChild.view removeFromSuperview];
            [_selectedTabBarChild removeFromParentViewController];
            _selectedTabBarChild = nil;
        }
        
        viewController.view.frame = self.viewContainer.bounds;
        [self addChildViewController:viewController];
        [self.viewContainer addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        _selectedTabBarChild = viewController;
        [self viewWillLayoutSubviews];
        
        if ( completion ) {
            completion();
        }
        
        self.isChangingChildViewControllers = NO;
    }
}

@end


@implementation UIViewController (JJTabBarController)

static const NSString *KEY_ASSOC_jTabBarButton = @"JTabBarController.jTabBarButton";
static const NSString *KEY_ASSOC_jTabBarController = @"JTabBarController.jTabBarController";

@dynamic jjTabBarButton;
-(UIButton *)jjTabBarButton {
    UIButton *button = (UIButton *)objc_getAssociatedObject(self, &KEY_ASSOC_jTabBarButton);
    return button;
}

-(void)setJjTabBarButton:(UIButton *)jTabBarButton {
    objc_setAssociatedObject(self, &KEY_ASSOC_jTabBarButton, jTabBarButton, OBJC_ASSOCIATION_RETAIN);
}

@dynamic jjTabBarController;
- (JJTabBarController *)jjTabBarController {
    JJTabBarController *controller = (JJTabBarController *)objc_getAssociatedObject(self, &KEY_ASSOC_jTabBarController);
    return controller;
}

-(void)setJjTabBarController:(JJTabBarController *)jTabBarController {
    objc_setAssociatedObject(self, &KEY_ASSOC_jTabBarController, jTabBarController, OBJC_ASSOCIATION_RETAIN);
}

@end
