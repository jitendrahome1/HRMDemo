//
//  PMTextField.h
//  PampMe
//
//  Created by Rupam Mitra on 15/09/15.
//  Copyright (c) 2015 Indus Net. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface HRMTextField : UITextField

@property (strong, nonatomic) void((^calendarHandler)(void));

@property (strong, nonatomic) IBInspectable UIImage *RightViewImage;
@property (strong, nonatomic) IBInspectable UIImage *LeftViewImage;
@property (assign, nonatomic) IBInspectable CGRect RightViewRect;
@property (assign, nonatomic) IBInspectable CGRect LeftViewRect;

@end
