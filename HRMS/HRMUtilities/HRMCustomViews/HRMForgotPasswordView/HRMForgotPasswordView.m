//
//  HRMForgotPasswordView.m
//  HRMS
//
//  Created by Jitendra Agarwal on 09/05/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMForgotPasswordView.h"

@implementation HRMForgotPasswordView
{
       UIView *overlayView;
}

+(void)showForgotPasswordView
{
    HRMForgotPasswordView *passwordView = [[HRMForgotPasswordView alloc] init];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:passwordView];
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = IS_IPAD?[views lastObject]:[views firstObject];
        [self setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
        self.layer.transform = CATransform3DMakeTranslation(0, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y, 0);
        CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
        transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transform.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
        transform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transform.duration = 0.15;
        [self.layer addAnimation:transform forKey:@"ContentTransform"];
        self.layer.transform = [transform.toValue CATransform3DValue];
        [self addOverLay];
        [buttonOK addTarget:self action:@selector(actionSendForPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)addOverLay
{
    overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayView.alpha = 0.0f;
    overlayView.backgroundColor = [UIColor blackColor];
    
    [overlayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @(overlayView.layer.opacity);
    fadeAnimation.toValue = @(0.6f);
    fadeAnimation.duration = 0.15;
    [overlayView.layer addAnimation:fadeAnimation forKey:@"BackgroundOpacity"];
    overlayView.layer.opacity = [fadeAnimation.toValue floatValue];
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:overlayView];

}
-(void)dissmiss
{
    [self endEditing:YES];
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.delegate = self;
    fadeAnimation.fromValue = @(overlayView.layer.opacity);
    fadeAnimation.toValue = @(0.0f);
    fadeAnimation.duration = 0.15;
    [overlayView.layer addAnimation:fadeAnimation forKey:@"BackgroundOpacity"];
    overlayView.layer.opacity = [fadeAnimation.toValue floatValue];
    
    CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
    transform.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
    transform.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height, 0)];
    transform.duration = 0.15;
    transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:transform forKey:@"ContentTransform"];
    self.layer.transform= [transform.toValue CATransform3DValue];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
    [overlayView removeFromSuperview];
}

- (void)keyBoardDissmiss
{
   [self endEditing:YES];
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
}
#pragma mark - UITextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txtCompnayName)
     [txtEmailAddress becomeFirstResponder];
    if(textField == txtEmailAddress)
   {
    [textField resignFirstResponder];

    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -100);
    }];

    return YES;
}
#pragma mark - Button Action
-(IBAction)actionSendForPassword:(UIButton *)sender
{
        [self keyBoardDissmiss];
       if ([txtCompnayName.text validateWithString:COMPANY_VALIDATION] && [txtEmailAddress.text validateEmail]  ) {
            [self dissmiss];
               [[HRMAPIHandler handler] forgotPasswordWithCompanyName:txtCompnayName.text andEmail:txtEmailAddress.text withSuccess:^(NSDictionary *responseDict) {
                   
               } failure:^(NSError *error) {
                   
               }];
    }
}
@end
