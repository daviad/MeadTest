//
//  RCHelper.m
//  LoochaUtilities
//
//  Created by jinquan zhang on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCHelper.h"


#include <stdint.h>
#include <stdio.h>
#include  <sys/utsname.h>
// Core Foundation
#include <CoreFoundation/CoreFoundation.h>

// Cryptography
#include <CommonCrypto/CommonDigest.h>

// In bytes
#define FileHashDefaultChunkSizeForReadingData 4096


NSString *genUUID()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

CGPoint RCCenterOfRect(CGRect r)
{
    r.origin.x += r.size.width/2;
    r.origin.y += r.size.height/2;
    return r.origin;
}

float leftToFrameWithMargin(CGRect rect, float margin)
{
    return rect.origin.x + rect.size.width + margin;
}

float leftToFrame(CGRect rect)
{
    return leftToFrameWithMargin(rect, 0.0f);
}


float rightToFrameWithMargin(CGRect rect, float margin,float width)
{
    return rect.origin.x - width - margin;
}

float rightToFrame(CGRect rect, float width)
{
    return rightToFrameWithMargin(rect, 0.0f,width);
}

UIButton* allocWithNormalAndHighlightImageName(NSString *image1,NSString *image2)
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];
    return button;
}




//md5 function
CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,
                      (const void *)buffer,
                      (CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

NSString *md5File(NSString *filePath)
{
    CFStringRef md5hash = FileMD5HashCreateWithPath((CFStringRef)filePath,
                              FileHashDefaultChunkSizeForReadingData);
    NSLog(@"MD5 hash of file at path \"%@\": %@",filePath, (NSString *)md5hash);
    NSString *md5 = nil;
    if(md5hash)
    {
        md5 = [NSString stringWithString:(NSString *)md5hash];
        CFRelease(md5hash);
    }
    return md5;
}


CGPathRef newPathForRoundedRect(CGRect rect ,CGFloat radius)
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);
    
	return retPath;
}


void drawPathForRoundedRect(CGRect rect ,CGFloat radius,CGContextRef ctx, UIColor *color)
{
	CGRect innerRect = CGRectInset(rect, radius, radius);
  
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width+1;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height+1;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
    [color set];
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 1);
	CGContextMoveToPoint(ctx, innerRect.origin.x, outside_top);
	CGContextAddLineToPoint(ctx, inside_right, outside_top);
	CGContextAddArcToPoint(ctx, outside_right, outside_top, outside_right, inside_top, radius);
	CGContextAddLineToPoint(ctx, outside_right, inside_bottom);
	CGContextAddArcToPoint(ctx,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
    
	CGContextAddLineToPoint(ctx,  innerRect.origin.x, outside_bottom);
	CGContextAddArcToPoint(ctx,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGContextAddLineToPoint(ctx, outside_left, inside_top);
	CGContextAddArcToPoint(ctx,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    CGContextStrokePath(ctx);
}


CGFloat getCenterOriginX(CGSize outsz, CGSize innerSz)
{
    return  outsz.width/2 - innerSz.width/2;
}

NSString *machineName()
{
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone4CDMA";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone5GSMCDMA";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"Touch1";
    if ([platform isEqualToString:@"iPod2,1"])      return @"Touch2";
    if ([platform isEqualToString:@"iPod3,1"])      return @"Touch3";
    if ([platform isEqualToString:@"iPod4,1"])      return @"Touch4";
    if ([platform isEqualToString:@"iPod5,1"])      return @"Touch5";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad2WiFi";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad2CDMA";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPadMiniWiFi";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPadMini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPadMiniGSMCDMA";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad3WiFi";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad3GSMCDMA";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad4WiFi";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad4GSMCDMA";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}