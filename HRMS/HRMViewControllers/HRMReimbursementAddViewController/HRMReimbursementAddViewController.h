//
//  HRMReimbursementAddViewController.h
//  
//
//  Created by Priyam Dutta on 13/10/15.
//
//

#import "HRMBaseTableViewController.h"
#import "MarqueeLabel.h"

@interface HRMReimbursementAddViewController : HRMBaseTableViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIViewControllerTransitioningDelegate>
{
    __weak IBOutlet UIButton *btnFromDate;
    __weak IBOutlet UITextField *txtAmount;
    __weak IBOutlet UITextView *txtDescription;
    __weak IBOutlet UICollectionView *collectionAttchFile;
    
    __weak IBOutlet UIButton *btnImageSelect;
    __weak IBOutlet MarqueeLabel *labelReimbursementType;
    
    IBOutletCollection(UIButton) NSArray *buttonCollection;
}
@end
