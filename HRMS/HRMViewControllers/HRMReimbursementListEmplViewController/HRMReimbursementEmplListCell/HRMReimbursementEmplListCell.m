//
//  HRMReimbursementEmplListCell.m
//  
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMReimbursementEmplListCell.h"

@implementation HRMReimbursementEmplListCell
-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    _lblDate.text =      [NSString stringWithFormat:@"%@", [datasource[@"applyDate"] isEqualToString:@""] ? @"N.A." :  datasource[@"applyDate"]];
    _lblAmount.text =     [NSString stringWithFormat:@"%@", [datasource[@"amount"] isEqualToString:@""] ? @"N.A." :  datasource[@"amount"]];
     _lblStatus.text =      [NSString stringWithFormat:@"%@", [datasource[@"status"] isEqualToString:@""] ? @"N.A." :  datasource[@"status"]];
    if([datasource[@"status"] isEqualToString:@"Cancelled"])
        [_lblStatus setTextColor:UIColorRGB(217.0, 30.0, 24.0, 1.0)];
    else if ([datasource[@"status"] isEqualToString:@"Pending"])
        [_lblStatus setTextColor:[UIColor brownColor]];
    else
        [_lblStatus setTextColor:UIColorRGB(46.0, 204.0, 133.0, 1.0)];
    
}
@end
