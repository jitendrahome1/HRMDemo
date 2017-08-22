//
//  HRMReimbursementDetailViewController.m
//  
//
//  Created by Priyam Dutta on 07/10/15.
//
//

#import "HRMReimbursementDetailViewController.h"
#import "HRMDatePickerView.h"

@interface HRMReimbursementDetailViewController ()
{
    NSArray *arrCellTitle;
    NSArray *arrOfItems;
    UIView *backView;
    CGRect constantFrame;
    CGPoint constantPoint;
}

@end

@implementation HRMReimbursementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrCellTitle = [[NSArray alloc]initWithObjects:@"Submit Request",@"Department",@"Employee id",nil];
    arrOfItems =[[NSArray alloc]initWithObjects:_reimbursementDetails[@"reimbAppliedDate"] , _reimbursementDetails[@"department"], _reimbursementDetails[@"employeeID"], nil];
    constantFrame = imageView.bounds;
    constantPoint = imageView.center;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[HRMHelper sharedInstance] setBackButton:YES];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = REIMBURSEMENT_DETAILS;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [self setupUI];
}

-(void)setupUI
{
    lblHdrName.text = _reimbursementDetails[@"name"];
    lblEmployment.text = [NSString stringWithFormat:@"Employee from %@", _reimbursementDetails[@"employeeFrom"]];
    lblAmount.text = [NSString stringWithFormat:@"$%@", _reimbursementDetails[@"reimbAmount"]];
    txtView.text = _reimbursementDetails[@"description"];
    dateIncurred.text = _reimbursementDetails[@"dateIncurred"];//[NSString stringWithFormat:@"%@", [_reimbursementDetails[@"dateIncurred"] stringFromDateWithFormat:@"MMM dd, yyyy"]];
    
    txtView.translatesAutoresizingMaskIntoConstraints = YES;
    txtView.frame = CGRectMake(txtView.frame.origin.x, txtView.frame.origin.y, CGRectGetWidth(txtView.frame), [[HRMHelper sharedInstance] getLabelSizeFortext:_reimbursementDetails[@"description"] forWidth:CGRectGetWidth(txtView.frame) WithFont:txtView.font].height < 116.0 ? [[HRMHelper sharedInstance] getLabelSizeFortext:_reimbursementDetails[@"description"] forWidth:CGRectGetWidth(txtView.frame) WithFont:txtView.font].height + 10 : 125.0);
    
    imageView.layer.shadowOffset = CGSizeMake(10, 3);
    imageView.layer.shadowRadius = 10.0;
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOpacity = 0.5;
    imageView.layer.shouldRasterize = YES;
    
    imageView.layer.cornerRadius = CGRectGetWidth(imageView.bounds)/2.0;
    imageView.transform = CGAffineTransformMakeScale(0.002, 0.002);
    
    dispatch_queue_t concurrentQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(concurrentQ, ^{
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_reimbursementDetails[@"attachments"]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            imageView.image = img;
            [UIView animateWithDuration:0.35 animations:^{
                imageView.layer.cornerRadius = 0;
                imageView.transform = CGAffineTransformIdentity;
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
            [imageView addGestureRecognizer:tap];
            tap.delegate = self;
            [imageView setUserInteractionEnabled:YES];
        });
    });
}

-(IBAction)actionTap:(UITapGestureRecognizer *)recognize
{
//    return;
    if (!backView) {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]))];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.0;
        [[[UIApplication sharedApplication] keyWindow] addSubview:backView];
        
        recognize.view.translatesAutoresizingMaskIntoConstraints = YES;
        CGPoint getPoint = [imageView.superview convertPoint:imageView.center toView:backView];
        [[[UIApplication sharedApplication] keyWindow] addSubview:imageView];
        imageView.center = getPoint;
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognize.view.transform = CGAffineTransformMakeScale(1.25, 1.25);
            backView.alpha = 0.5;
            
            CGRect frameModify = imageView.frame;
            frameModify.size.width = CGRectGetWidth(backView.bounds) - 100;
            frameModify.size.height = CGRectGetHeight(backView.bounds) - 100;
            imageView.frame = frameModify;
            imageView.center = CGPointMake(CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame)/2.0, CGRectGetHeight([[UIApplication sharedApplication] keyWindow].frame)/2.0);
            
        } completion:^(BOOL finished) {
        }];
    }else{

        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            backView.alpha = 0.0;
            recognize.view.transform = CGAffineTransformIdentity;
            CGRect frameModify = imageView.frame;
            frameModify.size.width = CGRectGetWidth(constantFrame);
            frameModify.size.height = CGRectGetHeight(constantFrame);
            imageView.frame = frameModify;
            imageView.center = [txtView.superview convertPoint:constantPoint toView:backView];
            
        } completion:^(BOOL finished) {
            [txtView.superview addSubview:imageView];
            imageView.center = constantPoint;
            [backView removeFromSuperview];
            backView = nil;
        }];
    }
}

#pragma mark -
#pragma mark - Collection View Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  arrOfItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    static NSString *identifier = @"ReimbursementDetailCell";
    cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UILabel *titleCell = (UILabel *)[cell viewWithTag:101];
    
    UILabel *titleItems = (UILabel *)[cell viewWithTag:102];
    
    [titleCell setText:[arrCellTitle objectAtIndex:indexPath.row]];
    
    [titleItems setText:[arrOfItems objectAtIndex:indexPath.row]];
    
    return cell;
   
}
#pragma mark -
#pragma mark - Table View Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (694 + [[HRMHelper sharedInstance] getLabelSizeFortext:_reimbursementDetails[@"description"] forWidth:CGRectGetWidth(txtView.frame) WithFont:txtView.font].height) < 810 ? (694 + [[HRMHelper sharedInstance] getLabelSizeFortext:_reimbursementDetails[@"description"] forWidth:CGRectGetWidth(txtView.frame) WithFont:txtView.font].height) - 50 : 760;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{   // no Animation
}

#pragma  mark - Button Action

- (IBAction)actionApprove:(UIButton *)sender {
        [self approveOrReject:YES];
}


- (IBAction)actionReject:(UIButton *)sender {
        [self approveOrReject:NO];
}

-(void)approveOrReject:(BOOL)isApprov
{
    [[HRMAPIHandler handler] reimbursementApproveOrRejectWithReimbursementID:_reimbursementDetails[@"reimbursementID"] leaveAction:isApprov ? @"1" : @"0" WithSuccess:^(NSDictionary *responseDict) {
        [HRMToast showWithMessage:responseDict[@"responsedetails"]];
        [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

@end
