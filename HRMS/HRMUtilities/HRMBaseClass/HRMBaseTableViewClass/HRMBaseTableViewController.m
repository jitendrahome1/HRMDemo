//
//  HRMBaseTableViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 30/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"

@interface HRMBaseTableViewController ()

@end

@implementation HRMBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = UIColorRGB(244.0, 244.0, 244.0, 1.0);
    [[HRMHelper sharedInstance] setCanOpenDrawer:YES];
    [[HRMHelper sharedInstance] setBackButton:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         if([HRMHelper sharedInstance].menuType != home)
//             cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.02+(0.06*indexPath.row)) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.2 animations:^{
//                if([HRMHelper sharedInstance].menuType != home)
//                    cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.15 animations:^{
//                    cell.transform = CGAffineTransformIdentity;
//                    
//                } completion:^(BOOL finished) {
//                    
//                }];
//            }];
//            
//        });
//    });
}

@end
