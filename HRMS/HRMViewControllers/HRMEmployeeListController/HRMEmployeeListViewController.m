//
//  HRMEmployeeListViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 01/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMEmployeeListViewController.h"
#import "HRMEmployeeListCell.h"
#import "HRMEmployeeDetailsViewController.h"
#import "HRMAppraisalDetailsViewController.h"

@interface HRMEmployeeListViewController ()
{
    NSMutableArray *arrEmployeeList;
    int totalCount, pageNumber;
    int fixedPageCount;
    BOOL isSearchBtnPress;
}
@end

@implementation HRMEmployeeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSearchBtnPress = NO;
    fixedPageCount = 25;
    pageNumber = 1;
    arrEmployeeList = [[NSMutableArray alloc]init];
    [tblEmployeeList reloadData];
     if (!([HRMHelper sharedInstance].menuType == appraisal))
    [self callAPIWithPageCount:[NSString stringWithFormat:@"%d",fixedPageCount] pagenumber:@"1" andSearchText:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    if ([HRMHelper sharedInstance].menuType == appraisal)
    {  [arrEmployeeList removeAllObjects];
        [tblEmployeeList reloadData];
         [self callAPIWithPageCount:[NSString stringWithFormat:@"%d",fixedPageCount] pagenumber:@"1" andSearchText:@""];
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = APPRAISAL_LIST;
        [[HRMHelper sharedInstance]setBackButton:NO];
    }
    else if ([HRMHelper sharedInstance].menuType == employee){
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = EMPLOYEE_LIST;
        [[HRMHelper sharedInstance]setBackButton:NO];
    }
    else{
        [tblEmployeeList setContentInset:UIEdgeInsetsMake(IS_IPAD ? 80 : 50, 0, 0, 0)];
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissView)];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showLeaveSearch)];
        [self.navigationItem setLeftBarButtonItem:leftBarButton];
        [self.navigationItem setRightBarButtonItem:rightBarButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchBar) name:kShowSearchBar object:nil];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kSearchButton];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        [tblEmployeeList setContentInset:UIEdgeInsetsMake(0.0, 0, 0, 0)];
        searchBarEmployee.transform = CGAffineTransformMakeScale(0.02, 0.02);
        [searchBarEmployee removeFromSuperview];
        CGRect fram = tblEmployeeList.frame;
        if(searchBarEmployee)
            fram.origin.y = CGRectGetMinY(tblEmployeeList.frame)-44.0;
        
        tblEmployeeList.frame = fram;
        searchBarEmployee = nil;
    }];

}

-(void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - Search Bar

-(void)showSearchBar
{
    if(!searchBarEmployee)
    [self.view.superview addSubview:[self searchBar]];
    [UIView animateWithDuration:0.25 animations:^{
        searchBarEmployee.transform = CGAffineTransformIdentity;
        CGRect fram = tblEmployeeList.frame;
        fram.origin.y = [[HRMHelper sharedInstance] menuType] == employee ? 44.0 : 50;
        tblEmployeeList.frame = fram;
    }];
}

-(void)showLeaveSearch
{
    if (!searchBarEmployee) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:[self searchBar]];
        [UIView animateWithDuration:0.25 animations:^{
            searchBarEmployee.transform = CGAffineTransformIdentity;
            CGRect frame = tblEmployeeList.frame;
            frame.origin.y = 107;
            tblEmployeeList.frame = frame;
        }];
    }
}

-(UISearchBar *)searchBar
{
    if (([HRMHelper sharedInstance].menuType == appraisal) || ([HRMHelper sharedInstance].menuType == employee))
        searchBarEmployee = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44.0)];
    else
        searchBarEmployee = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 44.0)];
   
    [searchBarEmployee setPlaceholder:kSearchEmployee];
    searchBarEmployee.translatesAutoresizingMaskIntoConstraints = YES;
    searchBarEmployee.clipsToBounds = YES;
    searchBarEmployee.transform = CGAffineTransformMakeScale(0.02, 0.02);
    searchBarEmployee.delegate = self;
    return searchBarEmployee;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [arrEmployeeList removeAllObjects];
    pageNumber = 1;
    isSearchBtnPress = true;
    [self callAPIWithPageCount:[NSString stringWithFormat:@"%d",fixedPageCount] pagenumber:[NSString stringWithFormat:@"%d",pageNumber] andSearchText:searchBar.text];
    [tblEmployeeList reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ((searchText == (id)[NSNull null] || searchText.length == 0 ))
    {
        searchText = @"";
        pageNumber = 1;
      
        if (isSearchBtnPress) {
            [arrEmployeeList removeAllObjects];
            [tblEmployeeList reloadData];
            isSearchBtnPress = NO;
          [self callAPIWithPageCount:[NSString stringWithFormat:@"%d",fixedPageCount] pagenumber:[NSString stringWithFormat:@"%d",pageNumber] andSearchText:searchBar.text];
          }
    }
    
}

#pragma mark - Table View Footer Loader

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
        [tblEmployeeList.tableFooterView setHidden:!isSet];
        tblEmployeeList.tableFooterView = viewContent;
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
            [tblEmployeeList.tableFooterView setHidden:!isSet];
            tblEmployeeList.tableFooterView = nil;
        }];
    }
}

#pragma mark-
#pragma TableViewShowAnd Hide.

-(void)tableViewShowHide
{
    [self setupFooterView:NO];
    if(arrEmployeeList.count > 0)
        [tblEmployeeList setHidden:NO];
    else
         [tblEmployeeList setHidden:YES];
}

#pragma mark - UITableview Delegate and Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([HRMHelper sharedInstance].menuType == appraisal)
        return [arrEmployeeList count];
    else
        return [arrEmployeeList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[HRMHelper sharedInstance] menuType] == employee || [[HRMHelper sharedInstance] menuType] == appraisal) {
        return [[HRMHelper sharedInstance] menuType] == employee ? 127.0 : 176.0;
    }
    return IS_IPAD ? 80 : 50;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    NSString * strSearchKye = searchBarEmployee.text;
    if ((strSearchKye == (id)[NSNull null] || strSearchKye.length == 0 ))
    {
        strSearchKye = @"";
    }
    if ([arrEmployeeList indexOfObject:[arrEmployeeList lastObject]] != totalCount-1 && (((scrollOffset + scrollViewHeight) == scrollContentSizeHeight) + IS_IPAD ? 60 : 30) && scrollOffset > 0)
       {
      [self callAPIWithPageCount:[NSString stringWithFormat:@"%d",fixedPageCount] pagenumber:[NSString stringWithFormat:@"%d",++pageNumber]  andSearchText:strSearchKye];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMEmployeeListCell *cell;
    if (([[HRMHelper sharedInstance] menuType] == employee) || ([[HRMHelper sharedInstance] menuType] == appraisal)) {
        cell = (HRMEmployeeListCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMEmployeeListCell class])];
        if ([HRMHelper sharedInstance].menuType == appraisal)
        {
            cell.viewSeparator.hidden = YES;
            [cell setDatasource:arrEmployeeList[indexPath.row]];
        }
        else
        {
            [cell setDatasource:arrEmployeeList[indexPath.row]];
            cell.viewBasicPay.hidden = YES;
        }
        return cell;
    }else{
        cell = (HRMEmployeeListCell*)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@Leave", NSStringFromClass([HRMEmployeeListCell class])]];
        [cell setDatasource:arrEmployeeList[indexPath.row]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([HRMHelper sharedInstance].menuType == employee)
    {
        HRMEmployeeDetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMEmployeeDetailsViewController class])];
        detailVC.employeeDetails = arrEmployeeList[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
        [HRMNavigationalHelper sharedInstance].currentViewController = detailVC;
    }
    else if ([HRMHelper sharedInstance].menuType == appraisal)
    {
        HRMAppraisalDetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMAppraisalDetailsViewController class])];
        
        detailVC.arrAppraisalDetails =   [arrEmployeeList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
        [HRMNavigationalHelper sharedInstance].currentViewController = detailVC;
    }else{
        if(_leaveOfficerHandler)
            _leaveOfficerHandler([arrEmployeeList objectAtIndex:indexPath.row][@"fullName"], [arrEmployeeList objectAtIndex:indexPath.row][@"id"]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - API Call

-(void)callAPIWithPageCount:(NSString *)pageCount pagenumber:(NSString *)pagenumber andSearchText:(NSString *)searchText
{
    if([pagenumber intValue]!=1 )
        [self setupFooterView:YES];
    if ([[HRMHelper sharedInstance] menuType] == appraisal) {
     
        [[HRMAPIHandler handler]getAppraisalListWithEmployeeid:@"" pageCount:pageCount pageNumber:pagenumber searchText:searchText WithSuccess:^(NSDictionary *responseDict) {
            [responseDict [@"appraisals"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrEmployeeList addObject:obj];
                totalCount = (int)[responseDict[@"totalCount"]integerValue];
                [self setupFooterView:NO];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arrEmployeeList indexOfObject:[arrEmployeeList lastObject]] inSection:0];
                [tblEmployeeList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                if (totalCount != [arrEmployeeList count]) {
                    [tblEmployeeList setContentInset:UIEdgeInsetsMake(0, 0, IS_IPAD ? 60 : 30, 0)];
                }else
                    [tblEmployeeList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }];
            [self showNorecord];
        } failure:^(NSError *error) {
            
        }];
        
    }
    else{
        [[HRMAPIHandler handler] getEmployeeListWithPageCount:pageCount pageNumber:pagenumber andSearchText:searchText withSuccess:^(NSDictionary *responseDict) {
            [responseDict [@"employeelist"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrEmployeeList addObject:obj];
                totalCount = (int)[responseDict[@"totalCount"]integerValue];
                [self setupFooterView:NO];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arrEmployeeList indexOfObject:[arrEmployeeList lastObject]] inSection:0];
                [tblEmployeeList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             
                if (totalCount != [arrEmployeeList count]) {
                    [tblEmployeeList setContentInset:UIEdgeInsetsMake(0, 0, IS_IPAD ? 60 : 30, 0)];
                }else
                    [tblEmployeeList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }];
            
            [self showNorecord];
        } failure:^(NSError *error) {
            [self setupFooterView:NO];
        }];
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  tblEmployeeList.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height+40, 0);
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [tblEmployeeList setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
}

-(void)showNorecord
{
    UILabel *  noRecordLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    if(arrEmployeeList.count > 0){
        tblEmployeeList.scrollEnabled = YES;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.backgroundColor = [UIColor redColor];
        for(id lbl in [tblEmployeeList subviews])
        {
            if([lbl isKindOfClass:[UILabel class]])
                [lbl removeFromSuperview];
        }
    }
    else{
        tblEmployeeList.scrollEnabled = NO;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
        noRecordLbl.font =  FONT_REGULAR(IS_IPAD ? 25 : 18);
        noRecordLbl.textColor = [UIColor blackColor];
        [noRecordLbl setBackgroundColor:[UIColor clearColor]];
        [noRecordLbl setText:@"No records found"];
        
        CGRect rect = tblEmployeeList.frame;
        [noRecordLbl setTextAlignment:NSTextAlignmentCenter];
        [noRecordLbl setFrame:rect];
        [tblEmployeeList addSubview:noRecordLbl];
    }
    
}




@end
