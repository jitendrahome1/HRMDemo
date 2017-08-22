//
//  HRMEmpLeaveCell.m
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMEmpLeaveCell.h"

@implementation HRMEmpLeaveCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    if([datasource[@"status"] isEqualToString:@"Cancel"])
        [labelStatus setTextColor:UIColorRGB(217.0, 30.0, 24.0, 1.0)];
    else if ([datasource[@"status"] isEqualToString:@"Pending"])
        [labelStatus setTextColor:[UIColor brownColor]];
    else
        [labelStatus setTextColor:UIColorRGB(46.0, 204.0, 133.0, 1.0)];
    
    
    labelFromDate.text = [NSString stringWithFormat:@"%@", datasource[@"fromDate"]];
    labelToDate.text = [NSString stringWithFormat:@"%@", datasource[@"toDate"]];
    labelLeaveType.text = [NSString stringWithFormat:@"%@", datasource[@"leaveType"]];
    labelStatus.text = [NSString stringWithFormat:@"%@", datasource[@"status"]];
    [labelLeaveType setMarqueeType:MLContinuous];
    [labelLeaveType setLabelize:NO];
    [labelLeaveType restartLabel];
}

-(void)restartLabel
{
}

@end
