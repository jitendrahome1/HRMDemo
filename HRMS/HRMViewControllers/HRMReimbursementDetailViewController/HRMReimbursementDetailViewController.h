//
//  HRMReimbursementDetailViewController.h
//  
//
//  Created by Priyam Dutta on 07/10/15.
//
//

#import "HRMBaseTableViewController.h"

@interface HRMReimbursementDetailViewController : HRMBaseTableViewController <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UILabel *lblHdrName;
    __weak IBOutlet UILabel *lblEmployment;
    __weak IBOutlet UICollectionView *collectionHeader;
    __weak IBOutlet UILabel *lblAmount;
    __weak IBOutlet UILabel *dateIncurred;
    __weak IBOutlet UITextView *txtView;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) NSDictionary *reimbursementDetails;

@end
