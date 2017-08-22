//
//  HRMDashboardViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 30/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMDashboardViewController.h"
#import "HRMAddEmployeeView.h"
#import "HRMEmployeeListViewController.h"
#import "HRMLeaveListViewController.h"
#import "HRMInterviewListViewController.h"
#import "HRMPaySlipViewController.h"
#import "HRMTimSheetViewController.h"
#import "HRMEmpTimeSheetViewController.h"
#import "HRMReimbursementEmplListViewController.h"
#import "HRMEmpLeaveListViewController.h"
#import "HRMSettingsViewController.h"
#import "HRMMyProfileViewController.h"
#import "HRMNotify.h"
#import "HRMAppraisalPinView.h"

@interface HRMDashboardViewController ()<HRMPasscodePinDelegate>
{
    HRMAddEmployeeView *flotingFooterView;
    CGPoint tblLastContentOffset;
    BOOL startAnimate;
    NSArray *arrayDirection, *employeeArray, *officialArray;
    NSMutableArray *tempAnimateArray;
    UIImage *currentBackground;
}
@end

@implementation HRMDashboardViewController

CGFloat viewHeight;
- (void)viewDidLoad {
    [super viewDidLoad];
    employeeArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Employee" ofType:@"plist"]];
    officialArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Official" ofType:@"plist"]];
    //    [HRMNotify showNotificationWithTitle:@"" andDescription:@""];
    arrayDirection = @[@"down", @"up"];
    tempAnimateArray = [[NSMutableArray alloc] initWithArray:buttonCollection];
    if (IS_IPAD)
    {
        //        flotingFooterView = [HRMAddEmployeeView instantiateFromNib];
        CGRect frame = flotingFooterView.frame;
        viewHeight = frame.size.height;
        frame.origin.y = self.navigationController.view.frame.size.height + viewHeight;
        flotingFooterView.frame = frame;
        [self.navigationController.view addSubview:flotingFooterView];
    }
    else
    {
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
    }
    //    [buttonCollection enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        obj.hidden = YES;
    //    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [self tempAnimate];
    });
}

-(void)tempAnimate{
    if ([tempAnimateArray count]>0) {
        UIButton *button = [tempAnimateArray objectAtIndex: arc4random() % [tempAnimateArray count]];
        [UIView transitionWithView:button duration:0.35 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            button.hidden = NO;
        } completion:^(BOOL finished) {
            [tempAnimateArray removeObject:button];
            [self tempAnimate];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [HRMHelper sharedInstance].menuType = home;
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = HOME;
    [[HRMHelper sharedInstance] setBackButton:NO];
    [buttonCollection enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
        [tapGestureRecognizer setDelegate:self];
        [obj addGestureRecognizer:tapGestureRecognizer];
        
    }];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    self.tableView.bounces = NO;
    startAnimate = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dashboardFlipAnimation];
    });
    [self.view setUserInteractionEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideFooter];
    startAnimate = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dashboardFlipAnimation{
    UIButton *button = [self randomObject][@"object"];
    UIButton *buttonFlip = [self randomObject][@"object"];
    button.clipsToBounds = YES;
    currentBackground = button.currentBackgroundImage;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, CGRectGetWidth(button.frame)+30, CGRectGetHeight(button.frame)+200)];
    imageView.center = CGPointMake(button.center.x, button.center.y);
    imageView.image = [UIImage imageNamed:[[[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IS_IPAD ? @"officialDashboard" : @"employeeDashboard" ofType:@"plist"]] objectAtIndex:button.tag-1]];
    imageView.alpha = 0.0;
    [button addSubview:imageView];
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.alpha = 1.0;
        button.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            if ([[self randomObject][@"direct"] isEqualToString:@"up"]){
                imageView.transform = CGAffineTransformMakeTranslation(0.0, 80);
            }else if ([[self randomObject][@"direct"] isEqualToString:@"down"]){
                imageView.transform = CGAffineTransformMakeTranslation(0.0, -80);
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                imageView.alpha = 0.0;
                button.alpha = 1.0;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
                if(startAnimate)
                    [self dashboardFlipAnimation];
            }];
        }];
    }];
    
    if (![buttonFlip isEqual:button]) {
        if (CGRectGetHeight(buttonFlip.bounds) > CGRectGetWidth(buttonFlip.bounds)) {
            [UIView transitionWithView:buttonFlip duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            } completion:^(BOOL finished) {
            }];
        }else{
            [UIView transitionWithView:buttonFlip duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            } completion:^(BOOL finished) {
            }];
        }
    }
    
    /*[UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     CATransform3D rotate = CATransform3DIdentity;
     rotate.m34 = -1.0/500.0;
     if (CGRectGetWidth(button.frame) > CGRectGetHeight(button.frame)) {
     rotate = CATransform3DRotate(rotate, M_PI, 1.0, 0.0, 0.0);
     }else if (CGRectGetHeight(button.frame) > CGRectGetWidth(button.frame)){
     rotate = CATransform3DRotate(rotate, M_PI, 0.0, 1.0, 0.0);
     }
     button.layer.transform = rotate;
     } completion:^(BOOL finished) {
     [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
     button.layer.transform = CATransform3DIdentity;
     } completion:^(BOOL finished) {
     //            if(startAnimate)
     //                [self dashboardFlipAnimation];
     }];
     }];*/
}

- (NSDictionary *)randomObject
{
    if ([arrayDirection count] == 0) {
        return nil;
    }
    return @{@"direct": [arrayDirection objectAtIndex: arc4random() % [arrayDirection count]], @"object": [buttonCollection objectAtIndex: arc4random() % [buttonCollection count]]};
}

- (HRMMenuType)menuTypeForString:(NSString*)enumString{
    return (HRMMenuType)[enumString integerValue];
}

#pragma mark - UITapGesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    //        gestureRecognizer.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    //    } completion:^(BOOL finished){
    //    }];
    return YES;
}

-(IBAction)tapReceived:(UITapGestureRecognizer *)sender
{
    [self.view setExclusiveTouch:YES];
    [self.view setUserInteractionEnabled:NO];
    CGPoint tapPointInView = [sender locationInView:sender.view];
    //    CGPoint touchLocation = [self.tableView convertPoint:tapPointInView toView:[[UIApplication sharedApplication] keyWindow]];
    UIView *blurEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(sender.view.bounds), CGRectGetWidth(sender.view.bounds))];
    [blurEffect setCenter:CGPointMake(tapPointInView.x, tapPointInView.y)];
    blurEffect.transform = CGAffineTransformMakeScale(0.02, 0.02);
    blurEffect.alpha = 0.3;
    blurEffect.layer.cornerRadius = CGRectGetWidth(sender.view.bounds)/2;
    blurEffect.clipsToBounds = YES;
    blurEffect.backgroundColor = [UIColor blackColor];
    [[sender.view.subviews firstObject] addSubview:blurEffect];
    
    sender.view.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        blurEffect.alpha = 0.0;
        blurEffect.transform = CGAffineTransformMakeScale(40.0, 40.0);
    } completion:^(BOOL finished) {
        [blurEffect removeFromSuperview];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Tag == %d", sender.view.tag];
        NSDictionary *dictionary = [[!IS_IPAD ? employeeArray : officialArray filteredArrayUsingPredicate:predicate] firstObject];
        Class viewControllerClass = NSClassFromString(dictionary[@"Class"]);
        id viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(viewControllerClass)];
        [self.view setUserInteractionEnabled:YES];
        
        [sender setEnabled:YES];
        if (![self accessPermitWithModule:dictionary]) {
            [HRMToast showWithMessage:NOT_ALLOWED];
            return;
        }
        
        
        int tag =  IS_IPAD ? 6 : 3 ;
        if([dictionary[@"Tag"]intValue] == tag)
        {

            [HRMAppraisalPinView showPasscodePinView:self];
            
            
            
                        [UIAlertView showWithTextFieldAndTitle:IS_IPAD? ALERT_TITLE_APPRAISAL : ALERT_TITLE_PAYSLIP message:APPRAISAL_PIN cancelButtonTitle:nil otherButtonTitles:@[CANCEL_BUTTON, OK_BUTTON] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 1:
                    {
                        NSString *strPin = [alertView textFieldAtIndex:0].text;
                        if([strPin validateWithString:APPRAISAL_PIN])
                        {
                            // call PIn API
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [[HRMAPIHandler handler]paySlipPinVerifiedWithPin:strPin WithSuccess:^(NSDictionary *responseDict) {
                                    [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:viewController animated:YES];
                                    [HRMHelper sharedInstance].menuType = [self menuTypeForString:dictionary[@"Enum"]];
                                } failure:^(NSError *error) {
                                }];
                            });
                        }
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
        else
        {
            [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:viewController animated:YES];
            [HRMHelper sharedInstance].menuType = [self menuTypeForString:dictionary[@"Enum"]];
        }
    }];
}

#pragma mark - Access Permit

-(BOOL)accessPermitWithModule:(NSDictionary *)dictionary
{
    if (IS_IPAD) {
        if ([dictionary[@"Enum"] integerValue] == 2 && [OBJ_FOR_KEY(kModulePermit)[@"timesheet"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 4 && [OBJ_FOR_KEY(kModulePermit)[@"leave"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 6 && [OBJ_FOR_KEY(kModulePermit)[@"reimbursement"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 7 && [OBJ_FOR_KEY(kModulePermit)[@"appraisal"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 1 || [dictionary[@"Enum"] integerValue] == 8 || [dictionary[@"Enum"] integerValue] == 10 || [dictionary[@"Enum"] integerValue] == 5)
            return YES;
    }else{
        if ([dictionary[@"Enum"] integerValue] == 2 && [OBJ_FOR_KEY(kAssignPermit)[@"timesheet"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 11 && [OBJ_FOR_KEY(kAssignPermit)[@"payslip"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 6 && [OBJ_FOR_KEY(kAssignPermit)[@"reimbursement"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 4 && [OBJ_FOR_KEY(kAssignPermit)[@"leave"] boolValue])
            return YES;
        else if ([dictionary[@"Enum"] integerValue] == 10)
            return YES;
    }
    return NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!IS_IPAD)
        return CGRectGetHeight(self.view.frame) / 3.0;
    else if (indexPath.row % 2 == 0)
        return 483.0;
    else return 190.0;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(tblLastContentOffset.y < scrollView.contentOffset.y)
    {
        if(IS_IPAD)
            [self hideFooter];
    }
    else if (tblLastContentOffset.y > scrollView.contentOffset.y)
    {
        if(IS_IPAD)
            [self showFooter];
    }
    if (scrollView.contentOffset.y > tblLastContentOffset.y) {
        tblLastContentOffset = CGPointMake(scrollView.contentOffset.x, 386.0);
    }else if(scrollView.contentOffset.y < tblLastContentOffset.y){
        tblLastContentOffset = CGPointMake(scrollView.contentOffset.x, 0.0);
    }else
        tblLastContentOffset = scrollView.contentOffset;
    
}

-(void)showFooter
{
    [UIView animateWithDuration:0.6f animations:^{
        CGRect frame = flotingFooterView.frame;
        frame.origin.y = self.navigationController.view.frame.size.height - viewHeight;
        flotingFooterView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

-(void)hideFooter
{
    [UIView animateWithDuration:0.6f animations:^{
        CGRect frame = flotingFooterView.frame;
        frame.origin.y =  self.navigationController.view.frame.size.height + viewHeight;
        flotingFooterView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

-(void)HRMViewControllerOkAction:(NSString *)strPin
{
    NSLog(@" display pin %@", strPin);
//    
//    [[HRMAPIHandler handler]paySlipPinVerifiedWithPin:strPin WithSuccess:^(NSDictionary *responseDict) {
//        [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:viewController animated:YES];
//        [HRMHelper sharedInstance].menuType = [self menuTypeForString:dictionary[@"Enum"]];
//    } failure:^(NSError *error) {
//    }];
}

@end
