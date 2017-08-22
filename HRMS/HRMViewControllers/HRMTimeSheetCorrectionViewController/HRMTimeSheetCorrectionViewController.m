//
//  HRMTimeSheetCorrectionViewController.m
//  HRMS
//
//  Created by Chinmay Das on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMTimeSheetCorrectionViewController.h"
#import "HRMPicker.h"
#import "HRMDatePickerView.h"
@interface HRMTimeSheetCorrectionViewController()
{
        NSString *strTimeSelect;
    __weak IBOutlet UILabel *lblEmpName;
    __weak IBOutlet UILabel *lblEmpID;
    __weak IBOutlet UILabel *lblEmpDepartment;
    __weak IBOutlet UITextField *txtDate;
    __weak IBOutlet HRMTextField *txtProjectName;
    __weak IBOutlet UIButton *btnTime;
    __weak IBOutlet UITextView *txtDescription;
    __weak IBOutlet HRMTextField *txtLocation;
    __weak IBOutlet UIImageView *imgCover;
    __weak IBOutlet UILabel *lblTimeTitle;
    __weak IBOutlet UIImageView *imgProfile;
}
@end

@implementation HRMTimeSheetCorrectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setupUI];
    [self setupPopulateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = TIMESHEET_CORRECTION;
    [[HRMHelper sharedInstance] setBackButton:YES];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
}

//UIsetup
-(void)setupUI
{
    txtProjectName.enabled = NO;
    txtDate.enabled = NO;
    txtDescription.textAlignment = NSTextAlignmentJustified;
    txtDescription.backgroundColor = [UIColor clearColor];
    [btnTime setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.frame)-CGRectGetWidth(btnTime.frame)+320, 0, 0)];
    
//    self.viewImageCover.layer.cornerRadius = 5.0;
//    self.viewImageCover.layer.borderWidth = 1.0;
//    self.viewImageCover.layer.borderColor = [UIColor grayColor].CGColor;
    
    btnTime.layer.borderWidth = 1;
    txtDescription.layer.borderWidth = 1;
    btnTime.layer.borderColor =  UIColorRGB(207, 203.0, 203.0, 1.0).CGColor;
    [btnTime setBackgroundColor:[UIColor whiteColor]];
    [btnTime setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
}

#pragma mark-
#pragma populate data
-(void)setupPopulateData
{
    if([[_arrTimeSheetData valueForKey:@"clockType" ]integerValue] == 0)
        lblTimeTitle.text = @"Out Time:";
    else
        lblTimeTitle.text = @"In Time:";
    
    lblEmpName.text = [_arrTimeSheetData valueForKey:@"name"];
    lblEmpID.text = [_arrTimeSheetData valueForKey:@"employeeID"];
    lblEmpDepartment.text = [_arrTimeSheetData valueForKey:@"department"];
    txtDate.text = [_arrTimeSheetData valueForKey:@"date"];
    txtProjectName.text = [_arrTimeSheetData valueForKey:@"project"];
    strTimeSelect = [_arrTimeSheetData valueForKey:@"clockTime"];
    [btnTime setTitle:strTimeSelect forState: UIControlStateNormal];
    txtLocation.text = [_arrTimeSheetData valueForKey:@"location"];
    txtDescription.text = [_arrTimeSheetData valueForKey:@"description"];
    NSString *profileImageURl = [_arrTimeSheetData valueForKey:@"profileImage"];
    NSString *timeSheetURL = [_arrTimeSheetData valueForKey:@"timesheetImage"];
   
    dispatch_queue_t concurrentQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(concurrentQ, ^{
        UIImage *timeSheetPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:timeSheetURL]]];
        UIImage *profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageURl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imgCover.image = timeSheetPic ? timeSheetPic : [UIImage imageNamed:@"BigGrayImage"];
            imgProfile.image = profilePic ? profilePic : [UIImage imageNamed:@"BigGrayImage"];
        });
    });
}
- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
        [self.tableView setContentInset:edgeInsets];
        [self.tableView setScrollIndicatorInsets:edgeInsets];
    }];
}
- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.tableView setContentInset:edgeInsets];
        [self.tableView setScrollIndicatorInsets:edgeInsets];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)actionTimeSelect:(UIButton *)sender
{
    [HRMDatePickerView showWithDate:^(NSDate *date) {
        [sender setTitle:[date stringFromTime] forState:UIControlStateNormal];
        strTimeSelect = sender.titleLabel.text;
    } isTimeMode:YES];
}
#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
        cell.backgroundColor = [UIColor clearColor];
}
- (IBAction)saveButtonTapped:(id)sender {
    // save api call.
    [self.view endEditing:YES];
    [[HRMAPIHandler handler]saveTimesheetCorrectionWithTimesheetReqID:[_arrTimeSheetData valueForKey:@"timesheetReqID"] clockTime:strTimeSelect location:txtLocation.text withSuccess:^(NSDictionary *responseDict) {
        if([responseDict[@"responsecode"]integerValue] == 201)
       [HRMToast showWithMessage:TIMESHEET_EDIT_ERROR];
        else
        {
        NSLog(@"Sucess->%@", responseDict);
        [HRMToast showWithMessage:TIMESHEET_EDIT_SUCCESS];
        [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {

    }];
    
}

@end
