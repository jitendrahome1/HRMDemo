//
//  HRMReimbursementAddViewController.m
//  
//
//  Created by Priyam Dutta on 13/10/15.
//
//

#import "HRMReimbursementAddViewController.h"//
#import "HRMReimbursementAddCell.h"
#import "HRMDatePickerView.h"
#import "HRMPicker.h"

@interface HRMReimbursementAddViewController () <UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *arrAttachImage, *arrAOList, *arrBenifits;
    NSString *benifitId, *aoId, *strDateIncurred;
    NSData *reimbursementImage;
    NSDictionary *rules;
    id activeField;
}
@end

@implementation HRMReimbursementAddViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    arrAttachImage = [NSMutableArray new];
    arrAOList = [NSMutableArray new];
    arrBenifits = [NSMutableArray new];
    rules = [NSDictionary dictionary];
    [self setupUI];
    [btnFromDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [[HRMAPIHandler handler] getBenifitsTypeAndOfficerWithSuccess:^(NSDictionary *responseDict) {
        NSLog(@"Response Data ->%@",responseDict);
        [arrBenifits addObjectsFromArray:responseDict[@"benifits"]];
        [arrAOList addObjectsFromArray:responseDict[@"ao_officers"]];
        rules = responseDict[@"rules"];
    } failure:^(NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = ADD_REIMBURSEMENT;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [[HRMHelper sharedInstance] setBackButton:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)setupUI
{
    [btnFromDate.layer setBorderWidth:1.0f];
    [btnFromDate.layer setBorderColor:[[UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f] CGColor]];
    [txtAmount.layer setBorderWidth:1.0f];
    [txtAmount.layer setBorderColor:[[UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f] CGColor]];
    [txtDescription.layer setBorderWidth:1.0f];
    [txtDescription.layer setBorderColor:[[UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f] CGColor]];
    
    [buttonCollection enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (IS_IPAD) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-100, 0, 0)];
            [btnFromDate setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-100, 0, 0)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-45, 0, 0)];
            [btnFromDate setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-45, 0, 0)];
        }
    }];
}

#pragma mark - Table View Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification {
   
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   
    if(activeField == txtDescription)
    {
    [self.tableView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
     
    }
    if(activeField == txtAmount && IS_IPHONE4)
    {
    [self.tableView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if(activeField == txtDescription)
    {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [self.tableView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}


#pragma mark - Text Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeField = textView;

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  //  [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtAmount)
    {
        [txtAmount resignFirstResponder];
        [txtDescription becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtAmount) {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMERICS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else return YES;
}

#pragma mark - Image Picker

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                [self showCamera];
            else
                [HRMToast showWithMessage:NO_DEVICE_ATTACHED];
        }];
    }
    else if(buttonIndex == 1)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self showGallery];
        }];
    }
}

-(void)showCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)showGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    reimbursementImage = UIImageJPEGRepresentation(selectImage,0.5);
    //reimbursementImage = UIImageJPEGRepresentation(selectImage,90);
    [btnImageSelect setTitle:@"" forState:UIControlStateNormal];
    [btnImageSelect setBackgroundImage:selectImage forState:UIControlStateNormal];
}

#pragma mark- Image Select Action
- (IBAction)actionImageSelect:(id)sender {
    [self.view endEditing:YES];
    [[HRMHelper sharedInstance] animateButtonClickedZoom:sender completion:^{
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Select File Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
        [actionSheet showInView:self.view];
    }];
}

#pragma mark - IBAction

- (IBAction)btnSubmit:(id)sender {
    [self.view endEditing:YES];
        if ([self validateAttributes]) {
            [[HRMAPIHandler handler]applyEmployeeReimbursementWithOfficerID:aoId incurredDate:strDateIncurred amount:txtAmount.text description:txtDescription.text fileImage:reimbursementImage submissionDate:[[NSDate date ] stringFromDate] benefitId:benifitId WithSuccess:^(NSDictionary *responseDict) {
                [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
                [HRMToast showWithMessage:responseDict[@"responsedetails"]];
            } failure:^(NSError *error) {
                
            }];
        }
   
}

- (IBAction)actionReimbursementType:(UIButton *)sender {
        [self.view endEditing:YES];
    NSMutableArray *array = [NSMutableArray new];
    [arrBenifits enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj[@"type"]];
    }];
    if (array.count > 0) {
        [HRMPicker showWithArrayWithSelectedIndex:[array containsObject:sender.titleLabel.text] ? [array indexOfObject:sender.titleLabel.text] : 0 andArray:array didSelect:^(NSString *data, NSInteger index) {
            [sender setTitle:data forState:UIControlStateNormal];
            labelReimbursementType.text = [arrBenifits objectAtIndex:index][@"details"];
            [labelReimbursementType restartLabel];
            benifitId = [arrBenifits objectAtIndex:index][@"id"];
        }];
    }else [HRMToast showWithMessage:NO_REIMBURSEMENT_TYPE];
}


- (IBAction)actionSelectAO:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableArray *array = [NSMutableArray new];
    [arrAOList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj[@"name"]];
    }];
    if (array.count > 0) {
        [HRMPicker showWithArrayWithSelectedIndex:[array containsObject:sender.titleLabel.text] ? [array indexOfObject:sender.titleLabel.text] : 0 andArray:array didSelect:^(NSString *data, NSInteger index) {
            [sender setTitle:data forState:UIControlStateNormal];
            aoId = [arrAOList objectAtIndex:index][@"id"];
        }];   
    }else{
        HRMEmployeeListViewController *employeeVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmployeeListViewController class])];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:employeeVC];
        navController.navigationBar.barTintColor = kAppThemeColor;
        navController.navigationBar.tintColor = [UIColor whiteColor];
        [navController.navigationBar setTranslucent:NO];
        
        [[[HRMNavigationalHelper sharedInstance] contentNavController] presentViewController:navController animated:YES completion:^{
            [employeeVC setLeaveOfficerHandler:^(NSString *employeeName, NSString *employeeId) {
                [sender setTitle:employeeName forState:UIControlStateNormal];
                aoId = employeeId;
            }];
        }];
    }
}

-(IBAction)showDatePicker:(UIButton *)sender
{    [self.view endEditing:YES];
    // Tag 1: From Date   Tag 2: To Date
    [HRMDatePickerView showWithDateWithMaximumDate:^(NSDate *date) {
        [sender setTitle:[date stringFromDateWithFormat:@"MMM dd, yyyy"] forState:UIControlStateNormal];
        strDateIncurred = sender.titleLabel.text;
    } date:[NSDate date] isMax:YES];
}
#pragma mark - Validation

-(BOOL)validateAttributes
{
    if (benifitId == nil) {
        [HRMToast showWithMessage:SELECT_REIMBURSEMENT_TYPE];
        return NO;
    }
    if (strDateIncurred == nil) {
        [HRMToast showWithMessage:SELECT_DATE];
        return NO;
    }
    
    if([[[HRMHelper sharedInstance]trim:txtAmount.text]length] == 0)
    {
        [HRMToast showWithMessage:ENTER_AMOUNT];
        return NO;
    }
    if (aoId == nil) {
        [HRMToast showWithMessage:SELECT_AO];
        return NO;
    }
    if([[[HRMHelper sharedInstance]trim:txtDescription.text]length] == 0)
    {
        [HRMToast showWithMessage:ENTER_DESCRIPTION];
        return NO;
    }
    if ([rules[@"isAttachFile"] integerValue] && reimbursementImage == nil)
    {
        [HRMToast showWithMessage:SELECT_IMAGE];
        return NO;
    }
    
    return YES;
}
@end
