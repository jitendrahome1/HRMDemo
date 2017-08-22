//
//  HRMHelper.m
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMHelper.h"

@implementation HRMHelper

@synthesize queue,queueCount,backgroundQueue;

+(HRMHelper *)sharedInstance
{
    static HRMHelper *sharedInstance_ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance_ = [[HRMHelper alloc] init];
        sharedInstance_.queue = [[NSOperationQueue alloc] init];
        [sharedInstance_.queue setMaxConcurrentOperationCount:1];
        sharedInstance_.backgroundQueue = dispatch_queue_create("SFQueue", NULL);
    });
    
    return sharedInstance_;
}

-(void)insertIntoQueue:(NSInvocationOperation *)_operation
{
    [self.queue addOperation:_operation];
    self.queueCount--;
    
    if(self.queueCount<1)
        self.queueCount = 1;
}

#pragma mark - Get Label Size

-(CGSize)getLabelSizeFortext:(NSString *)text forWidth:(float)width WithFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    // Get the size of the text given the CGSize we just made as a constraint
    
    CGRect titleRect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil];
    return titleRect.size;
    
}

//Returns the message size
-(CGSize)getLabelSizeFortext:(NSString *)text forHeight:(float)height WithFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(MAXFLOAT, height);
    // Get the size of the text given the CGSize we just made as a constraint
    
    CGRect titleRect = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil];
    return titleRect.size;
    
}

#pragma mark - Animations
#pragma mark - Button Clicked

-(void)animateButtonClickedZoom:(UIButton *)sender completion:(void(^)(void))competed{

    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            sender.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if(competed)
                competed();
        }];
    }];
}

#pragma mark -
#pragma mark - Drawer

-(void)setBackButton:(BOOL)set
{
    if(set == YES)
    {
        _canOpenDrawer = NO;
        [[[[HRMNavigationalHelper sharedInstance] headerViewController] btnHeaderMenu] setCurrentModeWithAnimation:HRMSHamburgerButtonModeArrow];
    }
    else
    {
        _canOpenDrawer = YES;
        [[[[HRMNavigationalHelper sharedInstance] headerViewController] btnHeaderMenu] setCurrentModeWithAnimation:HRMSHamburgerButtonModeHamburger];
    }
}

#pragma mark - 
#pragma mark - Toast
-(void)showToast:(BOOL)show message:(NSString *)message animated:(BOOL)animated
{
    if (show) {
        if (!self.tostView) {
            UIView *networktostView = [[UIView alloc] init];
            networktostView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width-40, 50);
            networktostView.backgroundColor = kDefaultColor;
            
            //   networktostView.layer.borderColor = [UIColor whiteColor].CGColor;
            //   networktostView.layer.borderWidth = 1.0f;
            
            UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
            [window addSubview:networktostView];
            networktostView.alpha = 0.0f;
            self.tostView=networktostView;
            
            UILabel *mesgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.tostView.frame.size.width-10, self.tostView.frame.size.height-10)];
            mesgLabel.font = [UIFont fontWithName:kHRMSFont size:IS_IPAD ? 30 : 16];
            mesgLabel.textColor = [UIColor whiteColor];
            mesgLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mesgLabel.numberOfLines = 20;
            mesgLabel.backgroundColor = [UIColor clearColor];
            mesgLabel.textAlignment = NSTextAlignmentCenter;
            [self.tostView addSubview:mesgLabel];
            self.tostLabel=mesgLabel;
        }
        self.tostView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width-40, 40);
        self.tostLabel.frame = CGRectMake(5, 5, self.tostView.frame.size.width-10, self.tostView.frame.size.height-10);
        
        CGSize size = [self getLabelSizeFortext:message forWidth:self.tostLabel.frame.size.width WithFont:self.tostLabel.font];
        self.tostView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-(size.width+40))/2, [UIScreen mainScreen].bounds.size.height-(size.height + 50), size.width+40, size.height+25);
        self.tostLabel.frame = CGRectMake(20, 10, self.tostView.frame.size.width-40, self.tostView.frame.size.height-25);
        self.tostLabel.text = message;
        self.tostView.layer.cornerRadius = self.tostView.frame.size.height/2;
        if (animated) {
            [UIView animateWithDuration:0.4 animations:^{
                self.tostView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showToast:NO message:@"" animated:YES];
                });
            }];
        }
        else {
            self.tostView.alpha = 1.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showToast:NO message:@"" animated:YES];
            });
        }
    }
    else {
        if (animated) {
            [UIView animateWithDuration:0.4 animations:^{
                self.tostView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
            }];
        }
        else {
            self.tostView.alpha = 0.0f;
        }
    }
}

#pragma mark- 
#pragma image circle
-(UIImage *)imageCircle:(NSString  * )path ImageView:(UIImageView *)ImageView
{
    ImageView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:path]]];
    ImageView.layer.cornerRadius = ImageView.frame.size.width / 2;
    ImageView.clipsToBounds = YES;
    return ImageView.image;
}

#pragma mark- Defult image
-(UIImage *)imageDefaul:(UIImageView *)imageDefult
{
    imageDefult.image=  [UIImage imageNamed:@"BigGrayImage"];
    imageDefult.layer.cornerRadius =        imageDefult.frame.size.width / 2;
    imageDefult.layer.borderWidth = 2.5;
    imageDefult.layer.borderColor = UIColorRGB(194.0, 224.0, 241.0, 1.0).CGColor;
    imageDefult.clipsToBounds = YES;
    return imageDefult.image;
}
#pragma mark -
#pragma mark - Append iPad || iPhone on nib names

-(NSString *)getStoryboardNameForOriginalName:(NSString *)originalName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [NSString stringWithFormat:@"%@_iPad", originalName];
    }
    else{
        return [NSString stringWithFormat:@"%@_iPhone", originalName];
    }
}

-(NSString *)getNIBNameForOriginalNIBName:(NSString *)originalNIBName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [NSString stringWithFormat:@"%@_iPad", originalNIBName];
    }
    else{
        return [NSString stringWithFormat:@"%@_iPhone", originalNIBName];
    }
}

#pragma mark - 
#pragma mark - Spinner

-(void)addLoadingSpinnerInparentView:(UIView*)inview
{
    CGFloat y_posinitionForHeader = 0.0;
    
            y_posinitionForHeader = IS_IPAD ? 64 /2 : 44/2;
    
    
    if (!_loadingSpinner) {
        HRMMaterialSpinner *spinner = [[HRMMaterialSpinner alloc] init];
        
        
        
        UIView *view=[inview viewWithTag:10];
        if (!view)
        {
            _loadingSpinner=spinner;
            spinner.tag = 10;
            spinner.bounds = IS_IPAD ? CGRectMake(0, 0, 60, 60) : CGRectMake(0, 0, 30, 30);
            spinner.tintColor = kDefaultColor;
            spinner.center = CGPointMake(CGRectGetMidX(inview.bounds), CGRectGetMidY(inview.bounds));
            // self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
           spinner.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
          //  [UIView addSubview:spinner];
        }
        spinner.hidesWhenStopped=YES;
        
    }
    if (_loadingSpinner.superview) {
        [_loadingSpinner removeConstraints:_loadingSpinner.superview.constraints];
    }
    
  //  _loadingSpinner.frame = CGRectMake(inview.frame.size.width/2 - 130 , (inview.frame.size.height - y_posinitionForHeader )/2 - 130 , 260, 260);
    
    [inview addSubview:_loadingSpinner];
    _loadingSpinner.alpha = 0.0f;
    
}

-(void)showSpinnerOnparentView:(UIViewController*)inview userInteraction:(BOOL)userinteraction completion:(void(^)(void))completion
{
    [self addLoadingSpinnerInparentView:inview.view];
    _isSpinnerShowing = YES;
    //Disable Navigation gesture And View interaction
    inview.navigationController.interactivePopGestureRecognizer.enabled = userinteraction;
    inview.view.userInteractionEnabled = userinteraction;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Show the spinner and update constraint according to the Orientation
        
        [self.loadingSpinner startAnimating];
        self.loadingSpinner.alpha = 1.0f;
        
        [inview.view setNeedsUpdateConstraints];
        [inview.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (completion) completion();
    }];
}

-(void)hideSpinnerParentView:(UIViewController*)inview completion:(void (^)(void))completion
{
    _isSpinnerShowing = NO;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // hide the spinner and update constraint according to the Orientation
        
        [self.loadingSpinner stopAnimating];
        self.loadingSpinner.alpha = 0.0f;
        
        [inview.view setNeedsUpdateConstraints];
        [inview.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        inview.view.userInteractionEnabled = YES;
        inview.navigationController.interactivePopGestureRecognizer.enabled = YES;
        // If there is a completion then call that
        if (completion) completion();
    }];
}

#pragma mark - 
#pragma mark - String

-(NSString *)checkNullStringAndReplace:(NSString*)_inputString{
    NSString *InputString=@"";
    InputString=[NSString stringWithFormat:@"%@",_inputString];
    if((InputString == nil) ||(InputString ==(NSString *)[NSNull null])||([InputString isEqual:nil])||([InputString isKindOfClass:[NSNull class]])||([InputString length] == 0)||[allTrim( InputString ) length] == 0||([InputString isEqualToString:@""])||([InputString isEqualToString:@"(NULL)"])||([InputString isEqualToString:@"<NULL>"])||([InputString isEqualToString:@"<null>"]||([InputString isEqualToString:@"(null)"])|| ([InputString isEqualToString:@"null"]) || ([InputString isEqualToString:@""])))
        return @"";
    else
        return _inputString ;
    
}
#pragma mark- Remove Space
-(NSString*)trim:(NSString*)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
}
#pragma mark - method which shows no record label if there is no record in the uitableview
-(void)showNoRecordsMessageForTableView:(UITableView *)aTableView inView:(UIView *)view withRecordCount:(int)numrecord strText:(NSString *)strText
{
    UILabel *  noRecordLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    noRecordLbl.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin);
    noRecordLbl.font =  FONT_REGULAR(IS_IPAD ? 25 : 18);
    noRecordLbl.textColor = [UIColor blackColor];
    [noRecordLbl setBackgroundColor:[UIColor clearColor]];
    [noRecordLbl setText:strText];
    if(numrecord > 0){
        [aTableView setHidden:NO];
        [noRecordLbl removeFromSuperview];
    }else{
       [aTableView setHidden:YES];
        CGRect rect = aTableView.frame;
        [noRecordLbl setTextAlignment:NSTextAlignmentCenter];
        [noRecordLbl setFrame:rect];
        [view addSubview:noRecordLbl];

    }
}


-(CGRect)getFrameWidthFromString:(NSString *)inputString withFrame:(CGRect)inputFrame withFont:(UIFont *)font
{
   // NSString *myText=@"111asljkhdoopp;ojdkl;nddklkskljdkasljkhdoopp;ojdkl;ndklkskljdkasljkhdoopp;ojdkl;ndkkl;nddklkskljdkasljkhdoopp;ojdkl;ndkww";
    
//    UIFont *font=[UIFont fontWithName:@"FuturaBT-Book" size:26];
 //   UIColor *color=[UIColor redColor];
  //  _lbltext.numberOfLines=-1;
    
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:inputString attributes:@{ NSFontAttributeName:font,}];
    CGRect reqFrame=[attrString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, inputFrame.size.height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
  //  _iblhght.constant=reqFrame.size.height;
  //  _lbltext.attributedText=attrString;
    return reqFrame;
}



@end
