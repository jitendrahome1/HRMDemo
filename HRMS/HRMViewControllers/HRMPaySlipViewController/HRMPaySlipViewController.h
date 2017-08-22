//
//  HRMPaySlipViewController.h
//  HRMS
//
//  Created by Jitendra Agarwal on 07/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"

@interface HRMPaySlipViewController : HRMBaseViewController
{
    __weak IBOutlet UITableView *tablePayslip;
    __weak IBOutlet UIButton *buttonMonth;
    __weak IBOutlet UIButton *buttonYear;
    __weak IBOutlet UILabel *labelNoPayslip;
    IBOutlet UILabel *labelName;
    IBOutlet UILabel *labelNetPay;
}
@end
