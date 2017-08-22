//
//  HRMMenuItemViewCell.m
//  HRMS
//
//  Created by Priyam Dutta on 03/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMMenuItemViewCell.h"

@implementation HRMMenuItemViewCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    [_labelTitle setText:datasource[@"name"]];
    [_imageLogo setImage:[UIImage imageNamed:datasource[@"image"]]];
}

@end
