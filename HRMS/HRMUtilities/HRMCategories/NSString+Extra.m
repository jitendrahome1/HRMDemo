//
//  NSString+Extra.m
//  Presit
//
//  Created by Priyam Dutta on 07/12/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "NSString+Extra.h"

@implementation NSString (Extra)

-(NSDate*)dateFromStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}

-(BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:self]) {
        [HRMToast showWithMessage:MAIL_VALIDATION];
    }
    return [emailTest evaluateWithObject:self];
}

-(BOOL)validateEmailForLeave:(NSInteger)number
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:self]) {
        [HRMToast showWithMessage:[NSString stringWithFormat:@"%@%d %@",MAIL_VALIDATION_ON, number, NOT_VALID]];
    }
    return [emailTest evaluateWithObject:self];
}

-(BOOL)validatePassword
{
    if ([self length] < 8) {
//        [PRNetworkToast showNetworkBannerWithMessage:PASSWORD_VALIDATION];
        return NO;
    }
    else return YES;
}

-(BOOL)validatePhone
{
    if ([self length] != 10) {
        [HRMToast showWithMessage:PHONE_VALIDATION];
        return NO;
    }
    return YES;
}

-(BOOL)validateWithString:(NSString *)string{
    if ([self length] < 1) {
                [HRMToast showWithMessage:string];
        return NO;
    }
    return YES;
}

-(BOOL)matchesString:(NSString*)string
{
    if ([self isEqualToString:string])
        return YES;
    else{
        [HRMToast showWithMessage:PASSWORD_NOT_MATCH];
        return NO;
    }
}

-(CGSize)getLabelSizeForWidth:(float)width withFont:(UIFont *)font
{
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    // Get the size of the text given the CGSize we just made as a constraint
    CGRect titleRect = [self boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil];
    return titleRect.size;
}

-(NSString *)filterWebLink
{
    NSString *linkString = [[self componentsSeparatedByString:@"www."] lastObject];
    return  [NSString stringWithFormat:@"http://www.%@", linkString];
}

@end
