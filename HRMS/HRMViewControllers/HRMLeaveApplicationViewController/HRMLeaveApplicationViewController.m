//
//  HRMLeaveApplicationViewController.m
//
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMLeaveApplicationViewController.h"
#import "HRMDatePickerView.h"
#import "HRMPicker.h"
#import "HRMEmployeeListViewController.h"

@interface HRMLeaveApplicationViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableArray *arrLeaveType;
    NSString *fromDate, *toDate, *leaveTypeId, *personAOId, *personROId, *minYear;
    NSDictionary *dictionaryOfficer;
    id activeField;
}
@end


@implementation HRMLeaveApplicationViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
    textAddCC.delegate = self;
    textAddress.delegate = self;
    [buttonCollection enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTarget:self action:@selector(actionDateSelect:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [segmentControll addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    dictionaryOfficer = [NSDictionary dictionary];
    [[HRMAPIHandler handler] getAOROListWithSuccess:^(NSDictionary *responseDict) {
        dictionaryOfficer = responseDict;
    } failure:^(NSError *error) {
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    // [super viewWillAppear:animated];
    if (_leaveHandler == applyLeave) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
   
    [[HRMHelper sharedInstance] setBackButton:YES];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupUI
{
    if (_leaveHandler == applyLeave) {
        [buttonCollection enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
            obj.layer.borderWidth = 1.0;
            if(IS_IPAD)
                [obj setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.frame)-CGRectGetWidth(obj.frame)+255, 0, 0)];
            else
                [obj setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.frame)-CGRectGetWidth(obj.frame), 0, 0)];
        }];
        
        textAddress.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
        textAddress.layer.borderWidth = 1;
        textReason.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
        textReason.layer.borderWidth = 1;
        [segmentControll setTintColor:UIColorRGB(35.0, 134.0, 203.0, 1.0)];
        [segmentControll setSelectedSegmentIndex:1];
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = ADD_LEAVE;
        
    }else{ // /***** Leave Details ******/
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = LEAVE;
        [buttonCollection enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setBackgroundColor:[UIColor clearColor]];
            [obj setImage:nil forState:UIControlStateNormal];
            [obj setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [obj setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [obj setUserInteractionEnabled:NO];
        }];
        
        textReason.backgroundColor = [UIColor clearColor];
        //  [textReason setEditable:false];
        textReason.layer.borderWidth = 1.0f;
        textReason.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
        textAddress.backgroundColor = [UIColor clearColor];
        //   [textAddress setEditable:false];
        textAddress.layer.borderWidth = 1.0f;
        textAddress.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
        
        buttonSubmit.hidden = YES;
        segmentControll.hidden = YES;
        [self.tableView setContentInset:UIEdgeInsetsMake(-49, 0, 0, 0)];
        labelAvailable.text = _leaveDetails[@"available"];
        [textAddCC setUserInteractionEnabled:YES];
        if (_leaveHandler == leaveDetail) {
            textAddCC.enabled = NO;
        }
        [textAddCC setText:[_leaveDetails[@"ccPerson"] isEqualToString:@""] ? @"N.A." : _leaveDetails[@"ccPerson"]];
        [textAddCC setBackgroundColor:[UIColor clearColor]];
        [textAddress setText:[_leaveDetails[@"address"] isEqualToString:@""] ? @"N.A." : _leaveDetails[@"address"]];
        
        [textReason setText:[_leaveDetails[@"reason"]  isEqualToString:@""] ? @"N.A." : _leaveDetails[@"reason"]];
      
        
        if( textAddress.contentSize.height < 213)
            nsConstAddress.constant = textAddress.contentSize.height;
        if( textReason.contentSize.height < 213)
        {
            nsConstReason.constant = textReason.contentSize.height;
//            self.tableView.contentInset = UIEdgeInsetsMake(-49, 0,-CGRectGetHeight(self.tableView.frame), 0);
        }
        [textReason setEditable:NO];
        [textAddress setEditable:NO];
        CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height -textReason.contentSize.height);
        [self.tableView setContentOffset:bottomOffset animated:YES];
        [buttonCollection enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (button.tag) {
                case 1:
                    [button setTitle:_leaveDetails[@"leaveYear"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [button setTitle:_leaveDetails[@"leaveType"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [button setTitle:_leaveDetails[@"fromDate"] forState:UIControlStateNormal];
                    break;
                case 4:
                    [button setTitle:_leaveDetails[@"toDate"] forState:UIControlStateNormal];
                    break;
                case 5:
                    //[button setTitle:_leaveDetails[@"personAO"] forState:UIControlStateNormal];
                    [button setTitle: [_leaveDetails[@"personAO"] isEqualToString:@""] ? @"N.A." : _leaveDetails[@"personAO"] forState:UIControlStateNormal];
                    break;
                case 6:
                    [button setTitle:[_leaveDetails[@"personRO"] isEqualToString:@""] ? @"N.A." : _leaveDetails[@"personRO"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }];
    }
}

#pragma mark - Validation

-(BOOL)validateAttributes
{
    if (leaveTypeId == nil) {
        [HRMToast showWithMessage:SELECT_LEAVE_TYPE];
        return NO;
    }
    
    if (fromDate == nil && segmentControll.selectedSegmentIndex == 1) {
        [HRMToast showWithMessage:SELECT_FROM_DATE];
        return NO;
    }
    
    if (toDate == nil && segmentControll.selectedSegmentIndex == 1) {
        [HRMToast showWithMessage:SELECT_TO_DATE];
        return NO;
    }else if (fromDate == nil){
        
        [HRMToast showWithMessage:SELECT_DATE];
        return NO;
    }
    
    if (personAOId == nil) {
        [HRMToast showWithMessage:SELECT_AO];
        return NO;
    }
    
    if (![dictionaryOfficer[@"noNeedRo"] boolValue] && personROId == nil) {
        [HRMToast showWithMessage:SELECT_RO];
        return NO;
    }
    
    if ([textAddCC hasText]) {
        [[textAddCC.text componentsSeparatedByString:@", "] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj validateEmailForLeave:idx+1]) {
                *stop = YES;
                NO;
            }
        }];
    }
    
    if (![textAddress hasText]) {
        [HRMToast showWithMessage:ENTER_ADDRESS];
        return NO;
    }
    
    if (![textReason hasText]) {
        [HRMToast showWithMessage:ENTER_REASON];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextField & UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "])
        return NO;
    
    if ([string isEqualToString:@","]) {
        NSString *filteredString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [textAddCC setText:[filteredString stringByAppendingString:@" "]];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textAddCC) {
        [textField resignFirstResponder];
        [textAddress becomeFirstResponder];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    activeField = textView;
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UITextView *textView = activeField;
    if(activeField == textAddCC)
        [self.tableView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
    
    else if(activeField == textReason && IS_IPHONE4)
        
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.frame.size.height - textView.frame.size.height+kbSize.height) animated:YES];
    else
        [self.tableView setContentOffset:CGPointMake(0, kbSize.height+textView.frame.size.height+50) animated:YES];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if(activeField == textAddCC)
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    else{
        [self.tableView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
 
}

#pragma mark - Table View Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD)
        return _leaveHandler == applyLeave ? 1356.0 : nsConstAddress.constant + nsConstReason.constant + 1000;
    else
        return _leaveHandler == applyLeave ? 771.0 : nsConstAddress.constant + nsConstReason.constant + 611;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mark - IBAction

-(IBAction)segmentedControl:(UISegmentedControl *)segment
{
    [buttonCollection enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((segment.selectedSegmentIndex == 0 || segment.selectedSegmentIndex == 2) && button.tag == 4) {
            [button setEnabled:NO];
            [button setBackgroundColor:UIColorRGB(233.0, 233.0, 233.0, 1.0)];
        }else{
            [button setEnabled:YES];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }];
}

-(IBAction)dismissView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionSubmit:(id)sender {
    [self.view endEditing:YES];
    NSString *duration;
    if ([self validateAttributes]) {
        if (segmentControll.selectedSegmentIndex == 0)
            duration = @"Single";
        else if (segmentControll.selectedSegmentIndex == 1)
            duration = @"Multiple";
        else
            duration = @"Half";
        
        if (segmentControll.selectedSegmentIndex == 2) {
            [UIAlertView showWithTitle:kApplicationTitle message:SELECT_SHIFT cancelButtonTitle:nil otherButtonTitles:@[AFTERNOON, MORNING, CANCEL_BUTTON] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0 || buttonIndex == 1) {
                    [[HRMAPIHandler handler] applyLeaveWithLeaveTypeId:leaveTypeId fromDate:fromDate toDate:@"" duration:duration roId:personROId ? personROId : @"" aoId:personAOId ccPerson:textAddCC.text isMorning:[NSString stringWithFormat:@"%ld", (long)buttonIndex] address:textAddress.text reason:textReason.text WithSuccess:^(NSDictionary *responseDict) {
                        [HRMToast showWithMessage:ADD_LEAVE_SUCCESS];
                        [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }];
        }else{
            [[HRMAPIHandler handler] applyLeaveWithLeaveTypeId:leaveTypeId fromDate:fromDate toDate:toDate ? toDate : @"" duration:duration roId:personROId ? personROId : @"" aoId:personAOId ccPerson:textAddCC.text isMorning:@"" address:textAddress.text reason:textReason.text WithSuccess:^(NSDictionary *responseDict) {
                [HRMToast showWithMessage:ADD_LEAVE_SUCCESS];
                [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

-(IBAction)actionDateSelect:(UIButton *)sender{
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 1:
        {  if (_leaveHandler == applyLeave) {
            [HRMPicker showWithArrayWithSelectedIndex:[NSDate getAllYearList].count-2 andArray:[NSDate getAllYearList] didSelect:^(NSString *data, NSInteger index) {
                [sender setTitle:data forState:UIControlStateNormal];
                minYear = data;
                [arrLeaveType removeAllObjects];
                [[HRMAPIHandler handler] getLeaveTypeListWithYear:data WithSuccess:^(NSDictionary *responseDict) {
                    arrLeaveType = [[NSMutableArray alloc] init];
                    [arrLeaveType addObjectsFromArray:responseDict[@"leaveList"]];
                } failure:^(NSError *error) {
                    
                }];
            }];
        }
        }
            break;
        case 2:
        {
            NSMutableArray *arrayLeave = [NSMutableArray new];
            [arrLeaveType enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayLeave addObject:obj[@"leaveTypeName"]];
            }];
            if ([arrayLeave count] > 0) {
                [HRMPicker showWithArrayWithSelectedIndex:[arrayLeave containsObject:sender.titleLabel.text] ? [arrayLeave indexOfObject:sender.titleLabel.text] : 0 andArray:arrayLeave didSelect:^(NSString *data, NSInteger index) {
                    [sender setTitle:data forState:UIControlStateNormal];
                    labelAvailable.text = [NSString stringWithFormat:@"%@", [arrLeaveType objectAtIndex:index][@"leaveAvailable"]];
                    leaveTypeId = [NSString stringWithFormat:@"%@", [arrLeaveType objectAtIndex:index][@"leaveTypeId"]];
                    if ([[arrLeaveType objectAtIndex:index][@"ifNoHalfDay"] isEqualToString:@""]) {
                        if (segmentControll.selectedSegmentIndex == 2){
                            [segmentControll setEnabled:NO forSegmentAtIndex:2];
                            [segmentControll setSelectedSegmentIndex:0];
                            [HRMToast showWithMessage:NO_HALFDAY];
                        }
                    }else{
                        [segmentControll setEnabled:YES forSegmentAtIndex:2];
                    }
                }];
            }else [HRMToast showWithMessage:SELECT_YEAR];
        }
            break;
        case 3:
        {  if (_leaveHandler == applyLeave) {
            [HRMDatePickerView showWithDate:^(NSDate *date) {
                [sender setTitle:[date stringFromDate] forState:UIControlStateNormal];
                fromDate = [date stringFromDate];
            } isTimeMode:NO];
        }
        }
            break;
        case 4:
        {  if (_leaveHandler == applyLeave) {
            if (fromDate != nil) {
                [HRMDatePickerView showWithDateWithMaximumDate:^(NSDate *date) {
                    [sender setTitle:[date stringFromDate] forState:UIControlStateNormal];
                    toDate = [date stringFromDate];
                } date:[[fromDate dateFromStringWithFormat:@"MMM dd, yyyy"] dateByAddingTimeInterval:24*60*60] isMax:NO];
            }else [HRMToast showWithMessage:SELECT_FROM_DATE];
        }
        }
            break;
        case 5:
        {
            if ([dictionaryOfficer[@"showAllAO"] boolValue]) {
                if (_leaveHandler == applyLeave) {
                    HRMEmployeeListViewController *employeeVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmployeeListViewController class])];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:employeeVC];
                    navController.navigationBar.barTintColor = kAppThemeColor;
                    navController.navigationBar.tintColor = [UIColor whiteColor];
                    [navController.navigationBar setTranslucent:NO];
                    
                    [[[HRMNavigationalHelper sharedInstance] contentNavController] presentViewController:navController animated:YES completion:^{
                        [employeeVC setLeaveOfficerHandler:^(NSString *employeeName, NSString *employeeId) {
                            [sender setTitle:employeeName forState:UIControlStateNormal];
                            personAOId = employeeId;
                        }];
                    }];
                }
            }
            else{
                NSMutableArray *arrayList = [NSMutableArray new];
                [dictionaryOfficer[@"listAO"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arrayList addObject:obj[@"name"]];
                }];
                if (arrayList.count > 0) {
                    if (_leaveHandler == applyLeave) {
                        [HRMPicker showWithArrayWithSelectedIndex:[arrayList containsObject:sender.titleLabel.text] ? [arrayList indexOfObject:sender.titleLabel.text] : 0 andArray:arrayList didSelect:^(NSString *data, NSInteger index) {
                            [sender setTitle:data forState:UIControlStateNormal];
                            personAOId = [NSString stringWithFormat:@"%@", [dictionaryOfficer[@"listAO"] objectAtIndex:index][@"id"]];
                        }];
                    }
                }else [HRMToast showWithMessage:NO_AO_LIST];
            }
        }
            break;
        case 6:
        {  if (_leaveHandler == applyLeave) {
            if ([dictionaryOfficer[@"showAllRO"] boolValue]) {
                HRMEmployeeListViewController *employeeVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmployeeListViewController class])];
                
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:employeeVC];
                navController.navigationBar.barTintColor = kAppThemeColor;
                navController.navigationBar.tintColor = [UIColor whiteColor];
                [navController.navigationBar setTranslucent:NO];
                
                [[[HRMNavigationalHelper sharedInstance] contentNavController] presentViewController:navController animated:YES completion:^{
                    [employeeVC setLeaveOfficerHandler:^(NSString *employeeName, NSString *employeeId) {
                        [sender setTitle:employeeName forState:UIControlStateNormal];
                        personROId = employeeId;
                    }];
                }];
            }
        }
        else if([dictionaryOfficer[@"listRO"] count]>0){
            NSMutableArray *arrayList = [NSMutableArray new];
            [dictionaryOfficer[@"listRO"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayList addObject:obj[@"name"]];
            }];
            if (arrayList.count > 0) {
                [HRMPicker showWithArrayWithSelectedIndex:[arrayList containsObject:sender.titleLabel.text] ? [arrayList indexOfObject:sender.titleLabel.text] : 0 andArray:arrayList didSelect:^(NSString *data, NSInteger index) {
                    [sender setTitle:data forState:UIControlStateNormal];
                    personROId = [NSString stringWithFormat:@"%@", [dictionaryOfficer[@"listRO"] objectAtIndex:index][@"id"]];
                }];
            }else [HRMToast showWithMessage:SELECT_AO];
            }
        }
            break;
        default:
            break;
    }
}


@end
