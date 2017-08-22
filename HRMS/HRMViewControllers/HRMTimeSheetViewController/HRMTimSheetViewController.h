//
//  HRMTimSheetViewController.h
//  
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMBaseViewController.h"

@interface HRMTimSheetViewController : HRMBaseViewController<UISearchBarDelegate>
{
        UISearchBar *searchBar;
    __weak IBOutlet UITableView *tbleTimeSheet;
    __weak IBOutlet UIButton *buttonDepartment;
    __weak IBOutlet UIButton *buttonYear;
    __weak IBOutlet UIButton *buttonMonth;

    IBOutlet NSLayoutConstraint *viewSectionConstHight;
}
- (IBAction)actionApplyFilter:(UIButton *)sender;
@end
