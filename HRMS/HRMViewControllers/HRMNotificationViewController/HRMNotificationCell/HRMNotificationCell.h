//
//  HRMNotificationCell.h
//  HRMS
//
//  Created by Priyam Dutta on 06/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"

@interface HRMNotificationCell : HRMBaseCellClass
{
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UILabel *labelDate;
    __weak IBOutlet UITextView *textDesc;
}
@end
