//
//  HRMLeaveApplicationViewController.h
//  
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMBaseTableViewController.h"
#import "HRMTextField.h"
#import "MarqueeLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface HRMLeaveApplicationViewController : HRMBaseTableViewController 
{
    IBOutletCollection(UIButton) NSArray *buttonCollection;
    __weak IBOutlet UITextView *textAddress;
    __weak IBOutlet UITextView *textReason;
    __weak IBOutlet UIButton *buttonSubmit;
    __weak IBOutlet HRMTextField *textAddCC;
    __weak IBOutlet MarqueeLabel *labelAvailable;
    __weak IBOutlet UISegmentedControl *segmentControll;

    __weak IBOutlet NSLayoutConstraint *nsConstAddress;
    __weak IBOutlet NSLayoutConstraint *nsConstReason;
}

typedef enum {
    leaveDetail,
    applyLeave
}LeaveHandler;

@property (nonatomic, readwrite) LeaveHandler leaveHandler;

@property (nonatomic, strong) NSDictionary *leaveDetails;

@end
