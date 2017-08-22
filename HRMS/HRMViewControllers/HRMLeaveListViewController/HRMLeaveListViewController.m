//
//  HRMLeaveListViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 01/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMLeaveListViewController.h"
#import "HRMLeaveListTableViewCell.h"
#import "HRMLeaveDetailsViewController.h"
#import "HRMReimbursementDetailViewController.h"

@interface HRMLeaveListViewController ()
{
    UISearchBar *searchBarEmployee;
    NSMutableArray *arrayEmployeeList;
    NSInteger pageNumber, totalCount;
     BOOL isSearchBtnPress;
}
@end

@implementation HRMLeaveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSearchBtnPress = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [[HRMHelper sharedInstance] setBackButton:NO];
    if ([HRMHelper sharedInstance].menuType == leaveApplication)
    {
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = LEAVE_LIST;
    }
    else if ([HRMHelper sharedInstance].menuType == reimbursement)
    {
        [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = REIMBURSEMENT_LIST;
    }
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kSearchButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchBar) name:kShowSearchBar object:nil];
    pageNumber = 1;
    arrayEmployeeList = [NSMutableArray new];
    [self callAPIWithPageCount:@"25" pageNumber:[NSString stringWithFormat:@"%ld", (long)pageNumber] searchText:@""];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        [_tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        searchBarEmployee.transform = CGAffineTransformMakeScale(0.02, 0.02);
        [searchBarEmployee removeFromSuperview];
        CGRect fram = _tblLeaveList.frame;
        if(searchBarEmployee)
            fram.origin.y = CGRectGetMinY(_tblLeaveList.frame)-44.0;
        
        _tblLeaveList.frame = fram;
        searchBarEmployee = nil;
    }];
}

#pragma  mark - Search Bar

-(void)showSearchBar
{
    if(!searchBarEmployee)
        [self setSearchBar];
    
    [self.view addSubview:searchBarEmployee];
    _tblLeaveList.translatesAutoresizingMaskIntoConstraints = YES;
    [UIView animateWithDuration:0.25 animations:^{
        searchBarEmployee.transform = CGAffineTransformIdentity;
        [_tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, 44.0, 0)];
        CGRect fram = _tblLeaveList.frame;
        fram.origin.y = 44.0;
        _tblLeaveList.frame = fram;
    }];
}

-(void)setSearchBar
{
    searchBarEmployee = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44.0)];
    [searchBarEmployee setPlaceholder:kSearchEmployee];
    searchBarEmployee.translatesAutoresizingMaskIntoConstraints = YES;
    searchBarEmployee.clipsToBounds = YES;
    searchBarEmployee.transform = CGAffineTransformMakeScale(0.02, 0.02);
    searchBarEmployee.delegate = self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
 if ((searchText == (id)[NSNull null] || searchText.length == 0 ))
    {
        [searchBar resignFirstResponder];
        searchText = @"";
        pageNumber = 1;
        if(isSearchBtnPress)
        {
            isSearchBtnPress = NO;
        [arrayEmployeeList removeAllObjects];
        [self callAPIWithPageCount:@"25" pageNumber:[NSString stringWithFormat:@"%ld", (long)pageNumber] searchText:searchText];
        }
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isSearchBtnPress = YES;
    [searchBar resignFirstResponder];
    [arrayEmployeeList removeAllObjects];
    [self callAPIWithPageCount:@"25" pageNumber:@"1" searchText:searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
  
  
    [_tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, 250, 0)];

 
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

#pragma mark - Footer View

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
        [_tblLeaveList.tableFooterView setHidden:!isSet];
        _tblLeaveList.tableFooterView = viewContent;
        loading.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(10, 0), 0.01, 0.01);
        activity.transform = CGAffineTransformMakeTranslation(-30, 0);
        [_tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, 60.0, 0)];
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
            [_tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } completion:^(BOOL finished) {
            [viewContent removeFromSuperview];
            [_tblLeaveList.tableFooterView setHidden:!isSet];
            _tblLeaveList.tableFooterView = nil;
        }];
    }
}

#pragma mark - Call API

-(void)callAPIWithPageCount:(NSString *)pageCount pageNumber:(NSString *)page searchText:(NSString *)searchText
{
    
    
    if ([HRMHelper sharedInstance].menuType == leaveApplication)
    {
        [[HRMAPIHandler handler] getLeaveListOfficialWithEmployeeId:@"" pageCount:pageCount pageNumber:page searchText:searchText WithSuccess:^(NSDictionary *responseDict) {
          //  [arrayEmployeeList addObjectsFromArray:responseDict[@"leaves"]];
                [responseDict [@"leaves"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayEmployeeList addObject:obj];
                totalCount = (int)[responseDict[@"totalCount"]integerValue];
                    if (totalCount != [arrayEmployeeList count]) {
                        [self.tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, IS_IPAD ? 60 : 30, 0)];
                    }else
                        [self.tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
               }];
 
            [self showNorecord];
            [_tblLeaveList reloadData];
            [self setupFooterView:NO];
        } failure:^(NSError *error) {
            [self setupFooterView:NO];
    
        }];
        
    }
    else if ([HRMHelper sharedInstance].menuType == reimbursement)
    {
        [[HRMAPIHandler handler] getReimbursementListOfficialWithPageCount:pageCount pageNumber:page searchText:searchText employeeId:@"" WithSuccess:^(NSDictionary *responseDict) {
           // [arrayEmployeeList addObjectsFromArray:responseDict[@"reimbursements"]];
            [responseDict [@"reimbursements"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayEmployeeList addObject:obj];
                 totalCount = (int)[responseDict[@"totalCount"]integerValue];
            }];
             
           
            [self showNorecord];
            [_tblLeaveList reloadData];
            [self setupFooterView:NO];
        } failure:^(NSError *error) {
            [self setupFooterView:NO];
        }];
    }
 }

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayEmployeeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMLeaveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMLeaveListTableViewCell class])];
        if ([HRMHelper sharedInstance].menuType == reimbursement)
        cell.viewApplyOnBg.hidden = NO;
    
    [cell setDatasource:[arrayEmployeeList objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark- UITableViewDelegete

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
    if ([arrayEmployeeList indexOfObject:[arrayEmployeeList lastObject]] != totalCount-1 && (scrollOffset + scrollViewHeight == scrollContentSizeHeight+ IS_IPAD ? 60 : 30) && scrollOffset > 0)
    {
        [self setupFooterView:YES];
        [self callAPIWithPageCount:@"25" pageNumber:[NSString stringWithFormat:@"%d",++pageNumber] searchText:strSearchKye];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([HRMHelper sharedInstance].menuType == leaveApplication)
        return 230;
    else
       return 245;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([HRMHelper sharedInstance].menuType == leaveApplication)
    {
        HRMLeaveDetailsViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMLeaveDetailsViewController class])];
        detailVC.leaveDetails = arrayEmployeeList[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if ([HRMHelper sharedInstance].menuType == reimbursement)
    {
        HRMReimbursementDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMReimbursementDetailViewController class])];
        detailVC.reimbursementDetails = arrayEmployeeList[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark-: Key bord notifications
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, kbSize.height+40, 0)];
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
 [self.tblLeaveList setContentInset:UIEdgeInsetsMake(0, 0, 44.0, 0)];
}
#pragma mark-
#pragma NO record found
-(void)showNorecord
{
    UILabel *  noRecordLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    if(arrayEmployeeList.count > 0){
        self.tblLeaveList.scrollEnabled = YES;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.backgroundColor = [UIColor redColor];
        for(id lbl in [self.tblLeaveList subviews])
        {
            if([lbl isKindOfClass:[UILabel class]])
                [lbl removeFromSuperview];
        }
    }
    else{
         self.tblLeaveList.scrollEnabled = NO;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
        noRecordLbl.font =  FONT_REGULAR(IS_IPAD ? 25 : 18);
        noRecordLbl.textColor = [UIColor blackColor];
        [noRecordLbl setBackgroundColor:[UIColor clearColor]];
        [noRecordLbl setText:@"No records found"];
        
        CGRect rect = _tblLeaveList.frame;
        [noRecordLbl setTextAlignment:NSTextAlignmentCenter];
        [noRecordLbl setFrame:rect];
        [_tblLeaveList addSubview:noRecordLbl];
    }
    
}

@end
