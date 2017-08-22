//
//  HRMAddIncreamentView.m
//  HRMS
//
//  Created by Priyam Dutta on 08/07/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMAddIncreamentView.h"
#import "HRMPicker.h"
#import "HRMDatePickerView.h"

static UIView *overlayView;

@implementation HRMAddIncreamentView

//+(void)showCorrectionViewWithDictionary:(NSString *)employeeID
+(void)showCorrectionViewWithDictionary:(NSString *)employeeID onParentVC:(UIViewController*)vc
{
    HRMAddIncreamentView *correctionView = [[HRMAddIncreamentView alloc] initWithDictionary:employeeID];
    correctionView.delegate=vc;
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:correctionView];
}

- (instancetype)initWithDictionary:(NSString *)employeeID
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        self.layer.cornerRadius = 10.0;
        self.clipsToBounds = YES;
        [self setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTransformIdentity:)];
        [self addGestureRecognizer:tap];
        
        self.layer.transform = CATransform3DMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y, 0);
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transformAnimation.duration = 0.15;
        [self.layer addAnimation:transformAnimation forKey:@"ContentTransform"];
        self.layer.transform = [transformAnimation.toValue CATransform3DValue];
        [self addOverlay];
        textDescription.layer.borderWidth = 1.0;
        textDescription.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
        [labelCollection enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.layer.cornerRadius = 8.0;
            obj.clipsToBounds = YES;
        }];
        reasonID = @"";
        textDescription.text = @"";
        [buttonReason addTarget:self action:@selector(actionGetReason:) forControlEvents:UIControlEventTouchUpInside];
        [buttonDate setTitle:[[NSDate date] stringFromDate] forState:UIControlStateNormal];
        employee = employeeID;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getViewTransform) name:kviewTransform object:nil];
    }
    return self;
}

-(void)getViewTransform
{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

-(void)addOverlay
{
    overlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [overlayView setAlpha:0.0f];
    [overlayView setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [overlayView addGestureRecognizer:tapGesture];
    [overlayView setUserInteractionEnabled:YES];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @(overlayView.layer.opacity);
    fadeAnimation.toValue = @(0.6f);
    fadeAnimation.duration = 0.10;
    [overlayView.layer addAnimation:fadeAnimation forKey:@"BackgroundOpacity"];
    overlayView.layer.opacity = [fadeAnimation.toValue floatValue];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:overlayView];
}

-(void)dismiss
{
    [self keybordEndEditing];
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @(overlayView.layer.opacity);
    fadeAnimation.delegate = self;
    fadeAnimation.toValue = @(0.0f);
    fadeAnimation.duration = 0.10;
    [overlayView.layer addAnimation:fadeAnimation forKey:@"BackgroundOpacity"];
    overlayView.layer.opacity = [fadeAnimation.toValue floatValue];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height, 0)];
    transformAnimation.duration = 0.15;
    [self.layer addAnimation:transformAnimation forKey:@"ContentTransform"];
    self.layer.transform = [transformAnimation.toValue CATransform3DValue];
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}


#pragma mark - UITextDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == textAmount) {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:NUMERICS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
     [self getViewTransform];
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -125);
    }];
    return YES;
}
-(void)keybordEndEditing
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

#pragma mark - IBAction

-(IBAction)actionGetReason:(UIButton *)sender{
    
    [self keybordEndEditing];
    NSMutableArray *arrayReason = [NSMutableArray new];
    [[HRMAPIHandler handler] getReasonForIncreamentWithSuccess:^(NSDictionary *responseDict) {
        [responseDict[@"appraisalsType"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayReason addObject:obj[@"type"]];
        }];
        if (arrayReason.count > 0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height);
            }];
            [HRMPicker showWithArray:arrayReason didSelect:^(NSString *data, NSInteger index) {
                reasonID = responseDict[@"appraisalsType"][index][@"id"];
                [sender setTitle:[data stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forState:UIControlStateNormal];
            }];
        }else [HRMToast showWithMessage:NO_REASON_AVAILABLE];
    } failure:^(NSError *error) {
    }];
}

-(IBAction)actionTransformIdentity:(UITapGestureRecognizer*)recognise{
    [textDescription resignFirstResponder];
    [self getViewTransform];
}

- (IBAction)actionAddIncreament:(id)sender {
    
    [self keybordEndEditing];
    if ([textAmount.text validateWithString:ENTER_AMOUNT] && [reasonID validateWithString:ENTER_REASON_INCREAMENT] && [textDescription.text validateWithString:ENTER_DESCRIPTION]) {
        [[HRMAPIHandler handler] increamentedSalaryForemployeeID:employee date:buttonDate.titleLabel.text amount:textAmount.text reason:reasonID andDescription:textDescription.text WithSuccess:^(NSDictionary *responseDict) {
            [self.delegate didFinishAction];
        [self dismiss];
        } failure:^(NSError *error) {
        [self dismiss];
        }];
    }
    
}

- (IBAction)actionSelectDate:(id)sender {
    
     [self keybordEndEditing];
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height);
    }];
    [HRMDatePickerView showWithDateWithMaximumDate:^(NSDate *date) {
        [sender setTitle:[date stringFromDate] forState:UIControlStateNormal];
    } date:[NSDate date] isMax:NO];
}

@end
