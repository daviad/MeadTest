//
//  TalkManager.m
//  TestApp
//
//  Created by jinquan zhang on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TalkManager.h"

#import "TalkSessionInfo.h"

#include "rtpsession.h"
#include "rtpudpv4transmitter.h"
#include "rtpipv4address.h"
#include "rtpsessionparams.h"
#include "rtperrors.h"
#include "rtppacket.h"

using namespace jrtplib;

#define rtpSession (static_cast<RTPSession *>(privRTPSessionRef))

@interface TalkManager ()

- (void)cmsgSendingThread;

- (void)receivingThread;

@end

@implementation TalkManager

@synthesize dataDelegate;
@synthesize controlingDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        cmsgQueue = [[RCQueue alloc] init];
        RTPSession *session = new RTPSession;
        privRTPSessionRef = session;
    }
    return self;
}

- (void)dealloc
{
    // TODO: destroy recvQueue
    if (rtpSession) {
        delete rtpSession;
    }
    [cmsgQueue release];
    [super dealloc];
}

- (void)startPush2TalkWithSessionInfo:(TalkSessionInfo *)sessionInfo
{
    RCInfo(@"sessionInfo = %@", sessionInfo);
    
    RTPUDPv4TransmissionParams transparams;
    RTPSessionParams sessparams;
    
    sessparams.SetOwnTimestampUnit(6.0/100.0);
    sessparams.SetAcceptOwnPackets(true);
    transparams.SetPortbase(sessionInfo.localPort);
    
    int status = rtpSession->Create(sessparams,&transparams);
    if (status != 0) {
        RCError(@"%s", RTPGetErrorString(status).c_str());
    }
    status = rtpSession->SetDefaultPayloadType(0);//注意这个参数不能随便设置，参考RFC3551
    status = rtpSession->SetDefaultMark(false);
    status = rtpSession->SetDefaultTimestampIncrement(60);

    unsigned long destip = ntohl(inet_addr("127.0.0.1"));
    
    if (sessionInfo.remoteIP && [sessionInfo.remoteIP length])
    {
        const char * ip = [sessionInfo.remoteIP cStringUsingEncoding:NSUTF8StringEncoding];
        destip = ntohl(inet_addr(ip));
    }
    RTPIPv4Address addr(destip, sessionInfo.remotePort);
    rtpSession->AddDestination(addr);
    
    receiving = YES;
    sending = YES;
    
    [self performSelectorInBackground:@selector(receivingThread) withObject:nil];
    [self performSelectorInBackground:@selector(cmsgSendingThread) withObject:nil];
}

- (void)sendMessage:(CMessage *)cmsg
{
    RCDebug(@"RTP:SEND control message : %@", cmsg);
    int status = rtpSession->SendPacket([cmsg bytes], [cmsg length]);
    if (status) {
        RCError(@"RTP:SEND error : %s", RTPGetErrorString(status).c_str());
    }
}

- (void)scheduleMessage:(CMessage *)cmsg
{
    if (cmsg.type != kCMT_ACK) {
        CMessageQueueEntity *entity = [[CMessageQueueEntity alloc] init];
        entity.cmsg = cmsg;
        @synchronized(cmsgQueue) {
            RCTrace(@"push in queue : %@", entity);
            [cmsgQueue push:entity];
        }
        [entity release];
    }
    else {
        [self sendMessage:cmsg];
    }
}

- (void)sendControlMessage:(CMessageType)type
{
    CMessage *cmsg = [[CMessage alloc] initWithType:type];
    [self scheduleMessage:cmsg];
    [cmsg release];
}

- (void)sendControlMessage:(CMessageType)type sequenceNumber:(long long)sequenceNumber
{
    CMessage *cmsg = [[CMessage alloc] initWithType:type sequenceNumber:sequenceNumber];
    [self scheduleMessage:cmsg];
    [cmsg release];
}

- (void)sendData:(unsigned char *)buf length:(int)length
{
    RCDebug(@"RTP:SEND raw data length : %d", length);
    int status = rtpSession->SendPacket((void *)buf, length);
    if (status) {
        RCError(@"RTP:SEND error : %s", RTPGetErrorString(status).c_str());
    }
}

- (void)endSession
{
    receiving = NO;
    sending = NO;
    self.dataDelegate = nil;
    self.controlingDelegate = nil;
    if (rtpSession) {
        rtpSession->Destroy();
    }
}

- (BOOL)entityExpired:(CMessageQueueEntity *)entity
{
    CMessageType type = entity.cmsg.type;
    if (type == kCMT_HB2) {
        return entity.retryTimes >= HB_RETRY_TIMES;
        
    } else {
        return entity.retryTimes >= MAX_RETRY_TIMES;
    }
}

- (BOOL)retryNeeded:(CMessageQueueEntity *)entity
{
    if (entity.retryTimes == 0) {
        return YES;
    }
    else {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (entity.cmsg.type == kCMT_HB2) {
            return now - entity.timestamp > HB_RETRY_INTERVAL; 
        }
        else {
            return now - entity.timestamp > SEND_INTERVAL ; 
        }
    }
}

- (void)cmsgSendingThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    lastSendTimestamp = [[NSDate date] timeIntervalSince1970];
    while (sending) {
        CMessageQueueEntity *entity = nil;
        @synchronized(cmsgQueue) {
            entity = [cmsgQueue peek];
        }
        if (entity) {
            [entity retain];
            // timeout
            if ([self entityExpired:entity]) {
                sending = NO;
                [controlingDelegate timeoutFortalkManager:self];
            }
            else if (entity.cmsg.type == kCMT_HB2 && [cmsgQueue length] > 1) {
                @synchronized(cmsgQueue) {
                    [cmsgQueue poll];
                }
            }
            else if ([self retryNeeded:entity]) {
                entity.timestamp = [[NSDate date] timeIntervalSince1970];
                entity.retryTimes = entity.retryTimes + 1;
                lastSendTimestamp = entity.timestamp;
                
                [self sendMessage:entity.cmsg];
            }
            [entity release];
        }
        if ([[NSDate date] timeIntervalSince1970] - lastSendTimestamp > HEART_BEAT_INTERVAL) {
            [self sendControlMessage:kCMT_HB2];
        }
        [NSThread sleepForTimeInterval:0.030];
    }
    
    [pool drain];
}

- (void)receivingThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    while(receiving) {
        RTPPacket *pack = NULL;
        
        rtpSession->BeginDataAccess();
        
        if (rtpSession->IsActive() && rtpSession->GotoFirstSourceWithData()) {
            pack = rtpSession->GetNextPacket();
        }
        rtpSession->EndDataAccess();
        
        if (pack) {
            CMessage *cmsg = nil;
            unsigned char *data = pack->GetPayloadData();
            int length = pack->GetPayloadLength();
            
            if ((cmsg = [CMessage cMessageFromPacket:data length:length])) {
                RCDebug(@"RTP:RECV control message : %@", cmsg);
                if (cmsg.type == kCMT_ACK) {
                    // poll cmsg
                    CMessageQueueEntity *entity = [cmsgQueue peek];
                    [entity retain];
                    if (entity && entity.cmsg.sequenceNumber == cmsg.sequenceNumber) {
                        @synchronized(cmsgQueue) {
                            [cmsgQueue poll];
                        }
                    }
                    else {
                        RCError(@"ACK control messsage arrived unexpectedly");
                    }
                    [entity release];
                }
                else {
                    // send ACK
                    [self sendControlMessage:kCMT_ACK sequenceNumber:cmsg.sequenceNumber];
                    
                    if (cmsg.type != kCMT_HB2) {
                        // handle CMessage
                        [controlingDelegate talkManager:self responsedWithControlType:cmsg.type];
                    }
                }
            }
            else {
                [dataDelegate talkManager:self responsedWithData:data length:length];
            }
            
            rtpSession->DeletePacket(pack);
        }
    }
    
    [pool drain];
}

@end
