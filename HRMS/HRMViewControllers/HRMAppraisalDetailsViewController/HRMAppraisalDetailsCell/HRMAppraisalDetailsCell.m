//
//  HRMAppraisalDetailsCell.m
//  HRMS
//
//  Created by Jitendra Agarwal on 08/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMAppraisalDetailsCell.h"

@implementation HRMAppraisalDetailsCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    lblBasicPay.text =[NSString stringWithFormat:@"$%@", [datasource[@"basicPay"] isEqualToString:@""] ? @"N.A." :  datasource[@"basicPay"]];
    lblPreviousPay.text =[NSString stringWithFormat:@"$%@", [datasource[@"previousPay"] isEqualToString:@""] ? @"N.A." :  datasource[@"previousPay"]];
     lblActionName.text =[NSString stringWithFormat:@"%@", [datasource[@"actionName"] isEqualToString:@""] ? @"N.A." :  datasource[@"actionName"]];
      lblReason.text =[NSString stringWithFormat:@"%@", [datasource[@"Reason"] isEqualToString:@""] ? @"N.A." :  datasource[@"Reason"]];
   
    lblEffectivDate.text = [self stringTodate:datasource[@"effectedDate"]];
    lblActionDate.text = [self stringTodate:datasource[@"actionDate"]];


    
    _lblDesc.text = [NSString stringWithFormat:@"%@", [datasource[@"Remark"] isEqualToString:@""] ? @"N.A." :  datasource[@"Remark"]];

    
  

    
}
-(NSString *)stringTodate:(NSString *)pDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyy";
    NSDate *yourDate = [dateFormatter dateFromString:pDate];
    dateFormatter.dateFormat = @"MMMM-dd-yyyy";
  return [dateFormatter stringFromDate:yourDate];
}
@end
