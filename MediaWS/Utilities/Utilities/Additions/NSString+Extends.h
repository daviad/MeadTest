//
//  NSString+Extends.h
//  LooCha
//
//  Created by 熊 财兴 on 11-11-14.
//  Copyright (c) 2011年 真云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Extends)

// 第一个字符小写
- (NSString *)lowercaseFirstCharacter;

// 第一个字符大写
- (NSString *)uppercaseFirstCharacter;

// 判断字符串是否为含有空格
- (BOOL)isEmpty;

- (BOOL)isNotEmpty;

- (BOOL) containsString:(NSString*) aString;

- (NSString*) substringFrom: (NSInteger) a to: (NSInteger) b;

- (NSString *)urlencode;

- (NSString *)stringByDeletingFirstPathComponent;

@end
