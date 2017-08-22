//
//  NSDate+Extra.m
//
//
//  Created by Priyam Dutta on 08/10/15.
//
//

#import "NSDate+Extra.h"

@implementation NSDate (Extra)

-(NSString *)stringFromDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    return [dateFormatter stringFromDate:self];
}

-(NSString *)stringFromTime
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm a"];
    return [dateFormatter stringFromDate:self];
}


-(NSString*)stringFromDateWithFormat:(NSString *)strDateFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat =strDateFormat;
   return [dateFormatter stringFromDate:self];
}
// * This get the current moths in string format *//
-(NSString*)getMonthYearStringFromDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMMM"];
    return [dateFormatter stringFromDate:self];
}
// * This get the current Day *//
-(NSInteger)getDay
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [components day];
}
// * This get the current Day in string format *//
-(NSString*)getDayString
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEE"];
    return [dateFormatter stringFromDate:self];
}
// * This get the current moths *//
+(NSInteger)getMonth
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth) fromDate:[NSDate date]];
    return [components month];
}
// * This get the current moths in string format *//
-(NSString *)getMonthString
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM"];
    return [dateFormatter stringFromDate:self];
}
// * This get the current year  *//
-(NSInteger)getYear
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear) fromDate:self];
    return [components year];
}
// * This get the all Moths  *//
+(NSArray *)getAllMonths
{
    NSMutableArray *arrMonths = [[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    for(int months = 0; months < 12; months++)
        [arrMonths addObject:[[dateFormatter monthSymbols]objectAtIndex:months]];
    return arrMonths;
}

+(NSArray *)getAllMonthsUptoCurrentMonths
{
    NSDate           *today           = [NSDate date];
    NSCalendar       *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yearComponents  = [currentCalendar components:NSYearCalendarUnit |    NSMonthCalendarUnit  fromDate:today];
    //int currentYear  = [yearComponents year];
    int currentmonth=[yearComponents month];
    NSMutableArray *arrMonths = [[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    for(int months = 0; months <currentmonth; months++)
        [arrMonths addObject:[[dateFormatter monthSymbols]objectAtIndex:months]];
    return arrMonths;
    
}

+(NSArray *)getAllYearList
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    //Create Years Array from 1960 to This year
   NSMutableArray * years = [[NSMutableArray alloc] init];
    for (int i=i2-1; i<=i2+1; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return years;
    }

@end
