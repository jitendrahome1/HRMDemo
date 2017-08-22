//
//  HRMInterviewDetailViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMInterviewDetailViewController.h"
#import "HRMInterviewDetailCell.h"
@interface HRMInterviewDetailViewController ()
{
    NSArray *arrTileForSection1;
    NSArray *arrTileForSection2;
}
@end

@implementation HRMInterviewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"interView Detils %@",_interviewDetails);
    arrTileForSection1 = @[@{@"Date": _interviewDetails[@"interviewDate"], @"Time": _interviewDetails[@"interviewTime"]}];

    arrTileForSection2 = @[@{@"Candidate Name:": _interviewDetails[@"candidateName"], @"Candidate Email:": _interviewDetails[@"candidateEmail"],@"Candidate Mobile Number:": [NSString stringWithFormat:@"%@", [_interviewDetails[@"candidatePhone"] isEqualToString:@""] ? @"N.A." :  _interviewDetails[@"candidatePhone"]],@"Interview Type:": _interviewDetails[@"interviewType"],@"Department:":[NSString stringWithFormat:@"%@", [_interviewDetails[@"department"] isEqualToString:@""] ? @"N.A." :  _interviewDetails[@"department"]],@"Position Apply For:": _interviewDetails[@"position"],@"Experience:": _interviewDetails[@"candidateExp"],@"Current Package:": [NSString stringWithFormat:@"%@", [_interviewDetails[@"currentPackage"] isEqualToString:@""] ? @"N.A." :  _interviewDetails[@"currentPackage"]],@"Current Employer Name:": [NSString stringWithFormat:@"%@", [_interviewDetails[@"currentEmployerName"] isEqualToString:@""] ? @"N.A." :  _interviewDetails[@"currentEmployerName"]],@"Notice Period:": [NSString stringWithFormat:@"%@", [_interviewDetails[@"noticePeriod"] isEqualToString:@""] ? @"N.A." :  _interviewDetails[@"noticePeriod"]],@"Interviewer Name:": [NSString stringWithFormat:@"%@", [_interviewDetails[@"interviewerName"] isEqualToString:@""] ? @"N.A." :  _interviewDetails[@"interviewerName"]],@"Status:": [NSString stringWithFormat:@"%@", [_interviewDetails[@"status"] isEqualToString:@""] ? @"N.A." :  _interviewDetails[@"status"]]}
                           ];
    [[HRMHelper sharedInstance] setDataDictionary:_interviewDetails];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[HRMHelper sharedInstance] setBackButton:YES];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = INTERVIEW_DETAIL;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kEditButton];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if(section == 0)
          return 1;
    else if(section == 1) {
        return 1;
    }
    else if(section == 2) {
        return [[[arrTileForSection2 objectAtIndex:0] allKeys]count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 25;
    else
        return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
          cell.backgroundColor = [UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f];
        return cell;
    }
    if(indexPath.section == 1)
    {
    HRMInterviewDetailCell*cell = (HRMInterviewDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"HRMInterviewDetailCell1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [arrTileForSection1 objectAtIndex:indexPath.row];
        cell.lblDateValue.text = [dict valueForKey:@"Date"];
        cell.lblTimeValue.text = [dict valueForKey:@"Time"];
          cell.backgroundColor = [UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f];
        return cell;
    }
    else if(indexPath.section == 2)
    {
        HRMInterviewDetailCell*cell = (HRMInterviewDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"HRMInterviewDetailCell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = [arrTileForSection2 objectAtIndex:0];
        cell.lblTitle.text = [[dict allKeys] objectAtIndex:indexPath.row];
        cell.lblVlaue.text = [[dict allValues] objectAtIndex:indexPath.row];
          cell.backgroundColor = [UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f];
        return cell;
    }
    
    return nil;

}

@end
