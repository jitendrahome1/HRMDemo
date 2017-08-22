//
//  HRMMyProfileViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMMyProfileViewController.h"
#import "HRMMyProfileCell.h"

@interface HRMMyProfileViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSArray * arrTitle;
}

@end

@implementation HRMMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTitle = [[NSArray alloc]initWithObjects:@"My Leave",@"My Reimbursement",@"My Timesheet",@"My Payslip", nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = MY_PROFILE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-
#pragma mark Table View Delete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMMyProfileCell*cell = (HRMMyProfileCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMMyProfileCell class])];
    cell.lblTitleName.text = [arrTitle objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self accessPermitWithIndex:indexPath.row]) {
        [HRMToast showWithMessage:NOT_ALLOWED];
        return;
    }
    
    switch(indexPath.row)
    {
        case 0:
        {
            HRMEmpLeaveListViewController *leaveViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HRMEmpLeaveListViewController"];
            [self.navigationController pushViewController:leaveViewController animated:YES];
            [HRMHelper sharedInstance].menuType = leaveApplication;
        }
            break;
            
        case 1:
        {
            HRMReimbursementEmplListViewController *reimbursementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HRMReimbursementEmplListViewController"];
            [self.navigationController pushViewController:reimbursementViewController animated:YES];
            [HRMHelper sharedInstance].menuType = reimbursement;
        }
            break;
        case 2:
        {
            HRMEmpTimeSheetViewController *empTimeSheetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HRMEmpTimeSheetViewController"];
            [self.navigationController pushViewController:empTimeSheetViewController animated:YES];
            [HRMHelper sharedInstance].menuType = timeSheet;
        }
            break;
        case 3:
        {
            // Verified  PaySlipPin
//            [UIAlertView showWithTextFieldAndTitle:ALERT_TITLE_PAYSLIP message:APPRAISAL_PIN cancelButtonTitle:nil otherButtonTitles:@[CANCEL_BUTTON,OK_BUTTON] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                switch (buttonIndex) {
//                    case 1:
//                    {
//                        NSString *strPin = [alertView textFieldAtIndex:0].text;
//                        
//                        if([strPin validateWithString:APPRAISAL_PIN])
//                        {
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [[HRMAPIHandler handler]paySlipPinVerifiedWithPin:strPin WithSuccess:^(NSDictionary *responseDict) {
//                                    HRMPaySlipViewController *paySlipViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HRMPaySlipViewController"];
//                                    [self.navigationController pushViewController:paySlipViewController animated:YES];
//                                    [HRMHelper sharedInstance].menuType = payslip;
//                                } failure:^(NSError *error) {
//                                    
//                                }];
//                            });
//                        }
//                    }
//                        break;
//                        
//                    default:
//                        break;
//                }
//                
//            }];
            
        }
            break;
        default:
            break;
    }
}

-(BOOL)accessPermitWithIndex:(NSInteger)index
{
    if (index == 0 && [OBJ_FOR_KEY(kAssignPermit)[@"leave"] boolValue])
        return YES;
    else if (index == 1 && [OBJ_FOR_KEY(kAssignPermit)[@"reimbursement"] boolValue])
        return YES;
    else if (index == 2 && [OBJ_FOR_KEY(kAssignPermit)[@"timesheet"] boolValue])
        return YES;
    else if (index == 3 && [OBJ_FOR_KEY(kAssignPermit)[@"payslip"] boolValue])
        return YES;
    
    return NO;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField.text length]==6 && [string length]>0)
    {
        NSLog(@"cant enter more than 10 character");
        return NO;
    }
    else
        
        
        return YES;
}

-(void)showPinAlertWithText:(NSString *)title messageText:(NSString *)messageText
{
    
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"New Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.tag = 1234;
    //add this...
    [[alert textFieldAtIndex:0] setDelegate:(id)self];
    [[alert textFieldAtIndex:0] setPlaceholder:@"New Password"];
    [[alert textFieldAtIndex:0] setSecureTextEntry:YES];
    
    [alert show];
    
}

@end
