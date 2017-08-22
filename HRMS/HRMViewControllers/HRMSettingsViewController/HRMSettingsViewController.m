//
//  HRMSettingsViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 07/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMSettingsViewController.h"

@interface HRMSettingsViewController ()
@end

@implementation HRMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = SETTINGS;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
}

-(void)setupUI{
   }

#pragma mark- Button Action

- (IBAction)actionCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionUpdate:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([textCurentPassword.text validateWithString:CURRENT_PASSWORD] && [textNewPassword.text validateWithString:NEW_PASSWORD] && [textConfirmPassword.text validateWithString:CONFIRM_PASSWORD] && [textConfirmPassword.text matchesString:textNewPassword.text])
    {
        [[HRMAPIHandler handler]updatePasswordWithCurrentPassword:textCurentPassword.text newPassword:textNewPassword.text withSuccess:^(NSDictionary *responseDict) {
            [HRMToast showWithMessage:PASSWORD_UPDATED_SUCCESS];
            [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
        }];
    }
}

#pragma mark- text Field Delegete

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textCurentPassword) {
        [textCurentPassword resignFirstResponder];
        [textNewPassword becomeFirstResponder];
    }else if (textField == textNewPassword){
        [textNewPassword resignFirstResponder];
        [textConfirmPassword becomeFirstResponder];
    }else
        [textField resignFirstResponder];
    return YES;
}

@end
