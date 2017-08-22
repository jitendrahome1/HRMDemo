//
//  HRMEmployeeHeaderView.m
//  HRMS
//
//  Created by Priyam Dutta on 03/10/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMEmployeeHeaderView.h"

@implementation HRMEmployeeHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance]getNIBNameForOriginalNIBName:[NSString stringWithFormat:@"%@", [self class]]] owner:nil options:nil];
    return [views firstObject];
}

@end
