//
//  HRMEmployeeDetailsViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 03/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMEmployeeDetailsViewController.h"
#import "HRMEmployeeDetailscell.h"

@interface HRMEmployeeDetailsViewController ()<floatMenuDelegate>
{
    NSArray *arrTile;
    NSArray *arrValue;
}
@end

@implementation HRMEmployeeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    headerView = [HRMEmployeeHeaderView instantiateFromNib];
    [self.tableView setParallaxHeaderView:headerView mode:VGParallaxHeaderModeFill height:headerView.frame.size.height];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self setupArrValueAssign];
    [self lblShowAndHide];
    [self setupLoadCrossBtn];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = EMPLOYEE_DETAILS;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [[HRMHelper sharedInstance] setBackButton:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_addButton removeFromSuperview];
}

-(void)setupArrValueAssign
{
  
    arrTile = [[NSArray alloc]initWithObjects:@"Date Of Join:",@"CTC:",@"Mobile Number:",@"Date of Birth:", nil];
    arrValue = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@", [_employeeDetails[@"joiningDate"] isEqualToString:@""] ? @"N.A." :  _employeeDetails[@"joiningDate"]],[NSString stringWithFormat:@"%@",[_employeeDetails valueForKey:@"CTC"]],[NSString stringWithFormat:@"%@", [_employeeDetails[@"mobileNumber"] isEqualToString:@""] ? @"N.A." :  _employeeDetails[@"mobileNumber"]],[NSString stringWithFormat:@"%@", [_employeeDetails[@"dateOfBirth"] isEqualToString:@""] ? @"N.A." :  _employeeDetails[@"dateOfBirth"]], nil];
    
    headerView.lblEmplyname.text = [NSString stringWithFormat:@"%@", [_employeeDetails valueForKey:@"fullName"]];
   // headerView.lblEmpIDWithDepatment.text = [NSString stringWithFormat:@"%@ (%@)",[_employeeDetails valueForKey:@"employeeId"],[_employeeDetails valueForKey:@"designation"]];
     headerView.lblEmpIDWithDepatment.text = [NSString stringWithFormat:@"%@ (%@)", [_employeeDetails[@"employeeId"] isEqualToString:@""] ? @"N.A." :  _employeeDetails[@"employeeId"], [_employeeDetails[@"designation"] isEqualToString:@""] ? @"N.A." :  _employeeDetails[@"designation"]];
    headerView.lblDesigner.text = [NSString stringWithFormat:@"%@", [_employeeDetails valueForKey:@"departmentName"]];
    
//    // Add Gradient
//    CAGradientLayer *gradLayer = [CAGradientLayer layer];
//    gradLayer.frame = headerView.imagBG.bounds;
//    gradLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite: 0.0 alpha: 0.0] CGColor], (id)[[UIColor colorWithWhite: 1.0 alpha: 1.0] CGColor], nil];
//    gradLayer.startPoint = CGPointMake(0.0f, 0.0f);
//    gradLayer.endPoint = CGPointMake(1.0f, 0.0f);
    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_employeeDetails valueForKey:@"profileImage"]]]]?:[UIImage imageNamed:@"BigGrayImage.png"];
        
        EAGLContext *openGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        CIContext *context = [CIContext contextWithEAGLContext:openGLContext];
        
        CIImage *coreImage = [CIImage imageWithCGImage:img.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:coreImage forKey:kCIInputImageKey];
        [filter setValue:@(5.0) forKey:kCIInputRadiusKey];
        CIImage *output = [filter valueForKey:kCIOutputImageKey];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            headerView.imgEmply.image = img;
            headerView.imgEmply.layer.cornerRadius =  headerView.imgEmply.frame.size.width / 2;
            headerView.imgEmply.clipsToBounds = YES;
            [headerView.activityIndicator stopAnimating];
            headerView.imagBG.image = [UIImage imageWithCGImage:[context createCGImage:output fromRect:[output extent]]];;
        }];
    }];
}

-(void)setupLoadCrossBtn
{
    CGRect floatFrame = CGRectMake([UIScreen mainScreen].bounds.size.width - 150 , [UIScreen mainScreen].bounds.size.height-180, 80, 80);
    
    _addButton = [[VCFloatingActionButton alloc]initWithFrame:floatFrame normalImage:[UIImage imageNamed:@"BluePlus"] andPressedImage:[UIImage imageNamed:@"BlueCross"] withScrollview:nil];
    _addButton.imageArray = @[@"EmployeeAppraisal",@"EmployeeReimbursement",@"EmployeeLeave",@"EmployeeTimeSheetDetails"];
    _addButton.labelArray = @[@"Appraisal",@"Reimbursement",@"Leave",@"Timesheet"];
    _addButton.delegate = self;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_addButton];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    if (self.tableView.parallaxHeader.progress > 1.0){
        headerView.imgEmply.transform = CGAffineTransformMakeScale(self.tableView.parallaxHeader.progress, self.tableView.parallaxHeader.progress);
//        headerView.lblEmplyname.translatesAutoresizingMaskIntoConstraints = YES;
//        headerView.lblEmpIDWithDepatment.translatesAutoresizingMaskIntoConstraints = YES;
//        headerView.lblDesigner.translatesAutoresizingMaskIntoConstraints = YES;
        headerView.lblEmplyname.transform = CGAffineTransformMakeTranslation(0, self.tableView.parallaxHeader.progress*30);
        headerView.lblEmpIDWithDepatment.transform = CGAffineTransformMakeTranslation(0, self.tableView.parallaxHeader.progress*30);
        headerView.lblDesigner.transform = CGAffineTransformMakeTranslation(0, self.tableView.parallaxHeader.progress*30);
    }
}

#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  arrValue.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMEmployeeDetailscell *cell = (HRMEmployeeDetailscell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMEmployeeDetailscell class])];
    cell.lblTtile.text = arrTile[indexPath.row];
    cell.lblValue.text =arrValue[indexPath.row];

    return cell;
}

#pragma mark- floatMenuDelegate
-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{ 
    if (![self accessPermitForIndex:row]) {
        [HRMToast showWithMessage:NOT_ALLOWED];
        return;
    }
    
    if(row == 0)
    {
        // call pin api
        [UIAlertView showWithTextFieldAndTitle:ALERT_TITLE_APPRAISAL message:APPRAISAL_PIN cancelButtonTitle:nil otherButtonTitles:@[CANCEL_BUTTON,OK_BUTTON] withCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            switch (buttonIndex) {
                  
                case 1:
                {
                    NSString *strPin = [alertView textFieldAtIndex:0].text;
                    
                    if([strPin validateWithString:APPRAISAL_PIN])
                    {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                    [[HRMAPIHandler handler]paySlipPinVerifiedWithPin:strPin WithSuccess:^(NSDictionary *responseDict) {
                        HRMAppraisalDetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMAppraisalDetailsViewController class])];
                        detailVC.dictEmployeeDetails =  _employeeDetails;
                        [self.navigationController pushViewController:detailVC animated:YES];
                        detailVC.employeeIncreamentID = [_employeeDetails valueForKey:@"id"];
                        [HRMNavigationalHelper sharedInstance].currentViewController = detailVC;
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
    else if(row == 1)
    {
        HRMReimbursementEmplListViewController *reimbursementViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HRMReimbursementEmplListViewController"];
        reimbursementViewController.addButtonStatus = eAddButtonHide;
        reimbursementViewController.individualEmployeeId = [_employeeDetails valueForKey:@"id"];
        [self.navigationController pushViewController:reimbursementViewController animated:YES];
       
        // [HRMHelper sharedInstance].menuType = reimbursement;
    }
    else if(row == 2)
    {
        HRMEmpLeaveListViewController *leaveViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HRMEmpLeaveListViewController"];
        leaveViewController.addButtonStatus = eAddButtonHide;
        leaveViewController.individualEmployeeId = [_employeeDetails valueForKey:@"id"];
        [self.navigationController pushViewController:leaveViewController animated:YES];
       // [HRMHelper sharedInstance].menuType = leaveApplication;

    }
    else if(row == 3)
    {
        HRMEmpTimeSheetViewController *empTimeSheetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HRMEmpTimeSheetViewController"];
        empTimeSheetViewController.addButtonStatus = eAddButtonHide;
        empTimeSheetViewController.individualEmployeeId = [_employeeDetails valueForKey:@"id"];
        [self.navigationController pushViewController:empTimeSheetViewController animated:YES];
        // [HRMHelper sharedInstance].menuType = timeSheet;
    }
    NSLog(@" Selct Index :%ld",(long)row);
}

-(BOOL)accessPermitForIndex:(NSInteger)index
{
    if (index == 0 && [OBJ_FOR_KEY(kModulePermit)[@"timesheet"] boolValue])
        return YES;
    else if (index == 1 && [OBJ_FOR_KEY(kModulePermit)[@"leave"] boolValue])
        return YES;
    else if (index == 2 && [OBJ_FOR_KEY(kModulePermit)[@"reimbursement"] boolValue])
        return YES;
    else if (index == 3 && [OBJ_FOR_KEY(kModulePermit)[@"appraisal"] boolValue])
        return YES;
    
    return NO;
}

#pragma mark- User Define Function

-(void)lblShowAndHide
{
    [headerView.lblEmpIDWithDepatment setHidden:NO];
    [headerView.lblDesigner setHidden:NO];
}

-(void)playSlipPinVerifiedWithPain:(NSString *)strPin WithSuccess:(void (^)(bool result))success
{
    
    
}
@end