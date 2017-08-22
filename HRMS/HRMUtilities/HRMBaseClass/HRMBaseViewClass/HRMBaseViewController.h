//
//  HRMBaseViewController.h
//  HRMS
//
//  Created by Priyam Dutta on 30/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMBaseViewController : UIViewController
typedef enum {
    eAddButtonShow,
    eAddButtonHide
}AddButton;
@property (nonatomic, readwrite) AddButton addButtonStatus;
@end
