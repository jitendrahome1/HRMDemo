//
//  HRMLeaveDetailsViewController.h
//  HRMS
//
//  Created by Jitendra Agarwal on 01/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h" 
#import "HRMDropDownView.h"

@interface HRMLeaveDetailsViewController : HRMBaseTableViewController
{
    
    __weak IBOutlet UIView *viewButtons;
    __weak IBOutlet UIView *viewCC;
    __weak IBOutlet UIView *viewAO;
    __weak IBOutlet UIView *viewRO;
    __weak IBOutlet UIView *viewAddress;
    __weak IBOutlet UIView *viewReason;
    
    __weak IBOutlet UILabel *fromDate;
    __weak IBOutlet UILabel *toDate;
    __weak IBOutlet UILabel *leaveType;
    __weak IBOutlet UILabel *labelLeaveBalanceType;
    __weak IBOutlet UILabel *leaveBalance;
    __weak IBOutlet UILabel *labelReason;
    __weak IBOutlet UILabel *labelAddress;
    __weak IBOutlet UILabel *labelRO;
    __weak IBOutlet UILabel *labelAO;
    __weak IBOutlet UILabel *labelCC;
    __weak IBOutlet UILabel *labelEmployeename;
    __weak IBOutlet UILabel *labelEmployeeFrom;
}
@property (nonatomic, strong) NSDictionary *leaveDetails;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDetails;
//@property (weak, nonatomic) IBOutlet UIView *viewLeaveDetails;

//@property (weak, nonatomic) IBOutlet UIView *viewLeaveDate;
@property (strong, nonatomic) IBOutlet UITableView *tblLeaveDetails;
//@property (weak, nonatomic) IBOutlet UIView *viewContainer;


@end
