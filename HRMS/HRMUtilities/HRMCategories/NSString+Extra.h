//
//  NSString+Extra.h
//  Presit
//
//  Created by Priyam Dutta on 07/12/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extra)

-(NSDate*)dateFromStringWithFormat:(NSString *)format;
-(BOOL)validateEmail;
-(BOOL)validatePassword;
-(BOOL)validatePhone;
-(BOOL)validateEmailForLeave:(NSInteger)number;
-(BOOL)validateWithString:(NSString *)string;
-(BOOL)matchesString:(NSString*)string;
-(NSString *)filterWebLink;

-(CGSize)getLabelSizeForWidth:(float)width withFont:(UIFont *)font;

@end
