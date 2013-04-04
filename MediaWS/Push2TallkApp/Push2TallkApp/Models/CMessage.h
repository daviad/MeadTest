//
//  CMessage.h
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-14.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kCMT_WTT = 1, // Want to talk
    kCMT_DNT = 2, // Do not talk or play
    kCMT_RDY = 3, // ready
    kCMT_ACK = 4, // acknowlage to last packet
    kCMT_HB  = 5, // busy
    kCMT_HB2 = 6  // busy
} CMessageType;

NSString *stringOfCMessageType(CMessageType type);

#define kCMessageHeaderCode 0x1010AAAAL
#define kSHA1Key            "0000"

#pragma mark - CMessage

// CMessage

typedef struct _CMessageHeader {
    long code_low;
    long code_high;
    CMessageType type;
    long sequenceNumber_low;
    long sequenceNumber_high;
    unsigned char signature[20];
} CMessageHeader;

#define makeLLong(high, low) (((long long)high << 32) | low)
#define lowLLong(llvalue)    ((long)llvalue)
#define highLLong(llvalue)   ((long)((unsigned long long)llvalue >> 32))

@interface CMessage : NSObject
{
@private
    CMessageHeader cMessageHeader;
}

@property (nonatomic, readonly) CMessageType type;
@property (nonatomic, readonly) long long sequenceNumber;

+ (id)cMessageFromPacket:(unsigned char *)packet length:(int)length;

- (id)initWithType:(CMessageType)type;

- (id)initWithType:(CMessageType)type sequenceNumber:(long long)sequenceNumber;

- (const unsigned char *)bytes;

- (int)length;

@end

#pragma mark - CMessageQueueEntity

// CMessageQueueEntity

@interface CMessageQueueEntity : NSObject
{
@private
    CMessage *cmsg;
    NSTimeInterval timestamp;
    NSInteger retryTimes;
}

@property (nonatomic, retain) CMessage *cmsg;
@property (nonatomic, readwrite) NSTimeInterval timestamp;
@property (nonatomic, readwrite) NSInteger retryTimes;

@end
