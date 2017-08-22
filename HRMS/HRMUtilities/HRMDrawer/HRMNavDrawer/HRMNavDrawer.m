//
//  HRMNavDrawer.m
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMNavDrawer.h"

#define SHADOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350
#define NAVBAR_HEIGHT 64

@interface HRMNavDrawer ()
{
    CGFloat menuWidth;
    CGFloat menuHeight;
    CGRect inFrame;
    CGRect outFrame;
    UIView *shadowView;
}
@end

@implementation HRMNavDrawer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = [UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1.0];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            }];
    
    [self setUpDrawer];
    
    [[HRMNavigationalHelper sharedInstance] setNavDrawer:self];
    if (BOOL_FOR_KEY(kIsLogin)) {
        [[[HRMNavigationalHelper sharedInstance] navDrawer] setViewControllers:@[[[[HRMNavigationalHelper sharedInstance] mainStoryboard]instantiateViewControllerWithIdentifier:NSStringFromClass([HRMContentBaseViewController class])]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - drawer

- (void)setUpDrawer
{
    self.isOpen = NO;
    
    _drawerView = [[[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance] getNIBNameForOriginalNIBName:NSStringFromClass([HRMMenuView class])] owner:self options:nil] firstObject];
    _drawerView.frame = CGRectMake(0, 0, IS_IPAD ? self.view.frame.size.width * 0.6 : self.view.frame.size.width - 80, self.view.frame.size.height);
    
    
    _drawerView.delegate = self;
    self.drawerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:0.9];
    CGFloat navBarHeight = NAVBAR_HEIGHT;
    menuHeight = CGRectGetHeight(_drawerView.frame);
    menuWidth = CGRectGetWidth(_drawerView.frame);
    outFrame = CGRectMake(-menuWidth, navBarHeight, menuWidth, menuHeight - navBarHeight);
    inFrame = CGRectMake (0, navBarHeight, menuWidth, menuHeight - navBarHeight);
    
    // drawer shawdow and assign its gesture
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    shadowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    shadowView.hidden = YES;
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnShawdow:)]];
    shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:shadowView];
    
    // add drawer view
    [self.drawerView setFrame:outFrame];
    [self.view addSubview:self.drawerView];
    self.drawerView.hidden = YES;
    
    // gesture on self.view
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    
    [self.view bringSubviewToFront:self.navigationBar];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [[HRMHelper sharedInstance] canOpenDrawer];
}

-(void)toggleDrawer
{
    if (!self.isOpen) {
        [self openNavigationDrawer];
    }else{
        [self closeNavigationDrawer];
    }
}

#pragma mark - Opening and Closing Drawer

- (void)openNavigationDrawer{
    
    
    
    [self.view endEditing:YES];
    float duration = MENU_DURATION / menuWidth * fabs(self.drawerView.center.x) + MENU_DURATION / 2; // y=mx+c
    
    // shadow
    shadowView.hidden = NO;
    self.drawerView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         shadowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHADOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
   [self.drawerView.listView setContentOffset:CGPointMake(0, 0) animated:NO];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = inFrame;
                         if (!self.isOpen) {
                             self.drawerView.animating = YES;
                            [self.drawerView.listView reloadData];
                         }
                     }
                     completion:nil];
    
    self.isOpen= YES;
}

- (void)closeNavigationDrawer{
    
    float duration = MENU_DURATION / menuWidth * fabs(self.drawerView.center.x) + MENU_DURATION / 2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         shadowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         shadowView.hidden = YES;
                         self.drawerView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma mark - Gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    [self closeNavigationDrawer];
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
    self.drawerView.hidden = NO;
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
        float movingx = self.drawerView.center.x + translation.x;
        if ( movingx > -menuWidth / 2 && movingx < menuWidth / 2) {
            
            self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHADOW_ALPHA / menuWidth * movingx + SHADOW_ALPHA / 2; // y=mx+c
            shadowView.hidden = NO;
            shadowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        if (self.drawerView.center.x > 0) {
            [self openNavigationDrawer];
        }else if (self.drawerView.center.x < 0) {
            [self closeNavigationDrawer];
        }
    }
}

#pragma mark - PMMenuViewDelegate methods

-(void)listView:(NSArray *)listArray indexPath:(NSIndexPath *)indexPath
{
    [self closeNavigationDrawer];
    if (self.parent && [self.parent respondsToSelector:@selector(navDrawerMenuSelected:)]) {
        [self.parent navDrawerMenuSelected:indexPath.row];
    }
}

@end
