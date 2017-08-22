//
//  HRMLeaveListViewController.h
//  HRMS
//
//  Created by Jitendra Agarwal on 01/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"

@interface HRMLeaveListViewController : HRMBaseViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblLeaveList;

@end
