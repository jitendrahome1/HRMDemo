//
//  HRMEmployeeListViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 01/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"

@interface HRMEmployeeListViewController : HRMBaseTableViewController <UISearchBarDelegate>
{
    UISearchBar *searchBarEmployee;
    IBOutlet UITableView *tblEmployeeList;
}

@property (nonatomic, copy) void((^leaveOfficerHandler)(NSString *employeeName, NSString *employeeId));

@end
