//
//  HRMEmpTimeSheetCell.h
//  HRMS
//
//  Created by Priyam Dutta on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"

@interface HRMEmpTimeSheetCell : HRMBaseCellClass
{
    __weak IBOutlet UILabel *labelDate;
    __weak IBOutlet UILabel *labelProject;
    __weak IBOutlet UILabel *labelTime;
    
}
@end
