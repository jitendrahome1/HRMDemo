//
//  HRMNavDrawer.h
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRMMenuView.h"

@protocol HRMNavigationalDrawerDelegate <NSObject>

@required
- (void)navDrawerMenuSelected:(NSInteger)selectedIndex;

@end

@interface HRMNavDrawer :  UINavigationController<UIGestureRecognizerDelegate,HRMMenuViewDelegate>

@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL isOpen;
@property (weak, nonatomic) id <HRMNavigationalDrawerDelegate> parent;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) HRMMenuView *drawerView;

- (void)toggleDrawer;

@end
