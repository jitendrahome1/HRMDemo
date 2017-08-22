//
//  NSDate+Extra.h
//  
//
//  Created by Priyam Dutta on 08/10/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Extra)

-(NSString *)stringFromDate;
-(NSString *)stringFromTime;
-(NSString*)stringFromDateWithFormat:(NSString *)strDateFormat;
-(NSString*)getMonthYearStringFromDate;
-(NSInteger)getDay;
-(NSString*)getDayString;
+(NSInteger)getMonth;
-(NSString*)getMonthString;
-(NSInteger)getYear;
//-(NSString*)stringFromDateFormat:(NSDate *)strDate;
+(NSArray *)getAllMonths;
+(NSArray *)getAllYearList;
+(NSArray *)getAllMonthsUptoCurrentMonths;
@end
