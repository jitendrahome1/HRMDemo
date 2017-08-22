//
//  HRMLeaveListTableViewCell.h
//  HRMS
//
//  Created by Jitendra Agarwal on 01/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"

@interface HRMLeaveListTableViewCell : HRMBaseCellClass

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblEmpName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmpId;
@property (weak, nonatomic) IBOutlet UILabel *lblEmpDepartment;
@property (strong, nonatomic) IBOutlet UIView *viewApplyOnBg;
@property (strong, nonatomic) IBOutlet UILabel *lblApplyOn;
@property (weak, nonatomic) IBOutlet UIImageView *imageBar;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;

@end
