//
//  NSData+Base64.h
//  LooCha
//
//  Created by 熊 财兴 on 12-1-5.
//  Copyright (c) 2012年 真云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Base64)

+ (id)dataWithBase64EncodedString:(NSString *)string;    

- (NSString *)base64Encoding;

@end
