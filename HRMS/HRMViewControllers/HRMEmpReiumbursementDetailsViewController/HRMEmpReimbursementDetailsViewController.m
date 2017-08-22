//
//  HRMEmpReimbursementDetailsViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 08/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMEmpReimbursementDetailsViewController.h"

@interface HRMEmpReimbursementDetailsViewController ()

@end

@implementation HRMEmpReimbursementDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setupDataDisplay:_arrReimbursementDetails];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = REIMBURSEMENT_DETAILS;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    
    [labelCollection enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(IS_IPAD)
        obj.layer.cornerRadius = 8.0;
        else
             obj.layer.cornerRadius = 4.0;
        obj.clipsToBounds = YES;
    }];
    [[HRMHelper sharedInstance] setBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-
#pragma Setup Data display
-(void)setupDataDisplay:(NSMutableArray *)arrReimbursementData
{
    NSLog(@"%@", arrReimbursementData);
    
    labelAmount.text=   [[arrReimbursementData valueForKey:@"amount"]isEqualToString:@""]? @"N.A.":[arrReimbursementData valueForKey:@"amount"];
    labelAO.text=   [[arrReimbursementData valueForKey:@"personAO"]isEqualToString:@""]? @"N.A.":[arrReimbursementData valueForKey:@"personAO"];
    labeldate.text=   [[arrReimbursementData valueForKey:@"dateIncurred"]isEqualToString:@""]? @"N.A.":[arrReimbursementData valueForKey:@"dateIncurred"];
    textDescription.text=   [[arrReimbursementData valueForKey:@"description"]isEqualToString:@""]? @"N.A.":[arrReimbursementData valueForKey:@"description"];
    reimbursementType.text=   [[arrReimbursementData valueForKey:@"Type"]isEqualToString:@""]? @"N.A.":[arrReimbursementData valueForKey:@"Type"];
  
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        UIImage *img =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrReimbursementData valueForKey:@"file"]]]]?:[UIImage imageNamed:@"BigGrayImage.png"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            imageReimbursement.image = img;
            [activityIndicator stopAnimating];
        }];
    }];
    textDescription.translatesAutoresizingMaskIntoConstraints = YES;
    textDescription.frame = CGRectMake(textDescription.frame.origin.x, textDescription.frame.origin.y, CGRectGetWidth(textDescription.frame), [[HRMHelper sharedInstance] getLabelSizeFortext:[arrReimbursementData valueForKey:@"description"] forWidth:CGRectGetWidth(textDescription.frame) WithFont:textDescription.font].height > 116.0 ? [[HRMHelper sharedInstance] getLabelSizeFortext:[arrReimbursementData valueForKey:@"description"] forWidth:CGRectGetWidth(textDescription.frame) WithFont:textDescription.font].height + 10 : 125.0);
    
    
    NSLog(@"%@", NSStringFromCGRect(textDescription.frame ));
    
//self.nsDesHightConst.constant = textDescription.contentSize.height;

    
 }
#pragma mark -
#pragma mark - Table View Delegates
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{   // no Animation
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float width,newHight;
    width = textDescription.frame.size.width;
    UIFont *font = [textDescription font];
    if(indexPath.row == 4)
    {
        CGSize textSize = [[HRMHelper sharedInstance]getLabelSizeFortext:textDescription.text forWidth:width WithFont:font];
        if(textSize.height > 125)
            newHight = 125;
        else
            newHight = textSize.height;
        return newHight+50;
    }
    if(indexPath.row == 5)
        return IS_IPAD?183:114;
    else
        return  IS_IPAD? 50:35;
}
@end
