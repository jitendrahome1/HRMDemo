//
//  HRMAppraisalPinView.m
//  HRMS
//
//  Created by Jitendra on 8/2/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMAppraisalPinView.h"

@implementation HRMAppraisalPinView

{
    UIView *overlayView;
    NSString* fullString ;
}
+(void)showPasscodePinView:(UIViewController*)onParentVC
{
    HRMAppraisalPinView *pinView = [[HRMAppraisalPinView alloc] init];
    pinView.delegate = onParentVC;
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:pinView];
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = IS_IPAD?[views lastObject]:[views firstObject];
        
        [self setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/3)];
        
        self.layer.transform = CATransform3DMakeTranslation(0, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y, 0);
        
        CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
        transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transform.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
        transform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transform.duration = 0.15;
        [self.layer addAnimation:transform forKey:@"ContentTransform"];
        self.layer.transform = [transform.toValue CATransform3DValue];
        self.layer.cornerRadius = 10.0;
        [self.textField becomeFirstResponder];
        [self addOverLay];
        
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
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    fullString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    
    
    
    if([textField.text length]== 6 && [string length]>0)
    {     fullString = [fullString substringToIndex:[fullString length] - 1];
        NSLog(@"cant enter more than 6 character");
        return NO;
    }
    else
    {
        if ([string isEqualToString:@""]) {
            fullString = [fullString substringToIndex:[fullString length] - 1];
            
            
        }
        NSLog(@"type String : %@",fullString);
        [self.passcodeView setProgress:fullString.length];
    }
    return YES;
}


- (IBAction)actionCancel:(id)sender {
    [self dissmiss];
    
}
- (IBAction)actionOk:(id)sender {
    if([fullString length]==0)
    {
        [self dissmiss];
        
    }
    else
    {
        [self dissmiss];
        [self.delegate HRMViewControllerOkAction:fullString];
        
    }
    
}


@end
