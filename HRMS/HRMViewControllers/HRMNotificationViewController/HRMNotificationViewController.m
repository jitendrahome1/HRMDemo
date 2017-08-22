//
//  HRMNotificationViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 06/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMNotificationViewController.h"
#import "HRMNotificationCell.h"

@interface HRMNotificationViewController ()
{
    NSMutableArray *arrayNotification;
    UILabel *labelNoData;
}
@end

@implementation HRMNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayNotification = [NSMutableArray new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = NOTIFICATION;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [[HRMHelper sharedInstance] setBackButton:NO];
    [[HRMAPIHandler handler] getNotificationWithSuccess:^(NSDictionary *responseDict) {
        [arrayNotification addObjectsFromArray:responseDict[@"notificationList"]];
        [self.tableView reloadData];
        [[[HRMNavigationalHelper sharedInstance] headerViewController] setNotificationBadgeWithCount:0];
        SET_OBJ_FOR_KEY(@"0", kNotificationCount);
        if (arrayNotification.count < 1) {
            [self showNoDataLabel:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showNoDataLabel:NO];
}

-(void)showNoDataLabel:(BOOL)show
{
    if (show) {
        labelNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50.0)];
        labelNoData.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        labelNoData.backgroundColor = [UIColor clearColor];
        labelNoData.textAlignment = NSTextAlignmentCenter;
        labelNoData.text = NO_DATA_AVAILABLE;
        labelNoData.font = FONT_REGULAR(IS_IPAD ? 25 : 18);
        labelNoData.textColor = [UIColor blackColor];
        [self.tableView.superview addSubview:labelNoData];
    }else{
        [labelNoData removeFromSuperview];
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayNotification.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMNotificationCell *cell = (HRMNotificationCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMNotificationCell class])];
    [cell setDatasource:arrayNotification[indexPath.row]];
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%f", [[HRMHelper sharedInstance] getLabelSizeFortext:[arrayNotification objectAtIndex:indexPath.row][@"description"] forWidth:CGRectGetWidth(self.view.frame)-29 WithFont:FONT_REGULAR(IS_IPAD ? 25 : 18)].height);
    return [[HRMHelper sharedInstance] getLabelSizeFortext:[[arrayNotification objectAtIndex:indexPath.row][@"description"] isEqualToString:@""] ? @"N.A." : [arrayNotification objectAtIndex:indexPath.row][@"description"] forWidth:CGRectGetWidth(self.view.frame)-29 WithFont:FONT_REGULAR(IS_IPAD ? 25 : 18)].height + (IS_IPAD ? 95 : 73);
}

@end
