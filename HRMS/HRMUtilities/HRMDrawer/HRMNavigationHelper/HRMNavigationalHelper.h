//
//  HRMNavigationalHelper.h
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRMContentBaseViewController.h"
#import "HRMHeaderViewController.h"
#import "HRMContentNavigationController.h"
#import "HRMEmployeeListViewController.h"
#import "HRMLeaveListViewController.h"
#import "HRMDashboardViewController.h"
#import "HRMInterviewListViewController.h"
#import "HRMNotificationViewController.h"
#import "HRMPaySlipViewController.h"
#import "HRMTimSheetViewController.h"
#import "HRMEmpLeaveListViewController.h"
#import "HRMReimbursementEmplListViewController.h"
#import "HRMSettingsViewController.h"
#import "HRMEmpTimeSheetViewController.h"
#import "HRMLoginViewController.h"
#import "HRMMyProfileViewController.h"

@interface HRMNavigationalHelper : NSObject

@property (nonatomic, strong) HRMNavDrawer *navDrawer;
@property (nonatomic, assign) HRMContentBaseViewController *baseViewController;
@property (nonatomic, assign) UIViewController *currentViewController;
@property (nonatomic, assign) HRMHeaderViewController *headerViewController;
@property (nonatomic, strong) HRMContentNavigationController *contentNavController;
@property (nonatomic, strong) UIStoryboard *mainStoryboard;

+(instancetype)sharedInstance;
@end
