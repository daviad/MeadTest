//
//  CMessage.m
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-14.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "CMessage.h"
#import <stun/sha1.h>

NSString *stringOfCMessageType(CMessageType type)
{
    NSString *s = nil;
    switch (type) {
        case kCMT_WTT:
            s = @"kCMT_WTT";
            break;
        case kCMT_DNT:
            s = @"kCMT_DNT";
            break;
        case kCMT_RDY:
            s = @"kCMT_RDY";
            break;
        case kCMT_ACK:
            s = @"kCMT_ACK";
            break;
        case kCMT_HB:
            s = @"kCMT_HB";
            break;
        case kCMT_HB2:
            s = @"kCMT_HB2";
            break;
        default:
            s = @"unkown control message type";
            break;
    }
    return s;
}

#pragma mark - CMessage

@implementation CMessage

@synthesize type;
@synthesize sequenceNumber;

static long long s_sequenceNumber;

+ (long long)nextSequenceNumber
{
    int s;
    @synchronized(self) {
        s = s_sequenceNumber++;
    }
    return s;
}

- (CMessageType)type
{
    return ntohl(cMessageHeader.type);
}

- (long long)sequenceNumber
{
    return makeLLong(ntohl(cMessageHeader.sequenceNumber_low), ntohl(cMessageHeader.sequenceNumber_high));
}

+ (void)makeSignature:(CMessageHeader *)header
{
    hmac_sha1((uint8_t *)kSHA1Key, sizeof(kSHA1Key)-1, (uint8_t *)header, 20, header->signature);
}

+ (BOOL)checkSignature:(CMessageHeader *)header
{
    uint8_t signature[20];
    hmac_sha1((uint8_t *)kSHA1Key, sizeof(kSHA1Key)-1, (uint8_t *)header, 20, signature);
    return memcmp(header->signature, signature, 20) == 0;
}

+ (id)cMessageFromPacket:(unsigned char *)packet length:(int)length
{
    if (length >= sizeof(CMessageHeader)) {
        CMessageHeader *header = (CMessageHeader *)packet;
        if (header->code_low == 0 && ntohl(header->code_high) == kCMessageHeaderCode
            && [self checkSignature:header]) {
            CMessage *msg = [[[CMessage alloc] init] autorelease];
            memcpy(&msg->cMessageHeader, header, sizeof(*header));
            return msg;
        }
    }
    return nil;
}

- (id)initWithType:(CMessageType)theType
{
    self = [super init];
    if (self) {
        cMessageHeader.code_low = 0;
        cMessageHeader.code_high = htonl(kCMessageHeaderCode);
        cMessageHeader.type = htonl(theType);
        long long s = [CMessage nextSequenceNumber];
        cMessageHeader.sequenceNumber_low = htonl(highLLong(s));
        cMessageHeader.sequenceNumber_high = htonl(lowLLong(s));
        [CMessage makeSignature:&cMessageHeader];
    }
    return self;
}

- (id)initWithType:(CMessageType)theType sequenceNumber:(long long)theSequenceNumber
{
    self = [super init];
    if (self) {
        cMessageHeader.code_low = 0;
        cMessageHeader.code_high = htonl(kCMessageHeaderCode);
        cMessageHeader.type = htonl(theType);
        cMessageHeader.sequenceNumber_low = htonl(highLLong(theSequenceNumber));
        cMessageHeader.sequenceNumber_high = htonl(lowLLong(theSequenceNumber));
        [CMessage makeSignature:&cMessageHeader];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"code = %08x %08x, type = %@<%08x>, sn = %08x %08x",
            ntohl(cMessageHeader.code_low), ntohl(cMessageHeader.code_high),
            stringOfCMessageType(ntohl(cMessageHeader.type)), ntohl(cMessageHeader.type),
            ntohl(cMessageHeader.sequenceNumber_low), ntohl(cMessageHeader.sequenceNumber_high)];
}

- (const unsigned char *)bytes
{
    return (const unsigned char *)&cMessageHeader;
}

- (int)length
{
    return sizeof(cMessageHeader);
}

@end

#pragma mark - CMessageQueueEntity

@implementation CMessageQueueEntity

@synthesize cmsg;
@synthesize timestamp;
@synthesize retryTimes;

- (id)init
{
    self = [super init];
    if (self) {
        cmsg = nil;
        timestamp = 0;
        retryTimes = 0;
    }
    return self;
}

- (NSString *)description
{
    NSDictionary *dic = [self dictionaryWithValuesForKeys:
                         [NSArray arrayWithObjects:@"cmsg", @"timestamp", @"retryTimes", nil]];
    return [dic description];
}

- (void)dealloc
{
    self.cmsg = nil;
    [super dealloc];
}

@end