//
//  HRMTimSheetViewController.m
//
//
//  Created by Priyam Dutta on 09/10/15.
//
//

#import "HRMTimSheetViewController.h"
#import "HRMTimeSheetCell.h"
#import "HRMDatePickerView.h"
#import "HRMViewTimeSheetViewController.h"
#import "HRMTimeSheetCorrectionViewController.h"
#import "HRMPicker.h"

@implementation HRMTimSheetViewController
{
    int PageNumber;
    int pageCount;
    NSMutableArray *arrTimeSheet;
    NSArray *arrayDepartments;
    NSString *strDepartmentID;
    NSString *selectedMonths;
    NSString *selectedYear;
    int totalCount;
    CGSize kbSize;
     BOOL isSearchBtnPress;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isSearchBtnPress = NO;
    arrTimeSheet = [[NSMutableArray alloc]init];
    PageNumber = 1;
    pageCount =   25;
    strDepartmentID = @"";
    selectedYear = @"";
    selectedMonths = @"";
    if ([[HRMHelper sharedInstance] menuType] == timeSheet)
    [self apiCall];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)apiCall
{   [arrTimeSheet removeAllObjects];
    [tbleTimeSheet reloadData];
    [self getEmpTimSheetViewPageNumber:[NSString stringWithFormat:@"%d",1] strPageCount:[NSString stringWithFormat:@"%d",pageCount] strMonth:[[NSDate date] getMonthYearStringFromDate] strYear:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] getYear]] strSearchKey:@"" strEmpID:@"" department:strDepartmentID];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[HRMHelper sharedInstance] menuType] == tmesheetCorrection)
    [self apiCall];
    
    if ([[HRMHelper sharedInstance] menuType] == tmesheetCorrection) {
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = TIMESHEET_CORRECTION;
        viewSectionConstHight.constant = 0.0;
    }else{
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = TIMESHEET;
    }
    [[HRMHelper sharedInstance]setBackButton:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchBar) name:kShowSearchBar object:nil];
    
    [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kSearchButton];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
    [buttonMonth setTitle:[[NSDate date] getMonthYearStringFromDate] forState:UIControlStateNormal];
    [buttonYear setTitle:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] getYear]] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        [tbleTimeSheet setContentInset:UIEdgeInsetsMake(0.0, 0, 0, 0)];
        searchBar.transform = CGAffineTransformMakeScale(0.02, 0.02);
        [searchBar removeFromSuperview];
        CGRect fram = tbleTimeSheet.frame;
        if(searchBar)
            fram.origin.y = CGRectGetMinY(tbleTimeSheet.frame)-44.0;
        
        tbleTimeSheet.frame = fram;
        searchBar = nil;
    }];
}

-(void)setupUI
{
    buttonYear.layer.borderColor = LIGHT_BODER_COLOR.CGColor;
    buttonYear.layer.borderWidth = 1.0f;
    [buttonYear setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonYear.frame), 0, 0)];
    buttonMonth.layer.borderColor = LIGHT_BODER_COLOR.CGColor;
    buttonMonth.layer.borderWidth = 1.0f;
    [buttonMonth setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonMonth.bounds), 0, 0)];
    buttonDepartment.layer.borderColor = LIGHT_BODER_COLOR.CGColor;
    buttonDepartment.layer.borderWidth = 1.0f;
    [buttonDepartment setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonDepartment.bounds), 0, 0)];
    [buttonDepartment addTarget:self action:@selector(actionDepartment:) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth addTarget:self action:@selector(actionMonth:) forControlEvents:UIControlEventTouchUpInside];
    [buttonYear addTarget:self action:@selector(actionYear:) forControlEvents:UIControlEventTouchUpInside];
    if(SCREEN_HEIGHT>1024)
    {
        [buttonMonth setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonMonth.frame)-CGRectGetWidth(buttonMonth.titleLabel.frame)+CGRectGetWidth(buttonMonth.imageView.frame)+10, 0,0)];
        [buttonYear setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonYear.frame)-CGRectGetWidth(buttonYear.titleLabel.frame)+CGRectGetWidth(buttonMonth.imageView.frame)+10, 0,0)];
        [buttonDepartment setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonDepartment.frame)-CGRectGetWidth(buttonMonth.titleLabel.frame)+CGRectGetWidth(buttonDepartment.imageView.frame)+10, 0,0)];
    }
    else
    {
        [buttonMonth setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonMonth.frame)-CGRectGetWidth(buttonMonth.imageView.frame)-40, 0,0)];
        [buttonYear setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonYear.frame)-CGRectGetWidth(buttonYear.imageView.frame)-40, 0,0)];
        [buttonDepartment setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(buttonDepartment.frame)-CGRectGetWidth(buttonDepartment.imageView.frame)-40, 0,0)];
    }
}

#pragma  mark - Search Bar
-(void)showSearchBar
{
    if(!searchBar)
    [self setSearchBar];
    [self.view.superview addSubview:searchBar];
    [UIView animateWithDuration:0.25 animations:^{
        searchBar.transform = CGAffineTransformIdentity;
        CGRect fram = tbleTimeSheet.frame;
        fram.origin.y = [[HRMHelper sharedInstance] menuType] == tmesheetCorrection ? 44.0 : 50;
        tbleTimeSheet.frame = fram;
    }];
}

-(void)setSearchBar
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, [[HRMHelper sharedInstance] menuType] == tmesheetCorrection ? 40 : 92, CGRectGetWidth(self.view.bounds), 44.0)];
    [searchBar setPlaceholder:kSearchEmployee];
    searchBar.translatesAutoresizingMaskIntoConstraints = YES;
    searchBar.clipsToBounds = YES;
    searchBar.transform = CGAffineTransformMakeScale(0.02, 0.02);
    searchBar.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)pSearchBar
{       [arrTimeSheet removeAllObjects];
        PageNumber = 1;
        isSearchBtnPress = YES;
        [self getEmpTimSheetViewPageNumber:[NSString stringWithFormat:@"%d",PageNumber] strPageCount:[NSString stringWithFormat:@"%d",pageCount]strMonth:selectedMonths strYear:selectedYear strSearchKey:pSearchBar.text strEmpID:@"" department:strDepartmentID];
 
    [tbleTimeSheet reloadData];
     [pSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBarItems textDidChange:(NSString *)searchText
{
    if ((searchText == (id)[NSNull null] || searchText.length == 0 ))
    {
        searchText = @"";
        PageNumber = 1;
        if(isSearchBtnPress)
        {
          [arrTimeSheet removeAllObjects];
        [searchBarItems resignFirstResponder];
            isSearchBtnPress = NO;
        [tbleTimeSheet reloadData];
        [self getEmpTimSheetViewPageNumber:[NSString stringWithFormat:@"%d",PageNumber] strPageCount:[NSString stringWithFormat:@"%d",pageCount]strMonth:selectedMonths strYear:selectedYear strSearchKey:searchText strEmpID:@"" department:strDepartmentID];
        }
       
    }
  
}


#pragma mark - Table View Delegete

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTimeSheet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMTimeSheetCell *cell = (HRMTimeSheetCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMTimeSheetCell class])];
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = UIColorRGB(233.0, 233.0, 233.0, 1.0);
    [cell setDatasource:arrTimeSheet[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if ([[HRMHelper sharedInstance] menuType] == tmesheetCorrection) {
        HRMTimeSheetCorrectionViewController *timesheetCorrectionVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMTimeSheetCorrectionViewController class])];
        timesheetCorrectionVC.arrTimeSheetData = [arrTimeSheet objectAtIndex:indexPath.row];
        [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:timesheetCorrectionVC animated:YES];
    }else{
        HRMViewTimeSheetViewController *timeSheetVC = [[[HRMNavigationalHelper sharedInstance] mainStoryboard] instantiateViewControllerWithIdentifier:NSStringFromClass([HRMViewTimeSheetViewController class])];
          timeSheetVC.arrTimeSheetData = [arrTimeSheet objectAtIndex:indexPath.row];
        [[[HRMNavigationalHelper sharedInstance] contentNavController] pushViewController:timeSheetVC animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    NSString * strSearchKye = searchBar.text;
    if ((strSearchKye == (id)[NSNull null] || strSearchKye.length == 0 ))
    {
        strSearchKye = @"";
    }
  if ([arrTimeSheet indexOfObject:[arrTimeSheet lastObject]] != totalCount-1 && (scrollOffset + scrollViewHeight == scrollContentSizeHeight+ IS_IPAD ? 60 : 30) && scrollOffset > 0)
    {
   
        [self getEmpTimSheetViewPageNumber:[NSString stringWithFormat:@"%d",++PageNumber] strPageCount:[NSString stringWithFormat:@"%d",pageCount]strMonth:selectedMonths strYear:selectedYear strSearchKey:strSearchKye strEmpID:@"" department:strDepartmentID];
    }

}
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    tbleTimeSheet.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height+40, 0);
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
   tbleTimeSheet.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
}
-(void)setupFooterView:(BOOL)isSet {
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), IS_IPAD ? 60 : 30)];
    viewContent.backgroundColor = [UIColor lightGrayColor];
    viewContent.alpha = 0.5;
    
    UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 100 : 100, 40)];
    loading.text = @"Loading...";
    loading.font = FONT_REGULAR(IS_IPAD ? 20 : 18);
    loading.textColor = [UIColor whiteColor];
    [loading setCenter:CGPointMake(CGRectGetMidX(viewContent.bounds)-25, CGRectGetMidY(viewContent.bounds))];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [activity setCenter:CGPointMake(CGRectGetMidX(viewContent.bounds)+30, CGRectGetMidY(viewContent.bounds))];
    [activity startAnimating];
    
    if (isSet) {
        [viewContent addSubview:loading];
        [viewContent addSubview:activity];
        [tbleTimeSheet.tableFooterView setHidden:!isSet];
        tbleTimeSheet.tableFooterView = viewContent;
        loading.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(10, 0), 0.01, 0.01);
        activity.transform = CGAffineTransformMakeTranslation(-30, 0);
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewContent.alpha = 1.0;
            loading.transform = CGAffineTransformIdentity;
            activity.transform = CGAffineTransformIdentity;
            } completion:nil];
    }else{
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewContent.alpha = 0.5;
            loading.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(10, 0), 0.01, 0.01);
            activity.transform = CGAffineTransformMakeTranslation(-30, 0);
        } completion:^(BOOL finished) {
            [viewContent removeFromSuperview];
            [tbleTimeSheet.tableFooterView setHidden:!isSet];
            tbleTimeSheet.tableFooterView = nil;
        }];
    }
}

#pragma mark - Text Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark-
#pragma mark- Button Action
- (IBAction)actionApplyFilter:(UIButton *)sender {
    isSearchBtnPress = YES;
    [searchBar resignFirstResponder];
    NSString *strSearchKye = searchBar.text;
    [arrTimeSheet removeAllObjects];
    [tbleTimeSheet reloadData];
if ((strSearchKye == nil || [strSearchKye isKindOfClass:[NSNull class]]))
        strSearchKye = @"";
    PageNumber = 1;
    [self getEmpTimSheetViewPageNumber:[NSString stringWithFormat:@"%d",PageNumber] strPageCount:[NSString stringWithFormat:@"%d",pageCount]strMonth:selectedMonths strYear:selectedYear strSearchKey:strSearchKye strEmpID:@"" department:strDepartmentID];
}

- (IBAction)actionDepartment:(UIButton *)sender
{
    NSMutableArray *arrayDept = [NSMutableArray new];
    [arrayDept addObject:@"All Departments"];
    [arrayDepartments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayDept addObject:obj[@"department"]];
    }];
    if (arrayDept.count > 0) {
        [HRMPicker showWithArrayWithSelectedIndex:[arrayDept containsObject:sender.titleLabel.text] ? [arrayDept indexOfObject:sender.titleLabel.text] : 0 andArray:[arrayDept mutableCopy] didSelect:^(NSString *data, NSInteger index) {
            [sender setTitle:data forState:UIControlStateNormal];
            if (index == 0)
                strDepartmentID = @"";
            else
                strDepartmentID = [arrayDepartments objectAtIndex:index-1][@"departmentId"];
        }];
    }else [HRMToast showWithMessage:NO_DEPARTMENTS];
}
-(void)actionMonth:(UIButton *)sender
{   
    [HRMPicker showWithArrayWithSelectedIndex:[[NSDate getAllMonths] indexOfObject:sender.titleLabel.text] andArray:[NSDate getAllMonths] didSelect:^(NSString *data, NSInteger index) {
    [sender setTitle:data forState:UIControlStateNormal];
    selectedMonths = data;
}];
    
}
-(void)actionYear:(UIButton *)sender
{   [HRMPicker showWithArrayWithSelectedIndex:[[NSDate getAllYearList] indexOfObject:sender.titleLabel.text] andArray:[NSDate getAllYearList] didSelect:^(NSString *data, NSInteger index) {
    [sender setTitle:data forState:UIControlStateNormal];
    selectedYear = data;
}];
}
#pragma mark-
#pragma TableViewShowAnd Hide.
-(void)tableViewShowHide
{
    [self setupFooterView:NO];
    if(arrTimeSheet.count > 0)
    [tbleTimeSheet setHidden:NO];
    else
    [tbleTimeSheet setHidden:YES];
}

#pragma mark- API Call
#pragma mark  EmpTimSheet  AND Emp Correction
-(void)getEmpTimSheetViewPageNumber:(NSString *)strPageNumber strPageCount:(NSString *)strPageCount strMonth:(NSString *)strMonth strYear:(NSString *)strYear strSearchKey:(NSString *)strSearchKey strEmpID:(NSString *)strEmpID department:(NSString *)department
{
    if([strPageNumber intValue]!=1 )
        [self setupFooterView:YES];
    // * This API call When menu is timeSheet */
    if([HRMHelper sharedInstance].menuType == timeSheet)
    {   if(strYear.length == 0)
        strYear =[NSString stringWithFormat:@"%ld",(long)[[NSDate date] getYear]];
        if(strMonth.length == 0)
            strMonth =[[NSDate date] getMonthYearStringFromDate];
        [[HRMAPIHandler handler]getAllEmployeeTimesheetWithEmpID:strEmpID department:department month:strMonth year:strYear pageCount:strPageCount pageNumber:strPageNumber searchText:strSearchKey withSuccess:^(NSDictionary *responseDict) {
            [responseDict [@"timesheet"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arrTimeSheet addObject:obj];
                   totalCount = (int)[responseDict[@"totalCount"]integerValue];
                    [self setupFooterView:NO];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arrTimeSheet indexOfObject:[arrTimeSheet lastObject]] inSection:0];
                    [tbleTimeSheet insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    if (totalCount != [arrTimeSheet count]) {
                        [tbleTimeSheet setContentInset:UIEdgeInsetsMake(0, 0, IS_IPAD ? 60 : 30, 0)];
                    }else
                        [tbleTimeSheet setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                    }];
                [self tableViewShowHide];
                [self getDepartmentsInterviewList];
            }
             
    failure:^(NSError *error) {
    [self setupFooterView:NO];
    }];
    
    }
    // * This API call When menu is tmesheetCorrection */
    if([HRMHelper sharedInstance].menuType == tmesheetCorrection)
    {  if([strPageNumber intValue]!=1 )
        [self setupFooterView:YES];
     [[HRMAPIHandler handler]getEmployeeTimesheetCorrection:strPageCount pageNumber:strPageNumber searchText:strSearchKey withSuccess:^(NSDictionary *responseDict) {
            [responseDict [@"timesheet"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrTimeSheet addObject:obj];
                totalCount = (int)[responseDict[@"totalCount"]integerValue];
                [self setupFooterView:NO];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arrTimeSheet indexOfObject:[arrTimeSheet lastObject]] inSection:0];
                    [tbleTimeSheet insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    if (totalCount != [arrTimeSheet count]) {
                        [tbleTimeSheet setContentInset:UIEdgeInsetsMake(0, 0, IS_IPAD ? 60 : 30, 0)];
                    }else
                        [tbleTimeSheet setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                }];
            [self tableViewShowHide];
            
        } failure:^(NSError *error) {
        [self setupFooterView:NO];
        }];
    
    }
}
#pragma mark- Get Departments
-(void)getDepartmentsInterviewList
{
    /* Call api to get getDepartments details */
    if (!arrayDepartments || !arrayDepartments.count){
        [[HRMAPIHandler handler] getDepartmentsForInterviewWithSuccess:^(NSDictionary *responseDict) {
            arrayDepartments = [NSArray arrayWithArray:responseDict[@"departments"]];
        } failure:^(NSError *error) {
        }];
    }
}

@end
