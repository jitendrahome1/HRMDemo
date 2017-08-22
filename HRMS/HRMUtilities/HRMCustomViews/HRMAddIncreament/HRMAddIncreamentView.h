//
//  HRMAddIncreamentView.h
//  HRMS
//
//  Created by Priyam Dutta on 08/07/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol HRMAddIncreamentViewDelegate <NSObject>
-(void)didFinishAction;
@end

@interface HRMAddIncreamentView : UIView
{

    IBOutletCollection(UILabel) NSArray *labelCollection;
    IBOutlet UIButton *buttonDate;
    IBOutlet UITextField *textAmount;
    IBOutlet UIButton *buttonReason;
    IBOutlet UITextView *textDescription;
    NSString *reasonID, *employee;
}
@property(nonatomic,weak)id <HRMAddIncreamentViewDelegate> delegate;
//+(void)showCorrectionViewWithDictionary:(NSString *)employeeID;
+(void)showCorrectionViewWithDictionary:(NSString *)employeeID onParentVC:(UIViewController*)vc;

@end
