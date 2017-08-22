//
//  HRMEmpReimbursementDetailsViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 08/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"

@interface HRMEmpReimbursementDetailsViewController : HRMBaseTableViewController
{
    IBOutletCollection(UILabel) NSArray *labelCollection;
    __weak IBOutlet UILabel *labelAmount;
    __weak IBOutlet UITextView *textDescription;
    __weak IBOutlet UICollectionView *collectionViewAttached;
    __weak IBOutlet UILabel *reimbursementType;
    __weak IBOutlet UILabel *labeldate;
    __weak IBOutlet UILabel *labelAO;
    __weak IBOutlet UIImageView *imageReimbursement;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsDesHightConst;
@property(nonatomic,strong)NSMutableArray *arrReimbursementDetails;
@end
