//
//  HRMEmpLeaveListViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"

@interface HRMEmpLeaveListViewController : HRMBaseViewController
{
    __weak IBOutlet UITableView *tableleaveList;
    
}
@property (nonatomic, strong) NSString *individualEmployeeId;

@end
