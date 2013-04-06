//
//  NSString+Extends.m
//  LooCha
//
//  Created by 熊 财兴 on 11-11-14.
//  Copyright (c) 2011年 真云. All rights reserved.
//

#import "NSString+Extends.h"

@implementation NSString(Extends)

- (NSString *)lowercaseFirstCharacter {
	NSRange range = NSMakeRange(0,1);
	NSString *lowerFirstCharacter = [[self substringToIndex:1] lowercaseString];
	return [self stringByReplacingCharactersInRange:range withString:lowerFirstCharacter];
}

- (NSString *)uppercaseFirstCharacter {
	NSRange range = NSMakeRange(0,1);
	NSString *upperFirstCharacter = [[self substringToIndex:1] uppercaseString];
	return [self stringByReplacingCharactersInRange:range withString:upperFirstCharacter];
}

- (BOOL)isEmpty {
	NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *trimmed = [self stringByTrimmingCharactersInSet:charSet];
	return [trimmed isEqualToString:@""];
}

- (BOOL)isNotEmpty {
    return ![self isEmpty];
}

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString*) substringFrom: (NSInteger) a to: (NSInteger) b {
	NSRange r;
	r.location = a;
	r.length = b - a;
	return [self substringWithRange:r];
}

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSString *)stringByDeletingFirstPathComponent
{
    /* 
     * 0 : not begin
     * 1 : begin
     * 2 : in
     * 3 : end
     * 4 : stop
     */
    int flag = 0;
    int i = 0;
    while (i < [self length]) {
        if ([self characterAtIndex:i] == '/') {
            switch (flag) {
                case 0: flag = 1; break;
                case 1:           break;
                case 2: flag = 3; break;
                case 3:           break;
                default:          break;
            }
        }
        else {
            switch (flag) {
                case 0: flag = 1; break;
                case 1: flag = 2; break;
                case 2:           break;
                case 3: flag = 4; goto ____END;
                default:          break;
            }
        }
        i++;
    }
____END:
    if (flag == 4) {
        return [self substringFromIndex:i - 1];
    }
    return @"/";
}

@end
