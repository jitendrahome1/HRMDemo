//
//  HRMInterviewListCell.h
//  HRMS
//
//  Created by Priyam Dutta on 06/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"

@interface HRMInterviewListCell : HRMBaseCellClass

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblYearExp;
@property (weak, nonatomic) IBOutlet UILabel *lblInterviewType;
@property (weak, nonatomic) IBOutlet UILabel *lblDate_time;
@property (weak, nonatomic) IBOutlet UILabel *lblInterviewee;

@end
