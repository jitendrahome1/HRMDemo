//
//  HRMGlobals.m
//  HRMS
//
//  Created by Priyam Dutta on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMGlobals.h"

static HRMGlobals *globals = nil;

@implementation HRMGlobals

+(instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globals = [[HRMGlobals alloc] init];
    });
    return globals;
}

@end
