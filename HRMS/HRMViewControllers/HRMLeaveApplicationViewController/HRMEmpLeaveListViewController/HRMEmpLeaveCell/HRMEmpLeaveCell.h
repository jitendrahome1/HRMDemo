//
//  HRMEmpLeaveCell.h
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"
#import "MarqueeLabel.h"

@interface HRMEmpLeaveCell : HRMBaseCellClass
{
    __weak IBOutlet MarqueeLabel *labelLeaveType;
    __weak IBOutlet UILabel *labelFromDate;
    __weak IBOutlet UILabel *labelToDate;
    __weak IBOutlet UILabel *labelStatus;
    
}
@end
