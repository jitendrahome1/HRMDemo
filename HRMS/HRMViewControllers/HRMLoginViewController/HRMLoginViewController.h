//
//  ViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRMBaseTableViewController.h"

@interface HRMLoginViewController : HRMBaseTableViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *textCompany;
    __weak IBOutlet UITextField *textUsername;
    __weak IBOutlet UITextField *textPassword;
    
}
@end

