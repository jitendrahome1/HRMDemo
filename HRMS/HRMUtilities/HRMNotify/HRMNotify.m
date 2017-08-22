//
//  HRMNotify.m
//  HRMS
//
//  Created by Priyam Dutta on 10/06/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMNotify.h"

@interface HRMNotify()
{
    UIDynamicAnimator *animator;
    UIGravityBehavior *gravityBehave;
    UICollisionBehavior *collisionBehave;
}
@end

@implementation HRMNotify

+(void)showNotificationWithTitle:(NSString *)title andDescription:(NSString *)description
{
    HRMNotify *notifyView = [[HRMNotify alloc] initWithTitle:title andDescription:description];
    [[[UIApplication sharedApplication] keyWindow] addSubview:notifyView];
}


-(instancetype)initWithTitle:(NSString *)title andDescription:(NSString *)description
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64.0);
        self.backgroundColor = [UIColor darkGrayColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
            
            gravityBehave = [[UIGravityBehavior alloc] initWithItems:@[self]];
            
            collisionBehave = [[UICollisionBehavior alloc] initWithItems:@[self]];
            [collisionBehave addBoundaryWithIdentifier:@"bound" fromPoint:CGPointMake(CGRectGetMidX(self.superview.frame), CGRectGetMinY(self.superview.frame)) toPoint:CGPointMake(CGRectGetWidth(self.superview.frame), CGRectGetHeight(self.superview.frame))];
            
            
            [animator addBehavior:gravityBehave];
            [animator addBehavior:collisionBehave];
        });
    }
    return  self;
}

@end
