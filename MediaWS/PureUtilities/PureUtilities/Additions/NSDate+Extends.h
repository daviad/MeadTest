//
//  NSDate+Extends.h
//  LooCha
//
//  Created by 熊 财兴 on 11-11-14.
//  Copyright (c) 2011年 真云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extends)
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString*)theFormatter;

- (NSDateComponents *)dateComponents;

- (NSUInteger)getDay;

- (NSUInteger)getMonth;

- (NSUInteger)getYear;

- (int )getHour;

- (int)getMinute;

- (NSString*) prettyDate;

- (NSString*) prettyDateWithReference:(NSDate*)reference;

- (NSString*) parseDateWithFormat:(NSString*)theFormat;
+ (NSString*) parseDateWithFormat:(NSString*)theFormat theDate:(NSDate*)theDate;
- (NSString *)prettyDateWithReferenceMMDD:(NSDate *)reference;
+ (NSString*) parseDateWithFormat:(NSString*)theFormat withTimeStr:(NSString *)timeStr;
@end
