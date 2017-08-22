//
//  HRMInterviewListViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 06/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMInterviewListViewController.h"
#import "HRMInterviewListCell.h"
#import "HRMInterviewDetailViewController.h"

@interface HRMInterviewListViewController ()
{
    NSMutableArray *arrayInterviewList;
        int totalCount;
    int fixedPageLimit;
    int   pageNumberInc;
    BOOL isSearchBtnPress;
    
}
@end

@implementation HRMInterviewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSearchBtnPress = NO;
    fixedPageLimit = 25;
    pageNumberInc = 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[HRMHelper sharedInstance] setBackButton:NO];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = INTERVIEW;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:NO];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kAddButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchBar) name:kShowSearchBar object:nil];
    arrayInterviewList = [NSMutableArray new];
    [self apiCallWithPageCount:[NSString stringWithFormat:@"%d",fixedPageLimit] pageNumber:[NSString stringWithFormat:@"%d",pageNumberInc] searchText:@""];
    [_tblInterViewList reloadData];
    // search bar
    [UIView animateWithDuration:0.25 animations:^{
        [_tblInterViewList setContentInset:UIEdgeInsetsMake(0.0, 0, 0, 0)];
        searchBar.transform = CGAffineTransformMakeScale(0.02, 0.02);
        [searchBar removeFromSuperview];
        CGRect fram = _tblInterViewList.frame;
        if(searchBar)
            fram.origin.y = CGRectGetMinY(_tblInterViewList.frame)-44.0;
        
        _tblInterViewList.frame = fram;
        searchBar = nil;
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchBar) name:kShowSearchBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma  mark - Search Bar
-(void)showSearchBar
{
    if(!searchBar)
    [self setSearchBar];
    [self.view.superview addSubview:searchBar];
    [UIView animateWithDuration:0.25 animations:^{
        searchBar.transform = CGAffineTransformIdentity;
        CGRect fram = _tblInterViewList.frame;
        fram.origin.y = [[HRMHelper sharedInstance] menuType] == interview ? 44.0 : 50;
        _tblInterViewList.frame = fram;
    }];
}

-(void)setSearchBar
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, [[HRMHelper sharedInstance] menuType] == interview ? 0 : 92, CGRectGetWidth(self.view.bounds), 44.0)];
    [searchBar setPlaceholder:kSearchEmployee];
    searchBar.translatesAutoresizingMaskIntoConstraints = YES;
    searchBar.clipsToBounds = YES;
    searchBar.transform = CGAffineTransformMakeScale(0.02, 0.02);
    searchBar.delegate = self;
    

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)pSearchBar
{
    isSearchBtnPress = YES;
    [pSearchBar resignFirstResponder];
    [arrayInterviewList removeAllObjects];
    pageNumberInc = 1;
    [self apiCallWithPageCount:[NSString stringWithFormat:@"%d",fixedPageLimit] pageNumber:[NSString stringWithFormat:@"%d",pageNumberInc] searchText:pSearchBar.text];
    [_tblInterViewList reloadData];

    
}

- (void)searchBar:(UISearchBar *)searchBarItems textDidChange:(NSString *)searchText
{
    if ((searchText == (id)[NSNull null] || searchText.length == 0 ))
    {
        [searchBarItems resignFirstResponder];
        searchText = @"";
        pageNumberInc = 1;
        if(isSearchBtnPress)
        {
        [arrayInterviewList removeAllObjects];
            isSearchBtnPress = NO;
        [_tblInterViewList reloadData];
    [self apiCallWithPageCount:[NSString stringWithFormat:@"%d",fixedPageLimit] pageNumber:[NSString stringWithFormat:@"%d",pageNumberInc] searchText:searchText];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Call

-(void)apiCallWithPageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText{
    if([pageNumber intValue]!=1 )
        [self setupFooterView:YES];
    [[HRMAPIHandler handler] getInterviewListWithPageCount:pageCount pageNumber:pageNumber searchText:searchText WithSuccess:^(NSDictionary *responseDict) {
        [responseDict[@"interviews"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            totalCount = (int)[responseDict[@"totalCount"]integerValue];
            [arrayInterviewList addObject:obj];
            [self setupFooterView:NO];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arrayInterviewList indexOfObject:[arrayInterviewList lastObject]] inSection:0];
            [_tblInterViewList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if (totalCount != [arrayInterviewList count]) {
                [_tblInterViewList setContentInset:UIEdgeInsetsMake(0, 0, IS_IPAD ? 60 : 30, 0)];
            }else
                [_tblInterViewList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        
        }];
       [self showNorecord];
    } failure:^(NSError *error) {
        [self setupFooterView:NO];
  

    }];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    _tblInterViewList.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height+40, 0);
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _tblInterViewList.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark-
#pragma loader In tableview footer
-(void)setupFooterView:(BOOL)isSet {
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), IS_IPAD ? 60 : 30)];
    viewContent.backgroundColor = [UIColor lightGrayColor];
    viewContent.alpha = 0.5;
    
    UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 100 : 100, 40)];
    loading.text = @"Loading...";
    loading.font = FONT_REGULAR(IS_IPAD ? 20 : 18);
    loading.textColor = [UIColor whiteColor];
    [loading setCenter:CGPointMake(CGRectGetMidX(viewContent.bounds)-10, CGRectGetMidY(viewContent.bounds))];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [activity setCenter:CGPointMake(CGRectGetMidX(viewContent.bounds)+30, CGRectGetMidY(viewContent.bounds))];
    [activity startAnimating];
    
    if (isSet) {
        [viewContent addSubview:loading];
        [viewContent addSubview:activity];
        [_tblInterViewList.tableFooterView setHidden:!isSet];
        _tblInterViewList.tableFooterView = viewContent;
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
            [_tblInterViewList.tableFooterView setHidden:!isSet];
            _tblInterViewList.tableFooterView = nil;
        }];
    }
}
#pragma mark -
#pragma mark- Table View Delegete

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayInterviewList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMInterviewListCell *cell = (HRMInterviewListCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMInterviewListCell class])];
    [cell setDatasource:arrayInterviewList[indexPath.row]];

    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:233.0f/255.0 green:233.0f/255.0 blue:233.0f/255.0 alpha:1.0f];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMInterviewDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HRMInterviewDetailViewController class])];
    detailVC.interviewDetails = arrayInterviewList[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
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
    if ([arrayInterviewList indexOfObject:[arrayInterviewList lastObject]] != totalCount-1 && (scrollOffset + scrollViewHeight == scrollContentSizeHeight+ IS_IPAD ? 60 : 30) && scrollOffset > 0)
    {
       
[self apiCallWithPageCount:[NSString stringWithFormat:@"%d",fixedPageLimit] pageNumber:[NSString stringWithFormat:@"%d",++pageNumberInc] searchText:strSearchKye];
    }
}

-(void)showNorecord
{
    UILabel *  noRecordLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    if(arrayInterviewList.count > 0){
        self.tblInterViewList.scrollEnabled = YES;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.backgroundColor = [UIColor redColor];
        for(id lbl in [self.tblInterViewList subviews])
        {
            if([lbl isKindOfClass:[UILabel class]])
                [lbl removeFromSuperview];
        }
    }
    else{
            self.tblInterViewList.scrollEnabled = NO;
        noRecordLbl.translatesAutoresizingMaskIntoConstraints = YES;
        noRecordLbl.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
        noRecordLbl.font =  FONT_REGULAR(IS_IPAD ? 25 : 18);
        noRecordLbl.textColor = [UIColor blackColor];
        [noRecordLbl setBackgroundColor:[UIColor clearColor]];
        [noRecordLbl setText:@"No records found"];
        
        CGRect rect = _tblInterViewList.frame;
        [noRecordLbl setTextAlignment:NSTextAlignmentCenter];
        [noRecordLbl setFrame:rect];
        [self.view addSubview:noRecordLbl];
    }
    
}

@end
