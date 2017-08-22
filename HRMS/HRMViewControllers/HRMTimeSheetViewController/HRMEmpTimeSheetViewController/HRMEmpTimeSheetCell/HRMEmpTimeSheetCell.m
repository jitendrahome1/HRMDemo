//
//  HRMEmpTimeSheetCell.m
//  HRMS
//
//  Created by Priyam Dutta on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMEmpTimeSheetCell.h"
#import "HRMCorrectionView.h"
#import "HRMEmployeeDetailsViewController.h"

@implementation HRMEmpTimeSheetCell

-(void)setDatasource:(id)datasource
{
    [super setDatasource:datasource];
    labelDate.text = [NSString stringWithFormat:@"%@", datasource[@"date"]];
    labelProject.text = [NSString stringWithFormat:@"%@", datasource[@"project"]];
    labelTime.text = [NSString stringWithFormat:@"%@", datasource[@"time"]];
}

- (IBAction)actionRequest:(UIButton *)sender {
    if (![[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] objectAtIndex:[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] count]-2] isKindOfClass:[HRMEmployeeDetailsViewController class]]) {
        [[HRMHelper sharedInstance] animateButtonClickedZoom:sender completion:^{
            [HRMCorrectionView showCorrectionViewWithDictionary:self.datasource];
        }];
    }
}


@end
