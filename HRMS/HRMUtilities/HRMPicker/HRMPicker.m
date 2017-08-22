//
//  HRMPicker.m
//  HRMS
//
//  Created by Chinmay Das on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMPicker.h"

static UIView *overlayView;
@interface HRMPicker()
{
    __weak IBOutlet UIPickerView *picker;
    NSInteger selectedIndex;
}
@property (strong, nonatomic) void (^dataSelected)(NSString *data, NSInteger index);
@property (nonatomic ,strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *pickerSelectedLabel;

@end
@implementation HRMPicker

- (instancetype)initWithIndex:(NSInteger)indexSelected
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
        selectedIndex = 0;
        self.layer.transform = CATransform3DMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y, 0);
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        transformAnimation.duration = 0.10;
//        [self setInitialContents];
        [self.layer addAnimation:transformAnimation forKey:@"ContentTransform"];
        self.layer.transform = [transformAnimation.toValue CATransform3DValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [picker selectRow:indexSelected inComponent:0 animated:NO];
            selectedIndex = indexSelected;
            _pickerSelectedLabel.text = [_dataArray objectAtIndex:indexSelected];
        });
        [self addOverlay];
    }
    return self;
}

+(void)showWithArray:(NSArray*)dataArray didSelect:(void (^)(NSString *data, NSInteger index))dataSelected
{
    HRMPicker *pickerView = [[HRMPicker alloc] initWithIndex:0];
    pickerView.dataSelected = dataSelected;
    pickerView.dataArray = dataArray;
    if(dataArray.count > 0)
        pickerView.pickerSelectedLabel.text = [dataArray objectAtIndex:0];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:pickerView];
}

+(void)showWithArrayWithSelectedIndex:(NSInteger)index andArray:(NSArray*)dataArray didSelect:(void (^)(NSString *data, NSInteger index))dataSelected
{
    HRMPicker *pickerView = [[HRMPicker alloc] initWithIndex:index];
    pickerView.dataSelected = dataSelected;
    pickerView.dataArray = dataArray;
    
   
    if(dataArray.count > 0)
        pickerView.pickerSelectedLabel.text = [dataArray objectAtIndex:0];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:pickerView];
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

- (IBAction)DoneButtonClicked:(id)sender {
    if (self.dataArray.count > 0)
    {
        if (_dataSelected != nil) {
            _dataSelected([self.dataArray objectAtIndex:selectedIndex] ,selectedIndex);
        }
    }
    [self dismiss];
}
#pragma mark - UIPickerViewDelegate Mathods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerSelectedLabel.text = [_dataArray objectAtIndex:row];
    selectedIndex = row;
}

@end
