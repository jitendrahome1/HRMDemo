//
//  HRMViewTimeSheetViewController.m
//  HRMS
//
//  Created by Jitendra Agarwal on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMViewTimeSheetViewController.h"

@interface HRMViewTimeSheetViewController ()

@end

@implementation HRMViewTimeSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    NSLog(@"%@Data ",_arrTimeSheetData);
    [self setupPopulateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = VIEW_TIMESHEET;
    [[HRMHelper sharedInstance] setBackButton:YES];
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
}

-(void)setupUI
{
    self.viewImageCover.layer.cornerRadius = 5.0;
    self.viewImageCover.layer.borderWidth = 1.0;
    self.viewImageCover.layer.borderColor = [UIColor grayColor].CGColor;
}
#pragma mark-
#pragma populate data
-(void)setupPopulateData
{

    
    if([[_arrTimeSheetData valueForKey:@"isInTime"] integerValue] > 0)
    _lblTimeTitle.text                   =             @"In Time:";
    else
    _lblTimeTitle.text                    =           @"Out Time:";
    
    _lblUserName.text                  =           [_arrTimeSheetData valueForKey:@"name"];
    _lblEmpID.text                        =           [_arrTimeSheetData valueForKey:@"employeeID"];
    _lblDepartmentName.text      =           [_arrTimeSheetData valueForKey:@"department"];
    _lblDate.text                           =           [_arrTimeSheetData valueForKey:@"date"];
    _lblProjectName.text             =           [_arrTimeSheetData valueForKey:@"project"];
    _lblTime.text                          =           [_arrTimeSheetData valueForKey:@"time"];
    _lblLocation.text                    =           [[_arrTimeSheetData valueForKey:@"location"] isEqualToString:@""]? @"N.A.": [_arrTimeSheetData valueForKey:@"location"];
//    NSString *profileImageURl    =           [_arrTimeSheetData valueForKey:@"profileImage"];
//    NSString *timeSheetURL    =           [_arrTimeSheetData valueForKey:@"timesheetImage"];
//    if(timeSheetURL.length > 0)
//        _imageCover.image                   =          [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:timeSheetURL]]];
    
    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    [myQueue addOperationWithBlock:^{
        UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_arrTimeSheetData valueForKey:@"profileImage"]]]]?:[UIImage imageNamed:@"BigGrayImage.png"];
        
        UIImage *coverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_arrTimeSheetData valueForKey:@"timesheetImage"]]]]?:[UIImage imageNamed:@"BigGrayImage.png"];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_activityIndicator stopAnimating];
             _ImageProfile.image = profileImage;
          _ImageProfile.layer.cornerRadius =    _ImageProfile.frame.size.width / 2;
            _ImageProfile.clipsToBounds = YES;
            _imageCover.image = coverImage;
      
        }];
    }];


    
//    if(profileImageURl.length > 0)
//      _ImageProfile.image = [[HRMHelper sharedInstance]imageCircle:profileImageURl ImageView:_ImageProfile];
//    else
//    {
//    _ImageProfile.image=  [UIImage imageNamed:@"BigGrayImage"];
//    _ImageProfile.layer.cornerRadius =        _ImageProfile.frame.size.width / 2;
//    _ImageProfile.clipsToBounds = YES;
//}
}


@end
