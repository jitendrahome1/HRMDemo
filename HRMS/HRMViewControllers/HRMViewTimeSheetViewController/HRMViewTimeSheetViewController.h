//
//  HRMViewTimeSheetViewController.h
//  HRMS
//
//  Created by Jitendra Agarwal on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"

@interface HRMViewTimeSheetViewController : HRMBaseViewController
@property (strong, nonatomic) IBOutlet UIView *viewImageCover;
@property (strong, nonatomic) IBOutlet UIImageView *ImageProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblProjectName;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmpID;
@property (strong, nonatomic) IBOutlet UILabel *lblDepartmentName;
@property (strong, nonatomic) IBOutlet UIImageView *imageCover;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(nonatomic,strong)NSMutableArray *arrTimeSheetData;
@end
