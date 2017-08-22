//
//  HRMHelper.h
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "HRMMaterialSpinner.h"
#import "HRMSHamburgerButton.h"

typedef  enum
{
    UserTypeOfficial,
    UserTypeEmployee
    
}  HRMUserType;

typedef enum NSInteger{
    home = 0,
    employee = 1,
    timeSheet = 2,
    tmesheetCorrection = 3,
    leaveApplication = 4,
    interview = 5,
    reimbursement = 6,
    appraisal = 7,
    myProfile = 8,
    notification = 9,
    settings = 10,
    payslip = 11
} HRMMenuType;

@interface HRMHelper : NSObject

@property (nonatomic, strong) NSDictionary *dataDictionary;

// Animation
-(void)animateButtonClickedZoom:(UIButton *)sender completion:(void(^)(void))competed;

// Label Size
-(CGSize)getLabelSizeFortext:(NSString *)text forWidth:(float)width WithFont:(UIFont *)font;
-(CGSize)getLabelSizeFortext:(NSString *)text forHeight:(float)height WithFont:(UIFont *)font;

//enum
@property (nonatomic, assign)HRMUserType userType;
@property (nonatomic, assign)HRMMenuType menuType;

//Toast
@property (nonatomic, weak) UIView *tostView;
@property (nonatomic, weak) UILabel *tostLabel;
@property (nonatomic, weak) UILabel *networkTostLabel;
-(void)showToast:(BOOL)show message:(NSString *)message animated:(BOOL)animated;

//Menu
@property (nonatomic) BOOL canOpenDrawer;
@property (nonatomic, strong) NSArray *arrMenuInfo;
-(void)setBackButton:(BOOL)set;


//String
-(NSString *)checkNullStringAndReplace:(NSString*)_inputString;
-(NSString *)getStoryboardNameForOriginalName:(NSString *)originalName;
-(NSString *)getNIBNameForOriginalNIBName:(NSString *)originalNIBName;
-(CGRect)getFrameWidthFromString:(NSString *)inputString withFrame:(CGRect)inputFrame withFont:(UIFont *)font;

//Spinner
@property (nonatomic, strong) HRMMaterialSpinner *loadingSpinner;
@property (nonatomic, assign) BOOL isSpinnerShowing;
-(void)addLoadingSpinnerInparentView:(UIView*)inview;
-(void)showSpinnerOnparentView:(UIViewController*)inview userInteraction:(BOOL)userinteraction completion:(void(^)(void))completion;
-(void)hideSpinnerParentView:(UIViewController*)inview completion:(void (^)(void))completion;

// image Circle
-(UIImage *)imageCircle:(NSString  * )path ImageView:(UIImageView *)ImageView;
// defult image
-(UIImage *)imageDefaul:(UIImageView *)imageDefult;
// remove space
-(NSString*)trim:(NSString*)string;
// no record lable found
-(void)showNoRecordsMessageForTableView:(UITableView *)aTableView inView:(UIView *)view withRecordCount:(int)numrecord strText:(NSString *)strText;
//Queue
@property (nonatomic, readwrite) int queueCount;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;
-(void)insertIntoQueue:(NSInvocationOperation *)_operation;

//Hamburger
@property (nonatomic, strong) HRMSHamburgerButton *hamburgerButton;

+(HRMHelper *)sharedInstance;

@end
