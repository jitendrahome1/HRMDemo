//
//  HRMCorrectionView.m
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMCorrectionView.h"

static UIView *overlayView;

@implementation HRMCorrectionView

+(void)showCorrectionViewWithDictionary:(NSDictionary *)info
{
    HRMCorrectionView *correctionView = [[HRMCorrectionView alloc] init];
    correctionView.datasource = info;
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:correctionView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance] getNIBNameForOriginalNIBName:NSStringFromClass([self class])] owner:self options:nil] firstObject];
        if(IS_IPAD)
            self.layer.cornerRadius = 10.0;
        else
            self.layer.cornerRadius = 5.0;
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
            if(IS_IPAD)
                obj.layer.cornerRadius = 8.0;
            else
                obj.layer.cornerRadius = 4.0;
            obj.clipsToBounds = YES;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            labelProject.text = [NSString stringWithFormat:@"%@", _datasource[@"project"]];
            labelTime.text = [NSString stringWithFormat:@"%@", _datasource[@"time"]];
            labelDate.text = [NSString stringWithFormat:@"%@", _datasource[@"date"]];
            textDescription.text = @"";
        });
    }
    return self;
}

-(IBAction)actionTransformIdentity:(UITapGestureRecognizer*)recognise{
    [textDescription resignFirstResponder];
    [UIView animateWithDuration:0.15 animations:^{
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
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
    [overlayView removeFromSuperview];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -155);
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

- (IBAction)actionSubmit:(UIButton *)sender {
    [self keybordEndEditing];
    if ([textDescription.text validateWithString:ENTER_REQUEST]) {
         if([[[HRMHelper sharedInstance]trim:textDescription.text]length] == 0)
         [HRMToast showWithMessage:ENTER_REQUEST];
         else
         {
         [self dismiss];
        [[HRMAPIHandler handler] requestEmployeeTimesheetCorrectionWithTimsheetId:_datasource[@"timesheetID"] andRequest:textDescription.text WithSuccess:^(NSDictionary *responseDict) {
           
            [HRMToast showWithMessage:REQUEST_SUCCESS];
        } failure:^(NSError *error) {
            
        }];
    }
    }
}


@end
