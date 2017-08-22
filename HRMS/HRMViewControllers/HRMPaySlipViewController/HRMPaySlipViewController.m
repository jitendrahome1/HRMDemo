//
//  HRMPaySlipViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 07/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMPaySlipViewController.h"
#import "HRMPaySlipCell.h"
#import "HRMPicker.h"
@interface HRMPaySlipViewController ()
{
    NSMutableArray *arrayValues, *demoArr;
    NSInteger currentIndex;
    NSString *strMoth;
    NSString *strYear;
    NSDictionary *dict;
    NSMutableArray *arrPaySlipInfo;
    NSMutableArray *arrDetails;
   NSMutableArray *arrTemp;
}
@end

@implementation HRMPaySlipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrPaySlipInfo = [[NSMutableArray alloc]init];
    arrDetails = [[NSMutableArray alloc]init];
    arrTemp = [[NSMutableArray alloc]init];
    labelNoPayslip.hidden = YES;
//    arrayValues = [NSMutableArray new];
//    demoArr = [[NSMutableArray alloc] initWithObjects:@"ahsudg", @"sadasd", @"ashdg", nil];
    strMoth = [[NSDate date] getMonthYearStringFromDate];
    strYear = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] getYear]];
    // call paySlip Api
    labelName.text = OBJ_FOR_KEY(kLoginUserName);
    [self callGetEmployeePaySlipWithMothAndYear:strMoth year:strYear];
    [buttonMonth setTitle:strMoth forState:UIControlStateNormal];
    [buttonYear setTitle:strYear forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = PAYSLIP;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    
//    if(!(arrDetails.count > 0) )
//    {
//        [HRMToast showWithMessage:@"Payslip not generated yet."];
//    }
    buttonMonth.layer.borderWidth = 1.0;
    buttonMonth.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
    buttonYear.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
    buttonYear.layer.borderWidth = 1.0;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrPaySlipInfo.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return IS_IPAD? 50.0 : 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), IS_IPAD? 50: 30)];
    headerView.backgroundColor = UIColorRGB(13, 76, 114, 1.0);
    
    UIButton *button = [[UIButton alloc] initWithFrame:headerView.frame];
    button.tag = section;
    [button addTarget:self action:@selector(actionSelectHeader:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, IS_IPAD? 10 : 0, CGRectGetWidth(tableView.frame)-55, 30)];
    label.font = FONT_REGULAR(IS_IPAD? 22:15);
    label.textColor = [UIColor whiteColor];
   // lable for separator
    UILabel *lblSeparator = [[UILabel alloc] initWithFrame:CGRectMake(0, IS_IPAD? 50 - 1:30 - 1 , [[UIScreen mainScreen]bounds].size.width, 1)];
    lblSeparator.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lblSeparator];
    
   // label.text = @"Employee Pay Status";
    label.text = [[arrPaySlipInfo objectAtIndex:section]valueForKey:@"header"];
    [headerView addSubview:label];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CircelDownArrow"]];
    if(IS_IPAD)
    {   CGRect fram = image.frame;
        fram.size.width = 30;
        fram.size.height = 30;
        image.frame = fram;
    }

    
   // image.center = CGPointMake(CGRectGetWidth(headerView.frame) - 35, CGRectGetHeight(headerView.bounds)/2.0);
    if(IS_IPAD)
    
        image.center = CGPointMake(CGRectGetWidth(headerView.frame) - 27 , CGRectGetHeight(headerView.bounds)/2.0);
    else
           image.center = CGPointMake(CGRectGetWidth(headerView.frame) - 20 , CGRectGetHeight(headerView.bounds)/2.0);
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(270));
        image.transform = transform;
        }];
    [headerView addSubview:image];
    
    return headerView;
    
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
return   [[arrDetails objectAtIndex:section]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMPaySlipCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMPaySlipCell class])];
    
    NSDictionary *dictDetails = [[arrDetails objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell setDatasource:dictDetails];
     return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPAD? 50:30;
}

#pragma mark - IBAction

- (IBAction)actionGo:(UIButton *)sender {
    
    [arrPaySlipInfo removeAllObjects];
    [arrDetails removeAllObjects];
    [self callGetEmployeePaySlipWithMothAndYear:strMoth year:strYear];
    [tablePayslip reloadData];
    
}

- (IBAction)actionMonth:(UIButton *)sender {

    [HRMPicker showWithArrayWithSelectedIndex:[[NSDate getAllMonths] indexOfObject:sender.titleLabel.text] andArray:[NSDate getAllMonths] didSelect:^(NSString *data, NSInteger index) {
        [sender setTitle:data forState:UIControlStateNormal];
        strMoth = data;
    }];
    
}

- (IBAction)actionYear:(UIButton *)sender {


   [HRMPicker showWithArrayWithSelectedIndex:[[NSDate getAllYearList] indexOfObject:sender.titleLabel.text] andArray:[NSDate getAllYearList] didSelect:^(NSString *data, NSInteger index) {
    [sender setTitle:data forState:UIControlStateNormal];
    strYear = data;
}];
}

-(IBAction)actionSelectHeader:(UIButton *)sender
{
    UIView *headerView = (UIView *)sender.superview;
    UIImageView *disclosure;
    
    if (sender.isSelected) {
        [sender setSelected:NO];
        
        for(UIView *imagView in headerView.subviews)
        {
            if([imagView isKindOfClass:[UIImageView class]])
            {
                disclosure = (UIImageView *)imagView;
                
            }
        }
        
        [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(270));
        disclosure.transform = transform;
        }];
        
        NSMutableArray *arrIndexPaths=[[NSMutableArray alloc] init];
        for (int i=0; i<((NSArray*)arrDetails[sender.tag]).count; i++) {
            [arrIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
        }
        [arrDetails replaceObjectAtIndex:sender.tag withObject:@[]];
        [tablePayslip deleteRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        
    }
    else
    {
        [sender setSelected:YES];
        currentIndex = sender.tag;
        for(UIView *imagView in headerView.subviews)
        {
            if([imagView isKindOfClass:[UIImageView class]])
            {
                disclosure = (UIImageView *)imagView;
                
            }
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(360));
            disclosure.transform = transform;
            }];

        [arrDetails replaceObjectAtIndex:currentIndex withObject:[arrPaySlipInfo[currentIndex] objectForKey:@"details"]];
        NSMutableArray *arrIndexPaths=[[NSMutableArray alloc] init];
        for (int i=0; i<((NSArray*)arrDetails[currentIndex]).count; i++) {
            [arrIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:currentIndex]];
        }
        [tablePayslip insertRowsAtIndexPaths:arrIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


-(void)callGetEmployeePaySlipWithMothAndYear:(NSString *)month year:(NSString *)year
{
  
    [[HRMAPIHandler handler]getGetPayslipWithMothAndYear:month year:year WithSuccess:^(NSDictionary *responseDict) {
        
        [responseDict [@"payslipInfo"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrPaySlipInfo addObject:obj];
          [arrDetails addObject:@[]];
        }];
          [self getDetailsInfo:arrPaySlipInfo];
        labelNetPay.text = [NSString stringWithFormat:@"%@",responseDict[@"netPay"]];
 
        [tablePayslip reloadData];
    } failure:^(NSError *error) {
  
    }];
    //
    
  
}

-(void)getDetailsInfo:(NSMutableArray *)arr{
    [arrTemp removeAllObjects];
    for(int  i = 0; i<arr.count ;i++)
    {
        NSArray *temp  = [[arr valueForKey:@"details"]objectAtIndex:i];
        [arrTemp addObjectsFromArray:temp];
     }

    if (arrTemp == nil || [arrTemp count] == 0) {
 [HRMToast showWithMessage:@"Payslip not generated yet."];
    }
}

@end
