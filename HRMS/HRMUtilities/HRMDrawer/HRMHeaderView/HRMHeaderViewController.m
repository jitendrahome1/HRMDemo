//
//  HRMHeaderViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMHeaderViewController.h"
#import "HRMAddTimesheetViewController.h"
#import "HRMReimbursementAddViewController.h"
#import "HRMLeaveApplicationViewController.h"
#import "HRMAddInterviewViewController.h"
#import "HRMNotificationViewController.h"
#import "HRMInterviewListViewController.h"


@interface HRMHeaderViewController ()
{
    BOOL searchEnable;
    UIButton *search;
}
@end

@implementation HRMHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_buttonAdd addTarget:self action:@selector(actionAdd:) forControlEvents:UIControlEventTouchUpInside];
    _notificationLabelCount.layer.cornerRadius = CGRectGetWidth(_notificationLabelCount.frame)/2.0;
    _notificationLabelCount.clipsToBounds = YES;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] setNotificationBadgeWithCount:[OBJ_FOR_KEY(kNotificationCount) integerValue]];
    [_buttonNotification addTarget:self action:@selector(actionGotoNotification:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionMenu:(id)sender
{
    if ([HRMHelper sharedInstance].canOpenDrawer == YES)
        [[[HRMNavigationalHelper sharedInstance] navDrawer] toggleDrawer];
    else
        [[HRMNavigationalHelper sharedInstance].contentNavController popViewControllerAnimated:YES];
}

-(IBAction)actionAdd:(UIButton *)sender
{
    if (!IS_IPAD && !searchEnable) {
        if ([[HRMHelper sharedInstance] menuType] == timeSheet) {
            HRMAddTimesheetViewController *addTimeVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMAddTimesheetViewController class])];
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:addTimeVC animated:YES];
        }else if ([[HRMHelper sharedInstance] menuType] == reimbursement){
            HRMReimbursementAddViewController *addReiumbursementVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMReimbursementAddViewController class])];
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:addReiumbursementVC animated:YES];
        }else if ([[HRMHelper sharedInstance] menuType] == leaveApplication){
            HRMLeaveApplicationViewController *leaveApplicationVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMLeaveApplicationViewController class])];
             leaveApplicationVC.leaveHandler = applyLeave;
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:leaveApplicationVC animated:YES];
        }
    }else if (!searchEnable){
        if ([[HRMHelper sharedInstance] menuType] == interview) {
            HRMAddInterviewViewController *addInterviewVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMAddInterviewViewController class])];
            addInterviewVC.titleStatus = [[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] lastObject] isKindOfClass:[HRMInterviewListViewController class]] ? eAddInterview : eEditInterview;
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:addInterviewVC animated:YES];
        }
        else if ([[HRMHelper sharedInstance] menuType] == leaveApplication){
            HRMLeaveApplicationViewController *leaveApplicationVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMLeaveApplicationViewController class])];
             leaveApplicationVC.leaveHandler = applyLeave;
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:leaveApplicationVC animated:YES];
        }
        else if ([[HRMHelper sharedInstance] menuType] == reimbursement){
            HRMReimbursementAddViewController *addReiumbursementVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMReimbursementAddViewController class])];
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:addReiumbursementVC animated:YES];
        }
        else if ([[HRMHelper sharedInstance] menuType] == timeSheet) {
            HRMAddTimesheetViewController *addTimeVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMAddTimesheetViewController class])];
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:addTimeVC animated:YES];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowSearchBar object:nil];
    }
}

-(void)hideAddButton:(BOOL)hide
{
    [search removeFromSuperview];
    search = nil;
    [UIView animateWithDuration:0.15 animations:^{
        if (hide) {
            _buttonAdd.transform = CGAffineTransformMakeTranslation(70, 0);
            _buttonNotification.transform = CGAffineTransformMakeTranslation(IS_IPAD ? 40 : 70, 0);
            _notificationLabelCount.transform = CGAffineTransformMakeTranslation(IS_IPAD ? 40 : 70, 0);
            
        }else{
            _buttonAdd.transform = CGAffineTransformIdentity;
            _buttonNotification.transform = CGAffineTransformIdentity;
            _notificationLabelCount.transform = CGAffineTransformIdentity;
           
            if ([[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] lastObject] isKindOfClass:[HRMInterviewListViewController class]]) {
                _buttonAdd.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(_buttonAdd.bounds), 0);
                _buttonNotification.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(_buttonAdd.bounds), 0);
                _notificationLabelCount.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(_buttonAdd.bounds), 0);
                
                 search = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_buttonAdd.frame), CGRectGetMinY(_buttonAdd.frame), CGRectGetWidth(_buttonAdd.bounds), CGRectGetHeight(_buttonAdd.bounds))];
                [search addTarget:self action:@selector(searchShow) forControlEvents:UIControlEventTouchUpInside];
                [search setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
                [self.view addSubview:search];
            }
        }
    }];
}

-(void)searchShow{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSearchBar object:nil];;
}

-(void)headerAddButton:(NSString *)string{
    if ([string isEqualToString:kAddButton]) {
        [_buttonAdd setImage:[UIImage imageNamed:@"EmployeeHeaderPlus"] forState:UIControlStateNormal];
        searchEnable = NO;
    }else if ([string isEqualToString:kSearchButton]){
        [_buttonAdd setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
         searchEnable = YES;
    }else{
        [_buttonAdd setImage:[UIImage imageNamed:@"EmployeeHeaderEdit"] forState:UIControlStateNormal];
         searchEnable = NO;
    }
}

-(void)setNotificationBadgeWithCount:(NSInteger)badgeCount{
    
    if (badgeCount > 0) {
        _notificationLabelCount.text = [NSString stringWithFormat:@"%ld", (long)badgeCount];
        _notificationLabelCount.hidden = NO;
    }else{
        _notificationLabelCount.text = [NSString stringWithFormat:@"%ld", (long)badgeCount];
        _notificationLabelCount.hidden = YES;
    }
}

-(IBAction)actionGotoNotification:(UIButton *)sender{
    
    if (![[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] lastObject] isKindOfClass:[HRMNotificationViewController class]]) {
        HRMNotificationViewController *notificationVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMNotificationViewController class])];
        [HRMHelper sharedInstance].menuType = notification;
        [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:notificationVC animated:YES];
    }
}

@end
