//
//  HRMEmpTimeSheetViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"

@interface HRMEmpTimeSheetViewController : HRMBaseViewController
{
    __weak IBOutlet UITableView *tableTmesheetList;
    
    __weak IBOutlet UILabel *labelNoData;
}

@property (nonatomic, strong) NSString *individualEmployeeId;

@end
