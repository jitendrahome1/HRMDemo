//
//  HRMPaySlipCell.m
//  HRMS
//
//  Created by Jitendra Agarwal on 07/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMPaySlipCell.h"

@implementation HRMPaySlipCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    self.backgroundColor = UIColorRGB(233.0, 233.0, 233.0, 1.0);
    labelAttribute.text =  [NSString stringWithFormat:@"%@: " , datasource[@"key"]];

    labelDesc.text = datasource[@"info"];
}

@end
