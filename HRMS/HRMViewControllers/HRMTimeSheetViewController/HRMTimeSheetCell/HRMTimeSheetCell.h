//
//  HRMTimeSheetCell.h
//  
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMBaseCellClass.h"

@interface HRMTimeSheetCell : HRMBaseCellClass
{
  
    __weak IBOutlet UILabel *labelDate;
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelDepartment;
    
}
@end
