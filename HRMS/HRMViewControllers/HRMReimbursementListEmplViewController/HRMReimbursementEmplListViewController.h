//
//  HRMReimbursementEmplListViewController.h
//  
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMBaseViewController.h"

@interface HRMReimbursementEmplListViewController : HRMBaseViewController
{
    __weak IBOutlet UITableView *tblReimbrsementList;
    __weak IBOutlet UILabel *labelNoData;
}

@property (nonatomic, strong) NSString *individualEmployeeId;

@end
