//
//  HRMAppraisalDetailsViewController.h
//  HRMS
//
//  Created by Jitendra Agarwal on 05/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"

@interface HRMAppraisalDetailsViewController : HRMBaseViewController
{
    IBOutlet UITableView *tableSalProgress;
    IBOutlet UIImageView *imageProf;
    IBOutlet UILabel *name;
    IBOutlet UILabel *employeeID;
    IBOutlet UIButton *buttonAddIncreament;
}
@property (nonatomic, strong) NSString *employeeIncreamentID;
@property (nonatomic, strong) NSMutableArray *arrAppraisalDetails;
@property (strong, nonatomic) NSDictionary *dictEmployeeDetails;


@end

