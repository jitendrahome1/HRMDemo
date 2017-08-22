//
//  HRMPicker.h
//  HRMS
//
//  Created by Chinmay Das on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMPicker : UIView

+(void)showWithArray:(NSArray*)dataArray didSelect:(void (^)(NSString *data, NSInteger index))dataSelected;
+(void)showWithArrayWithSelectedIndex:(NSInteger)index andArray:(NSArray*)dataArray didSelect:(void (^)(NSString *data, NSInteger index))dataSelected;

@end
