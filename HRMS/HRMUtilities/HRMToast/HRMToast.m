//
//  PMToast.m
//  PampMe
//
//  Created by Rupam Mitra on 28/09/15.
//  Copyright (c) 2015 Indus Net. All rights reserved.
//

#import "HRMToast.h"

@implementation HRMToast

-(instancetype)initWithMessage:(NSString*)message
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width - 40, 50);
        self.backgroundColor = UIColorRGB(15, 15, 15, 0.7);
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
        messageLabel.font = FONT_REGULAR(IS_IPAD ? 18.0 : 14.0);
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.numberOfLines = 20;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
        self.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width - 40, 40);
        self.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10);
        
        CGSize size = [message getLabelSizeForWidth:CGRectGetWidth(messageLabel.frame) withFont:messageLabel.font];
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - (size.width + 40)) / 2, ([UIScreen mainScreen].bounds.size.height) - ((size.height / 2)) - 100, size.width + 40, size.height + 10);
        messageLabel.frame = CGRectMake(20, 5, self.frame.size.width - 40, self.frame.size.height-10);
        messageLabel.text = message;
        self.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds])-50);
        self.layer.cornerRadius = 5;
    }
    return self;
}

+(void)showWithMessage:(NSString*)message
{
    if (message) {
        HRMToast *toast = [[HRMToast alloc] initWithMessage:message];
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        if (![window.subviews containsObjectOfType:[HRMToast class]]) {
            [window addSubview:toast];
        }
        toast.transform = CGAffineTransformMakeScale(0.02, 0.02);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:toast duration:0.7 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                toast.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView transitionWithView:toast duration:0.25 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                        toast.transform = CGAffineTransformMakeScale(0.02, 0.02);
                    } completion:^(BOOL finished) {
                        [toast removeFromSuperview];
                    }];
                });
            }];
        });
    }
   /* [UIView animateWithDuration:1.0 animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = -1.0/500.0;
        rotate = CATransform3DRotate(rotate, M_PI, 1.0, 0.0, 0.0);
        toast.layer.transform = rotate;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast setAlpha:0.0];
            [toast removeFromSuperview];
        });
    }];*/
}

@end