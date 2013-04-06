//
//  NSDate+Extends.m
//  LooCha
//
//  Created by 熊 财兴 on 11-11-14.
//  Copyright (c) 2011年 真云. All rights reserved.
//

#import "NSDate+Extends.h"

@implementation NSDate(Extends)

- (NSDateComponents *)dateComponents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond;
    return [calendar components:unitFlags fromDate:self];
}

//获取日
- (NSUInteger)getDay{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
	return [dayComponents day];
}
//获取月
- (NSUInteger)getMonth
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
	return [dayComponents month];
}
//获取年
- (NSUInteger)getYear
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
	return [dayComponents year];
}

//获取小时
- (int )getHour {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	NSInteger hour = [components hour];
	return (int)hour;
}
//获取分钟
- (int)getMinute {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
	NSDateComponents *components = [calendar components:unitFlags fromDate:self];
	NSInteger minute = [components minute];
	return (int)minute;
}


- (NSString *)prettyDateWithReference:(NSDate *)reference {
    float diff = [reference timeIntervalSinceDate:self];
    float day_diff = floor(diff / 86400);
    if (day_diff <= 0) {
        if (diff < 60) return NSLocalizedString(@"just now", @"");
        if (diff < 120) return [NSString stringWithFormat:@"%d %@", 1, NSLocalizedString(@"minute ago", @"")];
        if (diff < 3600) return [NSString stringWithFormat:@"%d %@", (int)floor( diff / 60 ), NSLocalizedString(@"minute ago", @"")];
        if (diff < 7200) return [NSString stringWithFormat:@"%d %@", 1, NSLocalizedString(@"hours ago", @"")];
        if (diff < 86400) return [NSString stringWithFormat:@"%d %@", (int)floor( diff / 3600 ), NSLocalizedString(@"hours ago", @"")];
    } /*
       else if (day_diff == 1) {
       return [NSString stringWithFormat:@"%d%@", (int)day_diff, NSLocalizedString(@"days ago", @"")];
       } else if (day_diff < 7) {
       return [NSString stringWithFormat:@"%d%@", (int)day_diff, NSLocalizedString(@"days ago", @"")];
       } 
       else if (day_diff < 31) {
       return [NSString stringWithFormat:@"%d%@", (int)ceil( day_diff / 7 ), NSLocalizedString(@"weeks ago", @"")];
       } else if (day_diff < 365) {
       return [NSString stringWithFormat:@"%d%@", (int)ceil( day_diff / 30 ), NSLocalizedString(@"months ago", @"")];
       } else {
       return [NSString stringWithFormat:@"%d%@", (int)ceil( day_diff / 365 ), NSLocalizedString(@"years ago", @"")];
       }*/
    
    return [self parseDateWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)prettyDateWithReferenceMMDD:(NSDate *)reference {
    float diff = [reference timeIntervalSinceDate:self];
    float day_diff = floor(diff / 86400);
    if (day_diff <= 0) {
        if (diff < 60) return NSLocalizedString(@"just now", @"");
        if (diff < 120) return [NSString stringWithFormat:@"%d %@", 1, NSLocalizedString(@"minute ago", @"")];
        if (diff < 3600) return [NSString stringWithFormat:@"%d %@", (int)floor( diff / 60 ), NSLocalizedString(@"minute ago", @"")];
        if (diff < 7200) return [NSString stringWithFormat:@"%d %@", 1, NSLocalizedString(@"hours ago", @"")];
        if (diff < 86400) return [NSString stringWithFormat:@"%d %@", (int)floor( diff / 3600 ), NSLocalizedString(@"hours ago", @"")];
    }
    return [self parseDateWithFormat:@"MM-dd"];
}


- (NSString *)prettyDate {
    return [self prettyDateWithReference:[NSDate date]];
}

- (NSString*) parseDateWithFormat:(NSString*)theFormat {
    NSDateFormatter *dateFormatter;
    dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = theFormat;
	return [dateFormatter stringFromDate:self];
}

+ (NSString*) parseDateWithFormat:(NSString*)theFormat withTimeStr:(NSString *)timeStr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr floatValue]/1000];
    return [NSDate parseDateWithFormat:theFormat theDate:date];
}

+ (NSString*) parseDateWithFormat:(NSString*)theFormat theDate:(NSDate*)theDate
{
    NSDateFormatter *dateFormatter;
	
    dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = theFormat;
	return [dateFormatter stringFromDate:theDate];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString*)theFormatter
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter autorelease];
    
    return destDate;
    
}
@end
