//
//  HRMSettingsViewController.h
//  HRMS
//
//  Created by Jitendra Agarwal on 07/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"
#import "HRMTextField.h"

@interface HRMSettingsViewController : HRMBaseViewController
{
    __weak IBOutlet HRMTextField *textCurentPassword;
    __weak IBOutlet HRMTextField *textNewPassword;
    __weak IBOutlet HRMTextField *textConfirmPassword;
}

@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

@end
