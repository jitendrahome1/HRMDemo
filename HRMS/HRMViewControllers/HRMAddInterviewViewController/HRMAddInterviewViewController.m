//
//  HRMAddInterviewViewController.m
//  HRMS
//
//  Created by Chinmay Das on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMAddInterviewViewController.h"
#import "HRMPicker.h"
#import "HRMDatePickerView.h"

NSString *const arrayInterviewTypes[] = {@"Telephonic", @"Skype", @"Face to Face"};
NSString *const arrayExperience[] = {@"Freshers", @"0-2 Years", @"2-4 Years", @"4-5 Years", @"Above 5 Years"};


@interface HRMAddInterviewViewController()
{
    NSArray *arrayDepartments, *arrayInterviewer;
    NSString *dateString, *timeString, *interviewType, *department, *departmentId, *experience, *interviewerName, *interviewerId;
    NSDictionary *interviewDetails;
}
@end

@implementation HRMAddInterviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    if(self.titleStatus == eAddInterview)
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = ADD_INTERVIEW;
    else{
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = EDIT_INTERVIEW;
        interviewDetails = [NSDictionary dictionary];
        interviewDetails = [HRMHelper sharedInstance].dataDictionary;
        [self updateFields];
    }
    [[HRMAPIHandler handler] getDepartmentsForInterviewWithSuccess:^(NSDictionary *responseDict) {
        arrayDepartments = [NSArray arrayWithArray:responseDict[@"departments"]];
        if (_titleStatus == eEditInterview) {
            [[HRMAPIHandler handler] getInterviewerWithID:interviewDetails[@"departmentid"] WithSuccess:^(NSDictionary *responseDict) {
                arrayInterviewer = [NSArray arrayWithArray:responseDict[@"employees"]];
            } failure:^(NSError *error) {
            }];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[HRMHelper sharedInstance] setBackButton:YES];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
}
/**
 *  Update Fields for Edit Interview
 */
-(void)updateFields{
    interviewerId = interviewDetails[@"interviewerid"];
    departmentId = interviewDetails[@"departmentid"];

    txtCandidateName.text = [NSString stringWithFormat:@"%@", interviewDetails[@"candidateName"]];
    txtCandidateEmail.text = [NSString stringWithFormat:@"%@", interviewDetails[@"candidateEmail"]];
    txtCandidateContNo.text = [NSString stringWithFormat:@"%@", [interviewDetails[@"candidatePhone"] isEqualToString:@""] ? @"N.A." :  interviewDetails[@"candidatePhone"]];
    txtPositionFor.text = [NSString stringWithFormat:@"%@", interviewDetails[@"position"]];
    txtCurrentPackage.text = [NSString stringWithFormat:@"%@", [interviewDetails[@"currentPackage"] isEqualToString:@""] ? @"N.A." :  interviewDetails[@"currentPackage"]];
    txtCurrentEmpName.text = [NSString stringWithFormat:@"%@", [interviewDetails[@"currentEmployerName"] isEqualToString:@""] ? @"N.A." :  interviewDetails[@"currentEmployerName"]];
    txtNoticePeriod.text =[NSString stringWithFormat:@"%@", [interviewDetails[@"noticePeriod"] isEqualToString:@""] ? @"N.A." :  interviewDetails[@"noticePeriod"]];
    txtStatus.text = [NSString stringWithFormat:@"%@", [interviewDetails[@"status"] isEqualToString:@""] ? @"N.A." :  interviewDetails[@"status"]];
    [buttonDateCollections enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 101) {
            [obj setTitle:interviewDetails[@"interviewDate"] forState:UIControlStateNormal];
            dateString = [[interviewDetails[@"interviewDate"] dateFromStringWithFormat:@"dd.MM.yyyy"] stringFromDateWithFormat:@"dd.MM.yyyy"];
        }else{
            if ([dateString isEqualToString:[[NSDate date] stringFromDateWithFormat:@"dd.MM.yyyy"]]) {
                [obj setTitle:[[[NSDate date] dateByAddingTimeInterval:1*60*60] stringFromTime] forState:UIControlStateNormal];
                timeString = [[[NSDate date] dateByAddingTimeInterval:1*60*60] stringFromTime];
            }else{
                [obj setTitle:interviewDetails[@"interviewTime"] forState:UIControlStateNormal];
                timeString = interviewDetails[@"interviewTime"];
            }
        }
    }];
    [buttonCollections enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 103) {
            [obj setTitle:interviewDetails[@"interviewType"] forState:UIControlStateNormal];
            interviewType = interviewDetails[@"interviewType"];
        }else if (obj.tag == 104){
            [obj setTitle:[NSString stringWithFormat:@"%@", [interviewDetails[@"department"] isEqualToString:@""] ? @"N.A." :  interviewDetails[@"department"]] forState:UIControlStateNormal];
            department = interviewDetails[@"department"];
        }else if (obj.tag == 105){
            [obj setTitle:interviewDetails[@"candidateExp"] forState:UIControlStateNormal];
            experience = interviewDetails[@"candidateExp"];
        }else if (obj.tag == 106){
            [obj setTitle:[NSString stringWithFormat:@"%@", [interviewDetails[@"interviewerName"] isEqualToString:@""] ? @"N.A." :  interviewDetails[@"interviewerName"]] forState:UIControlStateNormal];
            interviewerName = interviewDetails[@"interviewerName"];
        }
    }];
}

-(void)setupUI
{
    [buttonCollections enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if(IS_IPAD)
            [obj setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.frame)-CGRectGetWidth(obj.frame)+510, 0, 0)];
        else
            [obj setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.frame)-CGRectGetWidth(obj.frame), 0, 0)];
    }];
    [buttonDateCollections enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTarget:self action:@selector(actionOpenPicker:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [buttonCollections enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj addTarget:self action:@selector(actionOpenPicker:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [buttonSave addTarget:self action:@selector(actionScheduleInterview:) forControlEvents:UIControlEventTouchUpInside];
    dateString = @"*/";
    department = @"*/";
    experience = @"*/";
    interviewerId = @"";
    timeString = @"";
    interviewType = @"";
}

-(BOOL)validateFields{
    if ([dateString isEqualToString:@"*/"]) {
        [HRMToast showWithMessage:ENTER_DATE];
        return NO;
    }else if (![txtCandidateName hasText]){
        [HRMToast showWithMessage:ENTER_NAME];
        return NO;
    }else if (![txtCandidateEmail.text validateEmail]){
        [HRMToast showWithMessage:ENTER_MAIL];
        return NO;
    }else if (![txtCandidateContNo.text validatePhone]){
        [HRMToast showWithMessage:ENTER_PHONE];
        return NO;
    }else if ([department isEqualToString:@"*/"]){
        [HRMToast showWithMessage:ENTER_DEPARTMENT];
        return NO;
    }else if (![txtPositionFor hasText]){
        [HRMToast showWithMessage:ENTER_POSITION];
        return NO;
    }else if ([experience isEqualToString:@"*/"]){
        [HRMToast showWithMessage:ENTER_EXPERIENCE];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txtCandidateName) {
        [txtCandidateName resignFirstResponder];
        [txtCandidateEmail becomeFirstResponder];
    }else if (textField == txtCandidateEmail){
        [txtCandidateEmail resignFirstResponder];
        [txtCandidateContNo becomeFirstResponder];
    }else if (textField == txtCandidateContNo){
        [txtCandidateContNo resignFirstResponder];
    }else if (textField == txtPositionFor){
        [txtPositionFor resignFirstResponder];
    }else if (textField == txtCurrentPackage){
        [txtCurrentPackage resignFirstResponder];
        [txtCurrentEmpName becomeFirstResponder];
    }else if (textField == txtCurrentEmpName){
        [txtCurrentEmpName resignFirstResponder];
        [txtNoticePeriod becomeFirstResponder];
    }else if (textField == txtNoticePeriod){
        [txtNoticePeriod resignFirstResponder];
    }else [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtCandidateContNo) {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMERICS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else if (textField == txtCandidateName){
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:ALPHABETS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else return YES;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - IBActions

-(IBAction)actionOpenPicker:(UIButton *)sender{
    [self.view endEditing:YES];
    switch (sender.tag) {
        case 101:
        {
            [HRMDatePickerView showWithDateWithMaximumDate:^(NSDate *date) {
                [sender setTitle:[date stringFromDateWithFormat:@"dd.MM.yyyy"] forState:UIControlStateNormal];
                dateString = sender.titleLabel.text;
            } date:[NSDate date] isMax:NO];
        }
            break;
        case 102:
        {
            if (![dateString isEqualToString:@"*/"]) {
                [HRMDatePickerView showWithDate:^(NSDate *date) {
                    
                    if ([[[dateString dateFromStringWithFormat:@"dd.MM.yyyy"] stringFromDateWithFormat:@"dd.MM.yyyy"] isEqualToString:[[NSDate date] stringFromDateWithFormat:@"dd.MM.yyyy"]]) {
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"HH:mm:ss"];
                        
                        NSDate *date1= [formatter dateFromString:[[[NSDate date] dateByAddingTimeInterval:1*60*60] stringFromDateWithFormat:@"HH:mm:ss"]];
                        NSDate *date2 = [formatter dateFromString:[date stringFromDateWithFormat:@"HH:mm:ss"]];
                        
                        NSComparisonResult result = [date1 compare:date2];
                        if(result == NSOrderedDescending)
                        {
//                            NSLog(@"date1 is later than date2");
                            [HRMToast showWithMessage:SCHEDULE_TIME];
                        }
                        else if(result == NSOrderedAscending)
                        {
//                            NSLog(@"date2 is later than date1");
                            [sender setTitle:[date stringFromTime] forState:UIControlStateNormal];
                            timeString = sender.titleLabel.text;
                        }
                        else
                        {
//                            NSLog(@"date1 is equal to date2");
                            [HRMToast showWithMessage:SCHEDULE_TIME];
                        }
                    }else{
                        [sender setTitle:[date stringFromTime] forState:UIControlStateNormal];
                        timeString = sender.titleLabel.text;
                    }
                } isTimeMode:YES];
            }else [HRMToast showWithMessage:SELECT_DATE];
        }
            break;
        case 103:
        {
            [HRMPicker showWithArrayWithSelectedIndex:[@[@"Telephonic", @"Skype", @"Face to Face"] containsObject:sender.titleLabel.text] ? [@[@"Telephonic", @"Skype", @"Face to Face"] indexOfObject:sender.titleLabel.text] : 0 andArray:@[@"Telephonic", @"Skype", @"Face to Face"] didSelect:^(NSString *data, NSInteger index) {
                [sender setTitle:data forState:UIControlStateNormal];
                interviewType = sender.titleLabel.text;
            }];
        }
            break;
        case 104:
        {
            NSMutableArray *arrayDept = [NSMutableArray new];
            [arrayDepartments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayDept addObject:obj[@"department"]];
            }];
            if (arrayDept.count > 0) {
                [HRMPicker showWithArrayWithSelectedIndex:[arrayDept containsObject:sender.titleLabel.text] ? [arrayDept indexOfObject:sender.titleLabel.text] : 0 andArray:[arrayDept mutableCopy] didSelect:^(NSString *data, NSInteger index) {
                    [sender setTitle:data forState:UIControlStateNormal];
                    department = sender.titleLabel.text;
                    [btnInterView setTitle:@"InterViewer name" forState:UIControlStateNormal];
                    departmentId = [arrayDepartments objectAtIndex:index][@"departmentId"];
                    [[HRMAPIHandler handler] getInterviewerWithID:[arrayDepartments objectAtIndex:index][@"departmentId"] WithSuccess:^(NSDictionary *responseDict) {
                        arrayInterviewer = [NSArray arrayWithArray:responseDict[@"employees"]];
                        if(arrayInterviewer.count == 0 || !arrayInterviewer)
                        {
                            interviewerId = @"";
                        }
                        
                    } failure:^(NSError *error) {
                    }];
                }];
            }else [HRMToast showWithMessage:NO_DATA_AVAILABLE];
            
        }
            break;
        case 105:
        {
            [HRMPicker showWithArrayWithSelectedIndex:[@[@"Freshers", @"0-2 Years", @"2-4 Years", @"4-5 Years", @"Above 5 Years"] containsObject:sender.titleLabel.text] ? [@[@"Freshers", @"0-2 Years", @"2-4 Years", @"4-5 Years", @"Above 5 Years"] indexOfObject:sender.titleLabel.text] : 0 andArray:@[@"Freshers", @"0-2 Years", @"2-4 Years", @"4-5 Years", @"Above 5 Years"] didSelect:^(NSString *data, NSInteger index) {
                [sender setTitle:data forState:UIControlStateNormal];
                experience = sender.titleLabel.text;
            }];
        }
            break;
        case 106:
        {
            if (arrayDepartments.count > 0 && ![department isEqualToString:@"*/"]) {
                if(arrayInterviewer.count > 0)
                {
                    NSMutableArray *arrayInt = [NSMutableArray new];
                    [arrayInterviewer enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [arrayInt addObject:obj[@"employeeName"]];
                    }];
                    [HRMPicker showWithArrayWithSelectedIndex:[arrayInt containsObject:sender.titleLabel.text] ? [arrayInt indexOfObject:sender.titleLabel.text] : 0 andArray:arrayInt didSelect:^(NSString *data, NSInteger index) {
                        [sender setTitle:data forState:UIControlStateNormal];
                        interviewerName = sender.titleLabel.text;
                        interviewerId = [arrayInterviewer objectAtIndex:index][@"empId"];
                    }];
                }else{
                    [HRMToast showWithMessage:NO_RECORD_FOUND];
                }
            }else{
                [HRMToast showWithMessage:SELECT_DEPARTMENT];
            }
        }
            break;
        default:
            break;
    }
}

-(IBAction)actionScheduleInterview:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self validateFields]) {
        [[HRMAPIHandler handler] addInterviewWithInterviewId:_titleStatus == eEditInterview ? interviewDetails[@"interviewID"] : @""
                                               interviewerId:interviewerId
                                                        date:dateString
                                                        time:timeString
                                                        name:txtCandidateName.text
                                                       email:txtCandidateEmail.text
                                                      mobile:txtCandidateContNo.text
                                               interviewType:interviewType
                                                  department:departmentId
                                                    position:txtPositionFor.text
                                                  experience:experience
                                              currentPackage:txtCurrentPackage.text
                                             currentEmployer:txtCurrentEmpName.text
                                                noticePeriod:txtNoticePeriod.text
                                                      status:txtStatus.text
                                                 WithSuccess:^(NSDictionary *responseDict) {
                                                     if (_titleStatus == eEditInterview) {
                                                         [[[HRMNavigationalHelper sharedInstance] contentNavController] popToViewController:[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] objectAtIndex:[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] count] - 3] animated:YES];
                                                         [HRMToast showWithMessage:INT_EDIT_SUCCESS];
                                                     }else{
                                                         [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
                                                         [HRMToast showWithMessage:INT_ADD_SUCCESS];
                                                     }
                                                 } failure:^(NSError *error) {
                                                 }];
    }
}

@end
