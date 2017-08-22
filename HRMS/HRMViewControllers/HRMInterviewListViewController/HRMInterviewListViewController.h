//
//  HRMInterviewListViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 06/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"

@interface HRMInterviewListViewController : HRMBaseTableViewController<UISearchBarDelegate>
{
            UISearchBar *searchBar;
}
@property (strong, nonatomic) IBOutlet UITableView *tblInterViewList;

@end
