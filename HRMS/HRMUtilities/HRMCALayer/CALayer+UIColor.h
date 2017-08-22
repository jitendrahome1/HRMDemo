//
//  CALayer+UIColor.h
//  HRMS
//
//  Created by Chinmay Das on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (UIColor)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end
