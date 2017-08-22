//
//  HRMNotificationCell.m
//  HRMS
//
//  Created by Priyam Dutta on 06/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMNotificationCell.h"

@implementation HRMNotificationCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    [textDesc setEditable:NO];
    labelTitle.text = [NSString stringWithFormat:@"%@", datasource[@"title"]];
    labelDate.text = [NSString stringWithFormat:@"%@", datasource[@"date"]];
    textDesc.text = [datasource[@"description"] isEqualToString:@""] ? @"N.A." : datasource[@"description"];
    textDesc.userInteractionEnabled = NO;
}

@end
