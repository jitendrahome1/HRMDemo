//
//  HRMEmployeeListCell.h
//  HRMS
//
//  Created by Priyam Dutta on 01/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseCellClass.h"

@interface HRMEmployeeListCell : HRMBaseCellClass
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployeeId;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployeeDesig;
@property (strong, nonatomic) IBOutlet UIView *viewSeparator;
@property (weak, nonatomic) IBOutlet UILabel *lblDeparment;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelAORO;
@property (strong, nonatomic) IBOutlet UILabel *labelBasicPay;
@property (strong, nonatomic) IBOutlet UIView *viewBasicPay;
@property (weak, nonatomic) IBOutlet UILabel *lblDeptTitle;

@end
