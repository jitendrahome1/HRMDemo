//
//  HRMDashboardViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 30/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"

@interface HRMDashboardViewController : HRMBaseTableViewController <UIGestureRecognizerDelegate>
{
    IBOutletCollection(UIButton) NSArray *buttonCollection;
}
@end
