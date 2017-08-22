//
//  HRMAppraisalDetailsCell.h
//  HRMS
//
//  Created by Jitendra Agarwal on 08/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"

@interface HRMAppraisalDetailsCell : HRMBaseCellClass
{
    
    __weak IBOutlet UILabel *lblBasicPay;


    __weak IBOutlet UILabel *lblPreviousPay;


    __weak IBOutlet UILabel *lblActionName;

    __weak IBOutlet UILabel *lblEffectivDate;
    __weak IBOutlet UILabel *lblActionDate;

    __weak IBOutlet UILabel *lblRemarks;



    __weak IBOutlet UILabel *lblReason;
    
    __weak IBOutlet NSLayoutConstraint *nslblDesConstHight;
    
}

@property (weak, nonatomic) IBOutlet UIView *viewSeparator;

@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end
