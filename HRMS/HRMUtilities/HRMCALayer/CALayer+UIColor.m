//
//  CALayer+UIColor.m
//  HRMS
//
//  Created by Chinmay Das on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
