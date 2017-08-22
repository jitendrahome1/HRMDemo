//
//  HRMCorrectionView.h
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMCorrectionView : UIView
{
    IBOutletCollection(UILabel) NSArray *labelCollection;
    __weak IBOutlet UILabel *labelDate;
    __weak IBOutlet UILabel *labelProject;
    __weak IBOutlet UILabel *labelTime;
    __weak IBOutlet UITextView *textDescription;
}

@property(nonatomic, strong) NSDictionary *datasource;

+(void)showCorrectionViewWithDictionary:(NSDictionary *)info;

@end
