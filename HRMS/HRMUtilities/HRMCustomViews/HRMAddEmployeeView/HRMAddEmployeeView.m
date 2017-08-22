//
//  HRMAddEmployeeView.m
//  HRMS
//
//  Created by Priyam Dutta on 30/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMAddEmployeeView.h"

@implementation HRMAddEmployeeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)instantiateFromNib
{
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance] getNIBNameForOriginalNIBName:NSStringFromClass([self class])] owner:nil options:nil] ;
    
    return [views firstObject];
    
}

/*-(instancetype)initWithView:(UIViewController *)parentView isOpen:(BOOL)isOpen
{
    self=[super init];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance] getNIBNameForOriginalNIBName:NSStringFromClass([self class])] owner:nil options:nil] firstObject];
        
        if (isOpen == YES)
        {
            CGRect frame = self.frame;
            frame.origin.y = parentView.view.frame.size.height + 50;
            self.frame = frame;
            [UIView animateWithDuration:0.5f animations:^
             {
                 CGRect frame = self.frame;
                 frame.origin.y = parentView.view.frame.size.height - frame.size.height + 70;
                 self.frame = frame;
                 
             } completion:^(BOOL finished) {
                 
             }];
        }
        else
        {
            CGRect frame = self.frame;
            frame.origin.y = parentView.view.frame.size.height - frame.size.height;
            self.frame = frame;
            [UIView animateWithDuration:0.5f animations:^
             {
                 CGRect frame = self.frame;
                 frame.origin.y = parentView.view.frame.size.height + 5;
                 self.frame = frame;
                 
             } completion:^(BOOL finished)
            {
                [self removeFromSuperview];
                 
             }];
        }
        }
        
    
    return self;
}

+(void)showAddEmployeeViewOnView:(UIViewController *)controller isOpen:(BOOL)isOpen
{
    if (isOpen)
    {
        HRMAddEmployeeView *addEmployeeView = [[HRMAddEmployeeView alloc] initWithView:controller isOpen:isOpen];
        [[UIApplication sharedApplication].keyWindow addSubview:addEmployeeView];
    }
    else
    {
    }
    
}*/

@end
