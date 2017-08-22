//
//  HRMAppraisalDetailsViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 05/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMAppraisalDetailsViewController.h"
#import "HRMAppraisalDetailsCell.h"
#import "HRMAddIncreamentView.h"

@interface HRMAppraisalDetailsViewController ()<HRMAddIncreamentViewDelegate>
{
    NSMutableArray *arraySalaryProgress;
    NSString *profileImageURl;
    NSString *empName;
   // HRMAddIncreamentView *increamentView;
}
@end

@implementation HRMAppraisalDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   // increamentView = [[HRMAddIncreamentView alloc]init];
    //increamentView.delegate = self;
    buttonAddIncreament.layer.cornerRadius = CGRectGetHeight(buttonAddIncreament.frame)/2.0;
    buttonAddIncreament.clipsToBounds = YES;
    [buttonAddIncreament addTarget:self action:@selector(actionOpenAddIncreament:) forControlEvents:UIControlEventTouchUpInside];
    arraySalaryProgress = [NSMutableArray new];
      if ([[HRMHelper sharedInstance] menuType] == appraisal) {
          _employeeIncreamentID = [self.arrAppraisalDetails valueForKey:@"employeeID"];
          
//          _employeeIncreamentID = [NSString stringWithFormat:@"Employee ID:%@ ",[self.arrAppraisalDetails valueForKey:@"employeeID"]]; // [self.arrAppraisalDetails valueForKey:@"employeeID"];
          
            _employeeIncreamentID =  [self.arrAppraisalDetails valueForKey:@"employeeID"];
          
          
        profileImageURl =   [NSString stringWithFormat:@"%@", [_arrAppraisalDetails valueForKey:@"image"]];
          empName = [_arrAppraisalDetails valueForKey:@"name"];
      }
    else
    {
        _employeeIncreamentID = [self.dictEmployeeDetails valueForKey:@"employeeID"];
         profileImageURl =   [NSString stringWithFormat:@"%@", [_dictEmployeeDetails valueForKey:@"image"]];
         empName = [_dictEmployeeDetails valueForKey:@"fullName"];
    }
    [self loadAppraisalDetails];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[HRMHelper sharedInstance] setBackButton:YES];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = APPRIASAL_DETAIL;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [self callAPIsalaryProgress];

    
}
-(void)loadAppraisalDetails
{
    [imageProf sd_setImageWithURL:[NSURL URLWithString:profileImageURl]
                   placeholderImage:[UIImage imageNamed:@"BigGrayImage"]];
    //imageProf.layer.cornerRadius = imageProf.frame.size.width/2;
    
    imageProf.layer.cornerRadius = CGRectGetWidth(imageProf.bounds)/2.0;
    
    imageProf.layer.masksToBounds = YES;
    employeeID.text = [NSString stringWithFormat:@"Employee ID:%@ ",_employeeIncreamentID];   //_employeeIncreamentID;
    name.text = empName;
      
    }

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [arraySalaryProgress count];//15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HRMAppraisalDetailsCell";
    HRMAppraisalDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
CGSize cellHight = [[HRMHelper sharedInstance]getLabelSizeFortext:[[arraySalaryProgress valueForKey:@"Remark"]objectAtIndex:indexPath.row] forWidth:cell.lblDesc.frame.size.width WithFont:[UIFont fontWithName:@"FuturaBT-Book" size:20 ]];
    
 return cellHight.height+165;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMAppraisalDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMAppraisalDetailsCell class])];
 
    [cell setDatasource:[arraySalaryProgress objectAtIndex:indexPath.row]];
   // [cell.contentView bringSubviewToFront:cell.viewSeparator];
    return cell;
}



#pragma mark - IBAction

-(IBAction)actionOpenAddIncreament:(UIButton *)sender{
    [HRMAddIncreamentView showCorrectionViewWithDictionary:_employeeIncreamentID onParentVC:self];
}

#pragma mark :-  HRMAddIncreamentView Delegate

-(void)didFinishAction
{   [arraySalaryProgress removeAllObjects];
    [self callAPIsalaryProgress];
    
}

-(void)showNORecord
{
    if(arraySalaryProgress.count ==0 && !arraySalaryProgress)
    {
        tableSalProgress.hidden = NO;
    }
    else
    {
        tableSalProgress.hidden = YES;
    }
}

-(void)callAPIsalaryProgress
{
    [[HRMAPIHandler handler] salaryProgressListEmployeeID:_employeeIncreamentID WithSuccess:^(NSDictionary *responseDict) {
        
        NSArray *arrTemp = responseDict[@"incrimentedSalary"];
        if(arrTemp.count == 0 && !arrTemp)
            tableSalProgress.hidden = YES;
        else
            tableSalProgress.hidden = NO;
        [responseDict [@"incrimentedSalary"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arraySalaryProgress addObject:obj];
            [tableSalProgress reloadData];
        }];
        
    } failure:^(NSError *error) {
        
    }];
}


- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

@end
