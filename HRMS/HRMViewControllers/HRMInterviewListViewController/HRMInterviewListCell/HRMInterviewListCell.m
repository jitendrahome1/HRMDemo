//
//  HRMInterviewListCell.m
//  HRMS
//
//  Created by Priyam Dutta on 06/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMInterviewListCell.h"

@implementation HRMInterviewListCell

-(void)setDatasource:(id)datasource
{ 
    [super setDatasource:datasource];
    _lblName.text = [NSString stringWithFormat:@"%@", datasource[@"candidateName"]];
    _lblYearExp.text = [NSString stringWithFormat:@"(%@)", datasource[@"candidateExp"]];
    _lblDate_time.text = [NSString stringWithFormat:@"On %@ at %@", datasource[@"interviewDate"], datasource[@"interviewTime"]];
    _lblInterviewee.text = [NSString stringWithFormat:@"%@", datasource[@"interviewerName"]];
    _lblInterviewType.text = [NSString stringWithFormat:@"Interview for %@", datasource[@"position"]];
}

@end
