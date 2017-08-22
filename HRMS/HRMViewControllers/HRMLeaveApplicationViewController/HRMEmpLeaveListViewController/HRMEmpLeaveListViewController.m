//
//  HRMEmpLeaveListViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMEmpLeaveListViewController.h"
#import "HRMEmpLeaveCell.h"
#import "HRMLeaveApplicationViewController.h"
#import "HRMEmployeeDetailsViewController.h"

@interface HRMEmpLeaveListViewController ()
{
    NSMutableArray *arrayLeaveList;
}
@end

@implementation HRMEmpLeaveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    arrayLeaveList = [NSMutableArray new];
    [tableleaveList reloadData];
    if(IS_IPAD)
        [[HRMHelper sharedInstance] setBackButton:YES];
    
    [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kAddButton];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = LEAVE;
    
    if ([[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] objectAtIndex:[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] count]-2] isKindOfClass:[HRMEmployeeDetailsViewController class]]) {
        [[[HRMManager manager] requestSerializer] setValue:_individualEmployeeId forHTTPHeaderField:@"userId"];
    }
    
    if(self.addButtonStatus == eAddButtonHide)
        [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    else
        [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
    
    [[HRMAPIHandler handler] getEmployeeLeaveListWithSuccess:^(NSDictionary *responseDict) {
        [responseDict[@"leaveList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayLeaveList addObject:obj];
          
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arrayLeaveList indexOfObject:[arrayLeaveList lastObject]] inSection:0];
            [tableleaveList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
         [self showNorecord];
    } failure:^(NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[HRMManager manager] setHeader];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
        return 100;
    else
        return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayLeaveList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMEmpLeaveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMEmpLeaveCell class])];
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = UIColorRGB(233.0, 233.0, 233.0, 1.0);
    
    [cell setDatasource:arrayLeaveList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMLeaveApplicationViewController *detailVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMLeaveApplicationViewController class])];
    detailVC.leaveHandler = leaveDetail;
    detailVC.leaveDetails = [arrayLeaveList objectAtIndex:indexPath.row];
    [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:detailVC animated:YES];
}
-(void)showNorecord
{
    UILabel *  noRecordLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    if(arrayLeaveList.count > 0){
        tableleaveList.scrollEnabled = YES;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.backgroundColor = [UIColor redColor];
        for(id lbl in [tableleaveList subviews])
        {
            if([lbl isKindOfClass:[UILabel class]])
                [lbl removeFromSuperview];
        }
    }
    else{
        tableleaveList.scrollEnabled = NO;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
        noRecordLbl.font =  FONT_REGULAR(IS_IPAD ? 25 : 18);
        noRecordLbl.textColor = [UIColor blackColor];
        [noRecordLbl setBackgroundColor:[UIColor clearColor]];
        [noRecordLbl setText:@"No records found"];
        
        CGRect rect = tableleaveList.frame;
        [noRecordLbl setTextAlignment:NSTextAlignmentCenter];
        [noRecordLbl setFrame:rect];
        [self.view addSubview:noRecordLbl];
    }

}
@end
