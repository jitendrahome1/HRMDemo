//
//  HRMLeaveListTableViewCell.m
//  HRMS
//
//  Created by Jitendra Agarwal on 01/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMLeaveListTableViewCell.h"

@implementation HRMLeaveListTableViewCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2;
    self.imgProfile.layer.borderWidth = 2.0f;
    self.imgProfile.layer.borderColor = [UIColor clearColor].CGColor;
    self.imgProfile.layer.borderColor = [UIColor colorWithRed:138.0/255.0 green:206.0/255.0 blue:245.0/255.0 alpha:1.0f].CGColor;
    self.imgProfile.clipsToBounds = YES;
    
    self.imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    if ([HRMHelper sharedInstance].menuType == leaveApplication)
    {
        _lblEmpName.text = [NSString stringWithFormat:@"%@", datasource[@"name"]];
        _lblEmpId.text  = [NSString stringWithFormat:@"%@", datasource[@"employeeID"]];
        _lblEmpDepartment.text = [datasource[@"department"] isEqualToString:@""] ? @"N.A." :[ NSString stringWithFormat:@"(%@)", datasource[@"department"]];
        [_imgProfile sd_setImageWithURL:[NSURL URLWithString:datasource[@"image"]]
                       placeholderImage:[UIImage imageNamed:@"BigGrayImage"]];
        _imageBar.image = [UIImage imageNamed:@"GreenBar"];
        [_labelAmount setText:[NSString stringWithFormat:@"Apply on %@", datasource[@"leaveAppliedDate"]]];
    }
    else if ([HRMHelper sharedInstance].menuType == reimbursement)
    {
        _lblEmpName.text = [NSString stringWithFormat:@"%@", datasource[@"name"]];
        _lblEmpId.text = [NSString stringWithFormat:@"%@", datasource[@"employeeID"]];
        _lblEmpDepartment.text = [datasource[@"department"] isEqualToString:@""] ? @"N.A." :[ NSString stringWithFormat:@"(%@)", datasource[@"department"]];
        _lblApplyOn.text = [NSString stringWithFormat:@"%@", datasource[@"reimbAppliedDate"]];
        [_imgProfile sd_setImageWithURL:[NSURL URLWithString:datasource[@"image"]]
                       placeholderImage:[UIImage imageNamed:@"BigGrayImage"]];
        _imageBar.image = [UIImage imageNamed:@"BlueBar"];
        [_labelAmount setText:[NSString stringWithFormat:@"Amount $%@", datasource[@"reimbAmount"]]];
    }
}

@end
