//
//  HRMReimbursementEmplListViewController.m
//
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMReimbursementEmplListViewController.h"
#import "HRMReimbursementEmplListCell.h"
#import "HRMReimbursementAddViewController.h"
#import "HRMEmpReimbursementDetailsViewController.h"
#import "HRMEmployeeDetailsViewController.h"

@interface HRMReimbursementEmplListViewController ()
{
    NSMutableArray *arrayReimbursement;
}
@end

@implementation HRMReimbursementEmplListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    arrayReimbursement = [NSMutableArray new];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kAddButton];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = REIMBURSEMENT_LIST;
    
    if(IS_IPAD){
        [[HRMHelper sharedInstance] setBackButton:YES];
        [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
    }
    else{
        [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
        [[HRMHelper sharedInstance] setBackButton:NO];
    }
    
    if ([[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] objectAtIndex:[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] count]-2] isKindOfClass:[HRMEmployeeDetailsViewController class]]) {
        [[[HRMManager manager] requestSerializer] setValue:_individualEmployeeId forHTTPHeaderField:@"userId"];
        [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    }
    
    [[HRMAPIHandler handler] getEmployeeReimbursementListWithSuccess:^(NSDictionary *responseDict) {
        [arrayReimbursement addObjectsFromArray:responseDict[@"reimbursementList"]];
        NSLog(@"response List     --->%@", responseDict);
        arrayReimbursement = responseDict[@"reimbursementList"];
        [arrayReimbursement count] == 0 ? [labelNoData setHidden:NO] : [labelNoData setHidden:YES];
        [tblReimbrsementList reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[HRMManager manager] setHeader];
}

#pragma mark - UITableView Delegete & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayReimbursement count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMReimbursementEmplListCell *cell = (HRMReimbursementEmplListCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMReimbursementEmplListCell class])];
    [cell setDatasource:[arrayReimbursement objectAtIndex:indexPath.row]];
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = UIColorRGB(233.0, 233.0, 233.0, 1.0);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMEmpReimbursementDetailsViewController *reimburseVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmpReimbursementDetailsViewController class])];
reimburseVC.arrReimbursementDetails = [arrayReimbursement objectAtIndex:indexPath.row];
[[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:reimburseVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
    return 100;
    else
    return  62;
}
   @end
