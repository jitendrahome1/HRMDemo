//
//  NSArray+Extras.m
//  Presit
//
//  Created by Priyam Dutta on 04/02/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "NSArray+Extras.h"

@implementation NSArray (Extras)

-(BOOL)containsObjectOfType:(Class)type
{
    for (id obj in self) {
        if ([obj isKindOfClass:type]) {
            return YES;
        }
    }
    return NO;
}

@end
