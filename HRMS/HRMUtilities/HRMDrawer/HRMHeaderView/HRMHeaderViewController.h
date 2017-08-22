//
//  HRMHeaderViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRMSHamburgerButton.h"

@interface HRMHeaderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet HRMSHamburgerButton *btnHeaderMenu;
@property (weak, nonatomic) IBOutlet UIButton *buttonNotification;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@property (weak, nonatomic) IBOutlet UILabel *notificationLabelCount;

-(void)hideAddButton:(BOOL)hide;
-(void)headerAddButton:(NSString *)string;
-(void)setNotificationBadgeWithCount:(NSInteger)badgeCount;

@end
