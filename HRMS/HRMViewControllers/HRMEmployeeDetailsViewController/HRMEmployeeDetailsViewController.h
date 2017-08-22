//
//  HRMEmployeeDetailsViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 03/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "HRMEmployeeHeaderView.h"
#import "VCFloatingActionButton.h"
#import "HRMAppraisalDetailsViewController.h"
@interface HRMEmployeeDetailsViewController : HRMBaseTableViewController
{
    HRMEmployeeHeaderView *headerView;
}
@property (strong, nonatomic) VCFloatingActionButton *addButton;
@property (strong, nonatomic) NSDictionary *employeeDetails;
@end
