//
//  HRMEmployeeListCell.m
//  HRMS
//
//  Created by Priyam Dutta on 01/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMEmployeeListCell.h"

@implementation HRMEmployeeListCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    
    if ([HRMHelper sharedInstance].menuType == appraisal)
    {
        NSString *profileImageURl = [NSString stringWithFormat:@"%@", datasource[@"image"]];
        
        [_imgProfile sd_setImageWithURL:[NSURL URLWithString:profileImageURl]
                       placeholderImage:[UIImage imageNamed:@"BigGrayImage"]];
        _imgProfile.layer.cornerRadius = _imgProfile.frame.size.width/2;
        _imgProfile.layer.masksToBounds = YES;
        _lblName.text = [NSString stringWithFormat:@"%@", datasource[@"name"]];

        
        _lblDeptTitle.text = [NSString stringWithFormat:@"%@", datasource[@"department"]];
           _lblDeparment.text =[NSString stringWithFormat:@"%@", [datasource[@"designation"] isEqualToString:@""] ? @"N.A." :  datasource[@"designation"]];
        _lblEmployeeDesig.text = [NSString stringWithFormat:@"%@", [datasource[@"employeeID"] isEqualToString:@""] ? @"N.A." :  datasource[@"employeeID"]];
        if([datasource[@"basicPay"]length] == 0)
        _labelBasicPay.text = @"N.A.";
        else
            _labelBasicPay.text = [NSString stringWithFormat:@"Basic Pay:$%@", datasource[@"basicPay"]];
        }
    else
    {
    _lblName.text = [NSString stringWithFormat:@"%@", datasource[@"fullName"]];

  
_lblDeparment.text =[NSString stringWithFormat:@"(%@)", [datasource[@"departmentName"] isEqualToString:@""] ? @"N.A." :  datasource[@"departmentName"]];
    _lblEmployeeDesig.text = [NSString stringWithFormat:@"(%@)", [datasource[@"employeeId"] isEqualToString:@""] ? @"N.A." :  datasource[@"employeeId"]];
    
    NSString *profileImageURl = [NSString stringWithFormat:@"%@", datasource[@"profileImage"]];
    
    [_imgProfile sd_setImageWithURL:[NSURL URLWithString:profileImageURl]
                   placeholderImage:[UIImage imageNamed:@"BigGrayImage"]];
    _imgProfile.layer.cornerRadius = _imgProfile.frame.size.width/2;
    _imgProfile.layer.masksToBounds = YES;
    _labelAORO.text = [NSString stringWithFormat:@"%@", datasource[@"fullName"]];
    }
}

@end
