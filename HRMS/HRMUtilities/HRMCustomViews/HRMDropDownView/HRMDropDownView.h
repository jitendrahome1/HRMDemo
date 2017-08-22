//
//  HRMDropDownView.h
//  HRMS
//
//  Created by Jitendra Agarwal on 06/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol HRMDropDownDelegate <NSObject>

-(void)HRMViewControllerDismiss;
-(void)HRMViewControllerDoneAction:(NSString *)selectedItems;

@end


#import <UIKit/UIKit.h>
@interface HRMDropDownView : UIView

@property(nonatomic,strong)NSArray *arrOfData;
@property (weak, nonatomic) IBOutlet UIView *viewDropDownBack;
@property (weak, nonatomic) IBOutlet UITableView *tblDropDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcTblHeight;
@property(nonatomic,weak)id<HRMDropDownDelegate> delegate;


@end
