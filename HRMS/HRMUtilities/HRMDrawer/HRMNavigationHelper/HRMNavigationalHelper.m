//
//  HRMNavigationalHelper.m
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMNavigationalHelper.h"

@interface HRMNavigationalHelper () <HRMNavigationalDrawerDelegate>
{
    UIStoryboard *profileStoryboard;
}
@end

@implementation HRMNavigationalHelper
@synthesize currentViewController, mainStoryboard;

static HRMNavigationalHelper *helper = nil;

+(instancetype)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        helper = [[HRMNavigationalHelper alloc] init];
    });
    return helper;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _navDrawer.parent = self;
        mainStoryboard = [UIStoryboard storyboardWithName:[[HRMHelper sharedInstance] getStoryboardNameForOriginalName:@"Main"] bundle:nil];
    }
    return self;
}

-(void)setNavDrawer:(HRMNavDrawer *)navDrawer
{
    _navDrawer = navDrawer;
    _navDrawer.parent = self;
}

#pragma mark - Provide Access Permit

-(BOOL)accessPermitForIndex:(NSInteger)index
{
    if (IS_IPAD) {
        if (index == 2 && [OBJ_FOR_KEY(kModulePermit)[@"timesheet"] boolValue])
            return YES;
        else if (index == 3 && [OBJ_FOR_KEY(kModulePermit)[@"timesheetCorrection"] boolValue])
            return  YES;
        else if (index == 4 && [OBJ_FOR_KEY(kModulePermit)[@"leave"] boolValue])
            return YES;
        else if (index == 6 && [OBJ_FOR_KEY(kModulePermit)[@"reimbursement"] boolValue])
            return YES;
        else if (index == 7 && [OBJ_FOR_KEY(kModulePermit)[@"appraisal"] boolValue])
            return YES;
        else if (index == 0 || index == 1 || index == 8 || index == 9 || index == 10 || index == 11 || index == 5)
            return YES;
    }else{
        if (index == 1 && [OBJ_FOR_KEY(kAssignPermit)[@"timesheet"] boolValue])
            return YES;
        else if (index == 2 && [OBJ_FOR_KEY(kAssignPermit)[@"leave"] boolValue])
            return YES;
        else if (index == 3 && [OBJ_FOR_KEY(kAssignPermit)[@"reimbursement"] boolValue])
            return YES;
        else if (index == 4 && [OBJ_FOR_KEY(kAssignPermit)[@"payslip"] boolValue])
            return YES;
        else if (index == 0 || index == 5 || index == 6 || index == 7)
            return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - PMNavigationDrawerDelegate

-(void)navDrawerMenuSelected:(NSInteger)selectedIndex
{
    NSString *selectedItem;
    selectedItem = [self getSection:selectedIndex][@"name"];
    
    if (![self accessPermitForIndex:selectedIndex]) {
        [HRMToast showWithMessage:NOT_ALLOWED];
        return;
    }
    
    if ([selectedItem isEqualToString:@"Home"]) // Goto Home
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMDashboardViewController class]] && [HRMHelper sharedInstance].menuType == home)
        {
            if([HRMHelper sharedInstance].menuType != home)
                [HRMHelper sharedInstance].menuType = home;
        }
        else
        {
            [[HRMNavigationalHelper sharedInstance].contentNavController popToRootViewControllerAnimated:YES];
            if([HRMHelper sharedInstance].menuType != home)
                [HRMHelper sharedInstance].menuType = home;
        }
    }
    else if ([selectedItem isEqualToString:@"Employee"]) // Goto Employee List
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMEmployeeListViewController class]] && [HRMHelper sharedInstance].menuType == employee)
        {
            if([HRMHelper sharedInstance].menuType != employee)
                [HRMHelper sharedInstance].menuType = employee;
        }
        else
        {
            HRMEmployeeListViewController *employeeVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmployeeListViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:employeeVC animated:YES];
            if([HRMHelper sharedInstance].menuType != employee)
                [HRMHelper sharedInstance].menuType = employee;
        }
    }
    else if ([selectedItem isEqualToString:@"Employee Timesheet"]) // Goto Time Sheet
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMTimSheetViewController class]] && [HRMHelper sharedInstance].menuType == timeSheet)
        {
            if([HRMHelper sharedInstance].menuType != timeSheet)
                [HRMHelper sharedInstance].menuType = timeSheet;
        }
        else
        {
            HRMTimSheetViewController *timesheetVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMTimSheetViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:timesheetVC animated:YES];
            if([HRMHelper sharedInstance].menuType != timeSheet)
                [HRMHelper sharedInstance].menuType = timeSheet;
        }
    }
    else if ([selectedItem isEqualToString:@"Timesheet"]) // Goto Time Sheet for Employee
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMEmpTimeSheetViewController class]] && [HRMHelper sharedInstance].menuType == timeSheet)
        {
            if([HRMHelper sharedInstance].menuType != timeSheet)
                [HRMHelper sharedInstance].menuType = timeSheet;
        }
        else
        {
            HRMEmpTimeSheetViewController *timesheetVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmpTimeSheetViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:timesheetVC animated:YES];
            if([HRMHelper sharedInstance].menuType != timeSheet)
                [HRMHelper sharedInstance].menuType = timeSheet;
        }
    }
    else if ([selectedItem isEqualToString:@"Timesheet Correction Request"]) // Goto Time Sheet Correction for Official
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMTimSheetViewController class]] && [HRMHelper sharedInstance].menuType == tmesheetCorrection)
        {
            if([HRMHelper sharedInstance].menuType != tmesheetCorrection)
                [HRMHelper sharedInstance].menuType = tmesheetCorrection;
        }
        else
        {
            HRMTimSheetViewController *timesheetVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMTimSheetViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:timesheetVC animated:YES];
            if([HRMHelper sharedInstance].menuType != tmesheetCorrection)
                [HRMHelper sharedInstance].menuType = tmesheetCorrection;
        }
    }
    else if ([selectedItem isEqualToString:@"Leave Application"]) // Goto Leave Application
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if (IS_IPAD)
        {
            if ([currentViewController isMemberOfClass:[HRMLeaveListViewController class]] && [HRMHelper sharedInstance].menuType == leaveApplication)
            {
                if([HRMHelper sharedInstance].menuType != leaveApplication)
                    [HRMHelper sharedInstance].menuType = leaveApplication;
            }
            else
            {
                HRMLeaveListViewController *leaveVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMLeaveListViewController class])];
                [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:leaveVC animated:YES];
                if([HRMHelper sharedInstance].menuType != leaveApplication)
                    [HRMHelper sharedInstance].menuType = leaveApplication;
            }
        }
        else
        {
            if ([currentViewController isMemberOfClass:[HRMEmpLeaveListViewController class]] && [HRMHelper sharedInstance].menuType == leaveApplication)
            {
                if([HRMHelper sharedInstance].menuType != leaveApplication)
                    [HRMHelper sharedInstance].menuType = leaveApplication;
            }
            else
            {
                HRMEmpLeaveListViewController *leaveVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmpLeaveListViewController class])];
                [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:leaveVC animated:YES];
                if([HRMHelper sharedInstance].menuType != leaveApplication)
                    [HRMHelper sharedInstance].menuType = leaveApplication;
            }
        }
        
    }
    else if ([selectedItem isEqualToString:@"Interview"]) // Goto Interview
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMInterviewListViewController class]])
        {
            if([HRMHelper sharedInstance].menuType != interview)
                [HRMHelper sharedInstance].menuType = interview;
        }
        else
        {
            HRMInterviewListViewController *interviewVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMInterviewListViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:interviewVC animated:YES];
            if([HRMHelper sharedInstance].menuType != interview)
                [HRMHelper sharedInstance].menuType = interview;
        }
    }
    else if ([selectedItem isEqualToString:@"Reimbursement"]) // Goto Reimbursement
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMLeaveListViewController class]]&& [HRMHelper sharedInstance].menuType == reimbursement)
        {
            if([HRMHelper sharedInstance].menuType != reimbursement)
                [HRMHelper sharedInstance].menuType = reimbursement;
        }
        else
        {
            if (IS_IPAD)
            {
                HRMLeaveListViewController *leaveVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMLeaveListViewController class])];
                [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:leaveVC animated:YES];
                if([HRMHelper sharedInstance].menuType != reimbursement)
                    [HRMHelper sharedInstance].menuType = reimbursement;
            }
            else
            {
                HRMReimbursementEmplListViewController *reimbursementVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMReimbursementEmplListViewController class])];
                [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:reimbursementVC animated:YES];
                if([HRMHelper sharedInstance].menuType != reimbursement)
                    [HRMHelper sharedInstance].menuType = reimbursement;
            }
            
        }
    }
    else if ([selectedItem isEqualToString:@"Appraisal"]) // Goto Appraisal
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMEmployeeListViewController class]] && [HRMHelper sharedInstance].menuType == appraisal)
        {
            if([HRMHelper sharedInstance].menuType != appraisal)
                [HRMHelper sharedInstance].menuType = appraisal;
        }
        else
        {
            [UIAlertView showWithTextFieldAndTitle:ALERT_TITLE_APPRAISAL message:APPRAISAL_PIN cancelButtonTitle:nil otherButtonTitles:@[CANCEL_BUTTON, OK_BUTTON] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                switch (buttonIndex) {
                        
                    case 1:
                    {
                        NSString *strPin = [alertView textFieldAtIndex:0].text;
                        
                        // call PIn API
                        if([strPin validateWithString:APPRAISAL_PIN])
                        {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   
                        [[HRMAPIHandler handler]paySlipPinVerifiedWithPin:strPin WithSuccess:^(NSDictionary *responseDict) {
                            HRMEmployeeListViewController *appraisalVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmployeeListViewController class])];
                            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:appraisalVC animated:YES];
                            if([HRMHelper sharedInstance].menuType != appraisal)
                                [HRMHelper sharedInstance].menuType = appraisal;
                        } failure:^(NSError *error) {
                            
                        }];
                        });
                    }
                    }
                        break;
                    default:
                        break;
                }
            }];
            
            
            
            
        }
    }
    else if ([selectedItem isEqualToString:@"My Profile"]) // Goto My Profile
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMMyProfileViewController class]] && [HRMHelper sharedInstance].menuType == myProfile)
        {
            if([HRMHelper sharedInstance].menuType != myProfile)
                [HRMHelper sharedInstance].menuType = myProfile;
        }
        else
        {
            HRMMyProfileViewController *profileVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMMyProfileViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:profileVC animated:YES];
            if([HRMHelper sharedInstance].menuType != myProfile)
                [HRMHelper sharedInstance].menuType = myProfile;
        }
    }
    else if ([selectedItem isEqualToString:@"Notification"]) // Goto Notification
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMNotificationViewController class]] && [HRMHelper sharedInstance].menuType == notification)
        {
            if([HRMHelper sharedInstance].menuType != notification)
                [HRMHelper sharedInstance].menuType = notification;
        }
        else
        {
            HRMNotificationViewController *notificVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMNotificationViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:notificVC animated:YES];
            if([HRMHelper sharedInstance].menuType != notification)
                [HRMHelper sharedInstance].menuType = notification;
        }
    }
    else if ([selectedItem isEqualToString:@"Settings"]) // Goto Settings
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMSettingsViewController class]] && [HRMHelper sharedInstance].menuType == notification)
        {
            if([HRMHelper sharedInstance].menuType != settings)
                [HRMHelper sharedInstance].menuType = settings;
        }
        else if(![currentViewController isMemberOfClass:[HRMSettingsViewController class]])
        {
            HRMSettingsViewController *settingsVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMSettingsViewController class])];
            [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:settingsVC animated:YES];
            if([HRMHelper sharedInstance].menuType != settings)
                [HRMHelper sharedInstance].menuType = settings;
        }
    }
    else if ([selectedItem isEqualToString:@"Payslip"]) // Goto Pay Slip
    {
        self.currentViewController = [self.contentNavController.viewControllers lastObject];
        if ([currentViewController isMemberOfClass:[HRMPaySlipViewController class]] && [HRMHelper sharedInstance].menuType == payslip)
        {
            if([HRMHelper sharedInstance].menuType != payslip)
                [HRMHelper sharedInstance].menuType = payslip;
        }
        else
        {
            [UIAlertView showWithTextFieldAndTitle:ALERT_TITLE message:APPRAISAL_PIN cancelButtonTitle:nil otherButtonTitles:@[CANCEL_BUTTON, OK_BUTTON] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                switch (buttonIndex) {
                    case 1:
                    {
                        NSString *strPin = [alertView textFieldAtIndex:0].text;
                        // call PIn API
                        if([strPin validateWithString:APPRAISAL_PIN])
                        {  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[HRMAPIHandler handler]paySlipPinVerifiedWithPin:strPin WithSuccess:^(NSDictionary *responseDict) {
                                HRMPaySlipViewController *payslipVC = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMPaySlipViewController class])];
                                [[HRMNavigationalHelper sharedInstance].contentNavController pushViewController:payslipVC animated:YES];
                                if([HRMHelper sharedInstance].menuType != payslip)
                                    [HRMHelper sharedInstance].menuType = payslip;
                            } failure:^(NSError *error) {
                                
                            }];
                        });
                        }
                    }
                        break;
                    default:
                        break;
                }
            }];
            
        }
    }else if ([selectedItem isEqualToString:@"Logout"]) // Logout
    {
        [UIAlertView showWithTitle:kApplicationTitle message:LOGOUT cancelButtonTitle:nil otherButtonTitles:@[CANCEL_BUTTON, OK_BUTTON]
         
                    withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        
                        switch (buttonIndex) {
                            case 1:
                            {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [[HRMAPIHandler handler] logoutWithSuccess:^(NSDictionary *responseDict) {
                                        [self setLoginAsRoot];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserdId];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCompanyId];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUserName];
                                        [HRMToast showWithMessage:LOGOUT_SUCCESS];
                                        SET_BOOL_FOR_KEY(NO, kIsLogin);
                                    } failure:^(NSError *error) {
                                    }];
                                });
                            }
                                break;
                            default:
                                break;
                        }
                    }];
    }
}

-(NSDictionary*)getSection:(NSInteger)atIndex
{
    return [[HRMHelper sharedInstance].arrMenuInfo objectAtIndex:atIndex];
}

-(void)setLoginAsRoot
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[HRMNavigationalHelper sharedInstance] navDrawer] setViewControllers:@[[[[HRMNavigationalHelper sharedInstance] mainStoryboard]instantiateViewControllerWithIdentifier:NSStringFromClass([HRMLoginViewController class])]]];
    });
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
}


@end