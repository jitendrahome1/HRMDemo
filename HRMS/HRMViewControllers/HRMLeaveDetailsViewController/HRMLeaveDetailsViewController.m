//
//  HRMLeaveDetailsViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 01/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMLeaveDetailsViewController.h"

@interface HRMLeaveDetailsViewController ()
{
    NSArray *arrCellTitle;
    NSArray *arrOfItems;
    int selectedRow;
    BOOL isOpen;
    HRMDropDownView *dropDownView;
    NSString *leavebBalnaceType, *leaveLeft;
}

@end

@implementation HRMLeaveDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedRow = -1;
    
//    [self.viewBtn setBackgroundColor:[UIColor clearColor]];
    
    self.collectionViewDetails.backgroundColor = [UIColor clearColor];
    
//    [self.viewLeaveDetails setHidden:YES];
    
//    [self viewcorneripadRadiusSize:self.viewLeaveDate];
    
    arrCellTitle = [[NSArray alloc]initWithObjects:@"Submit Request",@"Employee id",@"Designations",nil];
    arrOfItems =[[NSArray alloc]initWithObjects:_leaveDetails[@"leaveAppliedDate"],_leaveDetails[@"employeeID"],_leaveDetails[@"designation"],nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = LEAVE_DETAILS;
    [[HRMHelper sharedInstance] setBackButton:YES];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI
{
    CGColorRef colorBorder = [UIColorRGB(208, 218, 226.0, 1.0) CGColor];
    viewReason.layer.borderColor = colorBorder;
    viewAddress.layer.borderColor = colorBorder;
    viewAO.layer.borderColor = colorBorder;
    viewCC.layer.borderColor = colorBorder;
    viewRO.layer.borderColor = colorBorder;
    viewButtons.layer.borderColor = colorBorder;
    
    // Set Labels
    labelEmployeename.text = [NSString stringWithFormat:@"%@", _leaveDetails[@"name"]];
    labelEmployeeFrom.text = [NSString stringWithFormat:@"Employee from %@", _leaveDetails[@"employeeFrom"]];
    fromDate.text = [NSString stringWithFormat:@"%@", _leaveDetails[@"fromDate"]];
    toDate.text = [NSString stringWithFormat:@"%@", _leaveDetails[@"toDate"]];
    leaveType.text = [NSString stringWithFormat:@"%@", _leaveDetails[@"leaveType"]];
    labelRO.text = [[NSString stringWithFormat:@"%@", _leaveDetails[@"personRO"]] isEqualToString:@""] ? @"N.A." : _leaveDetails[@"personRO"];
    labelAO.text = [NSString stringWithFormat:@"%@", _leaveDetails[@"personAO"]];
    labelCC.text = [NSString stringWithFormat:@"%@", [_leaveDetails[@"personCC"] isEqualToString:@""] ? @"N.A." :  _leaveDetails[@"personCC"]];
    labelAddress.text = [NSString stringWithFormat:@"%@", _leaveDetails[@"addressOnLeave"]];
    labelReason.text = [NSString stringWithFormat:@"%@", _leaveDetails[@"leaveReason"]];
    
    leavebBalnaceType = @"";
    leaveLeft = @"";
    [_leaveDetails[@"leaveBalance"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        leavebBalnaceType = [leavebBalnaceType stringByAppendingString:[NSString stringWithFormat:@"%@\n",obj[@"leaveType"]]];
        leaveLeft = [leaveLeft stringByAppendingString:[NSString stringWithFormat:@"%@\n",obj[@"noOfLeaves"]]];
    }];
    
    labelLeaveBalanceType.text = [NSString stringWithFormat:@"%@", leavebBalnaceType];
    leaveBalance.text = [NSString stringWithFormat:@"%@", leaveLeft];
}

#pragma mark- Collection View Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 150; // This is the minimum inter item spacing, can be more
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrCellTitle count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    UILabel *titleCell = (UILabel *)[cell viewWithTag:101];
    
    UILabel *titleItems = (UILabel *)[cell viewWithTag:102];
    
    [titleCell setText:[arrCellTitle objectAtIndex:indexPath.row]];
    
    [titleItems setText:[arrOfItems objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark- Table View Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
 // no Animation
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
        return [[HRMHelper sharedInstance] getLabelSizeFortext:_leaveDetails[@"addressOnLeave"] forWidth:CGRectGetWidth(labelReason.frame) WithFont:labelReason.font].height + 96;
    else if (indexPath.row == 2)
        return [[HRMHelper sharedInstance] getLabelSizeFortext:_leaveDetails[@"leaveReason"] forWidth:CGRectGetWidth(labelReason.frame) WithFont:labelReason.font].height + 96;
    else if (indexPath.row == 0)
        return 310+[[HRMHelper sharedInstance] getLabelSizeFortext:leavebBalnaceType forWidth:CGRectGetWidth(labelLeaveBalanceType.frame) WithFont:labelLeaveBalanceType.font].height;
    else if (indexPath.row == 6)
        return 107;
    else
        return 96;
}

#pragma mark - IBAction

- (IBAction)actionOnLeave:(UIButton *)sender {

    NSString *leaveAction = nil;
    if(sender.tag == 0)   // action for accept leave Value = 1
    leaveAction = @"1";
    else     // action for reject leave value  = 0
    leaveAction = @"0";
    
    [[HRMAPIHandler handler]leaveApproveOrRejectWithLeaveID:_leaveDetails[@"leaveID"] leaveAction:leaveAction WithSuccess:^(NSDictionary *responseDict) {
        NSLog(@"Leave Result-> %@",responseDict);
        [HRMToast showWithMessage:LEAVE_STATUS_CHANGE];
        [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark- user define method

-(void)viewcornerRadiusSize:(UIView*)viewSelect
{
 viewSelect.layer.cornerRadius = 3.0f;
}
@end
