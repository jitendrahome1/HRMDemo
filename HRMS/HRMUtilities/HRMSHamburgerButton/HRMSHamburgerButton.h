//
//  AxisHamburgerButton.h
//  AxisCCA
//
//  Created by Debaprasad Mondal on 12/06/15.
//  Copyright (c) 2015 Indusnet Technologies Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HRMSHamburgerButtonMode) {
    HRMSHamburgerButtonModeHamburger,
    HRMSHamburgerButtonModeArrow,
    HRMSHamburgerButtonModeCross
};

@interface HRMSHamburgerButton : UIButton

@property (nonatomic) CGFloat lineHeight;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat lineSpacing;
@property (strong, nonatomic) UIColor *lineColor;

@property (nonatomic) CGFloat animationDuration;

@property (nonatomic) HRMSHamburgerButtonMode currentMode;

- (void)setCurrentModeWithAnimation:(HRMSHamburgerButtonMode)currentMode;
- (void)setCurrentModeWithAnimation:(HRMSHamburgerButtonMode)currentMode duration:(CGFloat)duration;

- (void)updateAppearance;

@end