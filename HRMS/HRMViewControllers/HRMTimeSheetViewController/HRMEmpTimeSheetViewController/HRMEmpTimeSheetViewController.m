//
//  HRMEmpTimeSheetViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMEmpTimeSheetViewController.h"
#import "HRMEmpTimeSheetCell.h"
#import "HRMEmployeeDetailsViewController.h"

@interface HRMEmpTimeSheetViewController ()
{
    NSMutableArray *arrayTimsheetList;
    NSInteger totalCount, pageNumber;
    NSDictionary *rules;
}
@end

@implementation HRMEmpTimeSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    arrayTimsheetList = [NSMutableArray new];
    rules = [NSDictionary new];
    pageNumber = 1;
    [arrayTimsheetList removeAllObjects];
    [tableTmesheetList reloadData];
    
    if(IS_IPAD){
        [[HRMHelper sharedInstance] setBackButton:YES];
        [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
        [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kAddButton];
    }
    else{
        [[HRMHelper sharedInstance] setBackButton:NO];
        [[[HRMNavigationalHelper sharedInstance] headerViewController] headerAddButton:kAddButton];
    }
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = TIMESHEET;
    
    if ([[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] objectAtIndex:[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] count]-2] isKindOfClass:[HRMEmployeeDetailsViewController class]]) {
         [[[HRMManager manager] requestSerializer] setValue:_individualEmployeeId forHTTPHeaderField:@"userId"];
    }
    
    [self callAPIWithPageNumber:pageNumber];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[HRMManager manager] setHeader];
}

#pragma mark - API with Pagination

-(void)callAPIWithPageNumber:(NSInteger)page{
   
    if (page != 1)
        [self setupFooterView:YES];
    
    [[HRMAPIHandler handler] getEmployeeTimesheetListingWithPageCount:@"25" andPageNumber:[NSString stringWithFormat:@"%ld",(long)page] WithSuccess:^(NSDictionary *responseDict) {
        [self setupFooterView:NO];
       // totalCount = [responseDict[@"totalCount"] integerValue];
        rules = responseDict[@"rules"];
        [[HRMHelper sharedInstance] setDataDictionary:rules];
        
        if (![[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] objectAtIndex:[[[[HRMNavigationalHelper sharedInstance] contentNavController] viewControllers] count]-2] isKindOfClass:[HRMEmployeeDetailsViewController class]]) {
            [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:![rules[@"addTimesheet"] boolValue]];
        }
        
        [responseDict[@"timsheetList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayTimsheetList addObject:obj];
              totalCount = [responseDict[@"totalCount"] integerValue];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[arrayTimsheetList indexOfObject:[arrayTimsheetList lastObject]] inSection:0];
                [tableTmesheetList insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (totalCount != [arrayTimsheetList count]) {
                    [tableTmesheetList setContentInset:UIEdgeInsetsMake(0, 0, IS_IPAD ? 60 : 30, 0)];
                }else
                    [tableTmesheetList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }];
            [labelNoData setHidden:[arrayTimsheetList count] == 0 ? NO : YES];
        
    } failure:^(NSError *error) {
        [self setupFooterView:NO];
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayTimsheetList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
        return 100;
    else
        return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMEmpTimeSheetCell *cell = (HRMEmpTimeSheetCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMEmpTimeSheetCell class])];
    [cell setDatasource:arrayTimsheetList[indexPath.row]];
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = UIColorRGB(233.0, 233.0, 233.0, 1.0);
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float scrollViewHeight = tableTmesheetList.frame.size.height;
    float scrollContentSizeHeight = tableTmesheetList.contentSize.height;
    float scrollOffset = tableTmesheetList.contentOffset.y;
    
    if ([arrayTimsheetList indexOfObject:[arrayTimsheetList lastObject]] != totalCount-1 && (scrollOffset + scrollViewHeight == scrollContentSizeHeight+ IS_IPAD ? 60 : 30) && scrollOffset > 0) {
        [self callAPIWithPageNumber:++pageNumber];
    }
}

-(void)setupFooterView:(BOOL)isSet
{
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), IS_IPAD ? 60 : 30)];
    viewContent.backgroundColor = [UIColor lightGrayColor];
    viewContent.alpha = 0.5;
    
    UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 100 : 100, 40)];
    loading.text = @"Loading...";
    loading.font = FONT_REGULAR(IS_IPAD ? 20 : 18);
    loading.textColor = [UIColor whiteColor];
    [loading setCenter:CGPointMake(CGRectGetMidX(viewContent.bounds)-10, CGRectGetMidY(viewContent.bounds))];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [activity setCenter:CGPointMake(CGRectGetMidX(viewContent.bounds)+40, CGRectGetMidY(viewContent.bounds))];
    [activity startAnimating];
    
    if (isSet) {
//        tableTmesheetList.scrollEnabled = YES;
        [viewContent addSubview:loading];
        [viewContent addSubview:activity];
        [tableTmesheetList.tableFooterView setHidden:!isSet];
        tableTmesheetList.tableFooterView = viewContent;
        loading.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(10, 0), 0.01, 0.01);
        activity.transform = CGAffineTransformMakeTranslation(-30, 0);
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewContent.alpha = 1.0;
            loading.transform = CGAffineTransformIdentity;
            activity.transform = CGAffineTransformIdentity;
        } completion:nil];
    }else{
//        tableTmesheetList.scrollEnabled = NO;
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewContent.alpha = 0.5;
            loading.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(10, 0), 0.01, 0.01);
            activity.transform = CGAffineTransformMakeTranslation(-30, 0);
        } completion:^(BOOL finished) {
            [viewContent removeFromSuperview];
            [tableTmesheetList.tableFooterView setHidden:!isSet];
            tableTmesheetList.tableFooterView = nil;
        }];
    }
}

@end
