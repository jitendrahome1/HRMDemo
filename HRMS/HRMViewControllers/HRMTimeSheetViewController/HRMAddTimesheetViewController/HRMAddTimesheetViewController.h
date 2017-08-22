//
//  HRMAddTimesheetViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"
#import "HRMSLocationHandler.h"
#import "HRMDatePickerView.h"

@interface HRMAddTimesheetViewController : HRMBaseViewController <UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    __weak IBOutlet UIButton *buttonDate;
    __weak IBOutlet UIButton *buttonProject;
    __weak IBOutlet UIImageView *imageCamera;
    __weak IBOutlet UIButton *buttonCurrentTime;
    __weak IBOutlet UIButton *buttonInTime;
    __weak IBOutlet UIButton *buttonOutTime;
    __weak IBOutlet UIButton *buttonTakePhoto;
    
}
@end
