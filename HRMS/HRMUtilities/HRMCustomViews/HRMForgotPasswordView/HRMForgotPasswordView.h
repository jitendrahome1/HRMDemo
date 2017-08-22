//
//  HRMForgotPasswordView.h
//  HRMS
//
//  Created by Jitendra Agarwal on 09/05/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMForgotPasswordView : UIView
{
    

    __weak IBOutlet UITextField *txtCompnayName;
    __weak IBOutlet UIButton *buttonOK;

    __weak IBOutlet UITextField *txtEmailAddress;
}
+(void)showForgotPasswordView;
@end
