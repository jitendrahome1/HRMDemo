//
//  HRMTimeSheetCell.m
//  
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMTimeSheetCell.h"

@implementation HRMTimeSheetCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    
    labelDate.text                =    [NSString stringWithFormat:@"%@", datasource[@"date"]];
    labelName.text               =     [NSString stringWithFormat:@"%@", datasource[@"name"]];
    labelDepartment.text      =  [NSString stringWithFormat:@"%@", datasource[@"department"]];
    
}

@end
