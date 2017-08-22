//
//  HRMInterviewDetailCell.h
//  HRMS
//
//  Created by Jitendra Agarwal on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"

@interface HRMInterviewDetailCell : HRMBaseCellClass

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblVlaue;

@property (strong, nonatomic) IBOutlet UILabel *lblTimeValue;

@property (strong, nonatomic) IBOutlet UILabel *lblDateValue;
@end
