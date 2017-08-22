//
//  WPDatePickerView.h
//  WeatherPOC
//
//  Created by Rupam Mitra on 29/07/15.
//  Copyright (c) 2015 Indus Net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMDatePickerView : UIView

+(void)showWithDate:(void (^)(NSDate *date))dateSelected isTimeMode:(BOOL)isTrue;
+(void)showWithDateWithMaximumDate:(void (^)(NSDate *date))dateSelected date:(NSDate *)date isMax:(BOOL)isMax;
+(void)showWithYear:(void (^)(NSDate *date))dateSelected isTimeMode:(BOOL)isTrue;

@property (nonatomic, assign) BOOL timeMode;

@end
