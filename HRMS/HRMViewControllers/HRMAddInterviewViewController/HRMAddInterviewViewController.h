//
//  HRMAddInterviewViewController.h
//  HRMS
//
//  Created by Chinmay Das on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"
#import "HRMTextField.h"
@interface HRMAddInterviewViewController : HRMBaseTableViewController
{
    
    IBOutletCollection(UIButton) NSArray *buttonDateCollections;
    IBOutletCollection(UIButton) NSArray *buttonCollections;
    IBOutlet UITextField *txtCandidateName;
    IBOutlet UITextField *txtCandidateEmail;
    IBOutlet UITextField *txtCandidateContNo;
    IBOutlet UITextField *txtStatus;
    IBOutlet UITextField *txtNoticePeriod;
    IBOutlet UITextField *txtCurrentEmpName;
    IBOutlet UITextField *txtCurrentPackage;
    IBOutlet UITextField *txtPositionFor;
    IBOutlet UIButton *buttonSave;

    __weak IBOutlet UIButton *btnInterView;

}
typedef enum {
    eEditInterview,
    eAddInterview
}interviewTile;
@property (nonatomic, readwrite) interviewTile titleStatus;

@end
