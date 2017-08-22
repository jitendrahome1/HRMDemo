//
//  ViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMLoginViewController.h"
#import "HRMContentBaseViewController.h"
#import "HRMForgotPasswordView.h"
@interface HRMLoginViewController ()

@end

@implementation HRMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [[HRMHelper sharedInstance] showSpinnerOnparentView:self userInteraction:NO completion:^{
    
    //  }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = UIColorRGB(13.0, 76.0, 144.0, 1.0);
    [[HRMHelper sharedInstance] setBackButton:YES];
#ifdef DEBUG
    textCompany.text = @"int";
//    textUsername.text = @"arvind";
//    textPassword.text = @"zaq123ZZ@#$";
    textUsername.text = @"john";
    textPassword.text = @"123456";
    
#endif
}

#pragma mark - tableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetHeight(self.view.frame) / 3.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textCompany) {
        [textCompany resignFirstResponder];
        [textUsername becomeFirstResponder];
    }else if (textField == textUsername){
        [textUsername resignFirstResponder];
        [textPassword becomeFirstResponder];
    }else
        [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - IBActions

-(IBAction)actionPush:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([textCompany.text validateWithString:COMPANY_VALIDATION] && [textUsername.text validateWithString:NAME_VALIDATION] && [textPassword.text validateWithString:PASSWORD_VALIDATION]) {
        sender.clipsToBounds = YES;
        JTMaterialSpinner *spin = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(sender.frame) - 10, CGRectGetHeight(sender.frame) - 10)];
        spin.center = sender.center;
        spin.circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        spin.circleLayer.lineWidth = 2.0;
        spin.pulse.backgroundColor = kFlatGreen;
        
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [sender.superview addSubview:spin];
                    [spin beginRefreshingWithFader];
                    sender.transform = CGAffineTransformMakeScale(0.1, 0.001);
                    [sender setTitle:@"" forState:UIControlStateNormal];
                } completion:^(BOOL finished) {
                    sender.alpha = 0.0;
                    
                    /****** Login API Integration ******/
                    
                    [[HRMAPIHandler handler] loginWithCompanyName:textCompany.text userName:textUsername.text password:textPassword.text WithSuccess:^(NSDictionary *responseDict) {
                        if ([responseDict[@"responsecode"] integerValue] == 200) {
                           
                            SET_OBJ_FOR_KEY(responseDict[@"userid"], kUserdId);
                            SET_OBJ_FOR_KEY(responseDict[@"companyid"], kCompanyId);
                            SET_OBJ_FOR_KEY(responseDict[@"name"], kLoginUserName);
                            // Notification count
                            SET_OBJ_FOR_KEY(responseDict[@"notificationCount"], kNotificationCount);
                            
                            [[HRMManager manager] setHeader];
                           
                            /******* Access Permition API Integration *******/
                            
                            [[HRMAPIHandler handler] getAccessPermitWithLoader:NO WithSuccess:^(NSDictionary *responseDict) {
                                
                                // Permit Defaults
                                SET_OBJ_FOR_KEY(responseDict[@"assignPermit"], kAssignPermit);
                                SET_OBJ_FOR_KEY(responseDict[@"modulePermit"], kModulePermit);
                                if ([OBJ_FOR_KEY(kModulePermit)[@"employeeList"] integerValue] == 0 && IS_IPAD) {
                                    [HRMToast showWithMessage:NOT_AUTHOR];
                                    [self failedLoginWithSender:sender andSpinner:spin];
                                }else{
                                    if(spin.blockComplete)
                                        spin.blockComplete(YES);
                                    SET_BOOL_FOR_KEY(YES, kIsLogin);
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        HRMContentBaseViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMContentBaseViewController class])];
                                        [HRMHelper sharedInstance].menuType = home;
                                        [self.navigationController pushViewController:contentVC animated:YES];
                                    });
                                }
                            } failure:^(NSError *error) {
                                [self failedLoginWithSender:sender andSpinner:spin];
                            }];
                        }else{
                            [self failedLoginWithSender:sender andSpinner:spin];
                        }
                    } failure:^(NSError *error) {
                        [self failedLoginWithSender:sender andSpinner:spin];
                    }];
                }];
            });
        }];
    }
}

-(void)failedLoginWithSender:(UIButton *)sender andSpinner:(JTMaterialSpinner *)spin{
    if(spin.blockComplete)
        spin.blockComplete(NO);
    [spin setRestore:^(BOOL isRestore) {
        sender.alpha = 1.0;
        if (isRestore) {
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                sender.transform = CGAffineTransformIdentity;
                [sender setTitle:@"Login" forState:UIControlStateNormal];
            } completion:nil];
        }
    }];
}

- (IBAction)actionForgotPassword:(UIButton *)sender {
    
    [HRMForgotPasswordView showForgotPasswordView];
}

@end
