//
//  WPDatePickerView.m
//  WeatherPOC
//
//  Created by Rupam Mitra on 29/07/15.
//  Copyright (c) 2015 Indus Net. All rights reserved.
//

#import "HRMDatePickerView.h"

static UIView *overlayView;

@interface HRMDatePickerView ()
{
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UIDatePicker *datePicker;
}
@property (strong, nonatomic) void (^dateSelected)(NSDate *date);
@end

@implementation HRMDatePickerView

- (instancetype)initWithDate:(NSDate *)date isMax:(BOOL)isMax
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance] getNIBNameForOriginalNIBName:NSStringFromClass([self class])] owner:self options:nil] firstObject];
        if (IS_IPAD)
        {
            [self setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
        }
        else
        {
            CGRect frame = self.frame;
            frame.size.width = [[UIScreen mainScreen] bounds].size.width ;
            self.frame = frame;
            [self setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height - self.frame.size.height/2)];
        }
        [self setInitialContentsDate];
        
        
        isMax ? [datePicker setMaximumDate:date] : [datePicker setMinimumDate:date];
        
        self.layer.transform = CATransform3DMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y, 0);
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transformAnimation.duration = 0.10;
        [self.layer addAnimation:transformAnimation forKey:@"ContentTransform"];
        self.layer.transform = [transformAnimation.toValue CATransform3DValue];
        [self addOverlay];
    }
    return self;
}

- (instancetype)initWithTime:(BOOL)timeMode
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance] getNIBNameForOriginalNIBName:NSStringFromClass([self class])] owner:self options:nil] firstObject];
        if (IS_IPAD)
        {
            [self setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
        }
        else
        {
            CGRect frame = self.frame;
            frame.size.width = [[UIScreen mainScreen] bounds].size.width ;
            self.frame = frame;
            [self setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height - self.frame.size.height/2)];
        }
            timeMode ? [self setInitialContentsTime] : [self setInitialContentsDate];
            self.layer.transform = CATransform3DMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y, 0);
            CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            transformAnimation.duration = 0.10;
            [self.layer addAnimation:transformAnimation forKey:@"ContentTransform"];
            self.layer.transform = [transformAnimation.toValue CATransform3DValue];
            [self addOverlay];
    }
    return self;
}

+(void)showWithDate:(void (^)(NSDate *date))dateSelected isTimeMode:(BOOL)isTrue
{
    HRMDatePickerView *datePickerView = [[HRMDatePickerView alloc] initWithTime:isTrue];
    datePickerView.dateSelected = dateSelected;
    datePickerView.timeMode = isTrue;
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:datePickerView];
}

+(void)showWithDateWithMaximumDate:(void (^)(NSDate *date))dateSelected date:(NSDate *)date isMax:(BOOL)isMax
{
    HRMDatePickerView *datePickerView = [[HRMDatePickerView alloc] initWithDate:date isMax:isMax];
    datePickerView.dateSelected = dateSelected;
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:datePickerView];
}

+(void)showWithYear:(void (^)(NSDate *date))dateSelected isTimeMode:(BOOL)isTrue
{
    HRMDatePickerView *datePickerView = [[HRMDatePickerView alloc] init];
    datePickerView.dateSelected = dateSelected;
    datePickerView.timeMode = isTrue;
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:datePickerView];
}


-(void)setInitialContentsDate
{
    datePicker.datePickerMode = UIDatePickerModeDate;
    lblDate.text = [datePicker.date stringFromDate];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)setInitialContentsTime
{
    datePicker.datePickerMode = UIDatePickerModeTime;
    lblDate.text = [datePicker.date stringFromTime];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)dateChanged:(UIDatePicker *)sender
{
    lblDate.text = _timeMode ? [sender.date stringFromTime] : [sender.date stringFromDate];
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
    transformAnimation.duration = 0.10;
    [self.layer addAnimation:transformAnimation forKey:@"ContentTransform"];
    self.layer.transform = [transformAnimation.toValue CATransform3DValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:kviewTransform object:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
    [overlayView removeFromSuperview];
}

-(IBAction)actionDone:(id)sender
{
    if (_dateSelected != nil) {
        _dateSelected(datePicker.date);
    }
    [self dismiss];
}

@end