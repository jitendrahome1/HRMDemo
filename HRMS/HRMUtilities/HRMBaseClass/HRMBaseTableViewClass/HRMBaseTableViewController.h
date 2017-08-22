//
//  HRMBaseTableViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 30/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMBaseTableViewController : UITableViewController


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
