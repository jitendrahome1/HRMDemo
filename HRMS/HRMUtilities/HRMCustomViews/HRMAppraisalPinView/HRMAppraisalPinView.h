//
//  HRMAppraisalPinView.h
//  HRMS
//
//  Created by Jitendra on 8/2/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//
@protocol HRMPasscodePinDelegate <NSObject>

@optional
-(void)HRMViewControllerOkAction:(NSString *)strPin;

@end
#import <UIKit/UIKit.h>
#import "PasscodeView.h"
@interface HRMAppraisalPinView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet PasscodeView *passcodeView;
@property(weak,nonatomic)id <HRMPasscodePinDelegate> delegate;
+(void)showPasscodePinView:(UIViewController*)onParentVC;
@end
