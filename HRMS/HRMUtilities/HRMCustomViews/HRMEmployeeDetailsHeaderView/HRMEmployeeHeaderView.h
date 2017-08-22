//
//  HRMEmployeeHeaderView.h
//  HRMS
//
//  Created by Priyam Dutta on 03/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMEmployeeHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgEmply;
@property (weak, nonatomic) IBOutlet UILabel *lblEmplyname;
@property (strong, nonatomic) IBOutlet UILabel *lblEmpIDWithDepatment;
@property (strong, nonatomic) IBOutlet UILabel *lblDesigner;
@property (weak, nonatomic) IBOutlet UILabel *viewEmpDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEmpID;
@property (strong, nonatomic) IBOutlet UILabel *lblEmpDepatment;
@property (strong, nonatomic) IBOutlet UIView *viewDate;
@property (strong, nonatomic) IBOutlet UIImageView *imagBG;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (instancetype)instantiateFromNib;

@end
