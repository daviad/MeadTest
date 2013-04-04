//
//  TalkManager.h
//  TestApp
//
//  Created by jinquan zhang on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCQueue.h"
#import "CMessage.h"

#define HB_RETRY_TIMES    20
#define MAX_RETRY_TIMES   170

#define HB_RETRY_INTERVAL 0.500
#define SEND_INTERVAL     0.060

#define HEART_BEAT_INTERVAL 5

@class TalkManager;
@class TalkSessionInfo;

@protocol TalkManagerDataDelegate <NSObject>

- (void)talkManager:(TalkManager *)talkManager responsedWithData:(unsigned char *)data length:(int)length;

@end

@protocol TalkManagerControlingDelegate <NSObject>

- (void)talkManager:(TalkManager *)talkManager responsedWithControlType:(CMessageType)type;

- (void)timeoutFortalkManager:(TalkManager *)talkManager;

@end

@interface TalkManager : NSObject
{
    void *privRTPSessionRef;
    BOOL sending;
    BOOL receiving;
    RCQueue *cmsgQueue;
    NSTimeInterval lastSendTimestamp;
    id<TalkManagerDataDelegate> dataDelegate;
    id<TalkManagerControlingDelegate> controlingDelegate;
}

@property (nonatomic, assign) id<TalkManagerDataDelegate> dataDelegate;
@property (nonatomic, assign) id<TalkManagerControlingDelegate> controlingDelegate;

- (void)startPush2TalkWithSessionInfo:(TalkSessionInfo *)sessionInfo;

- (void)sendControlMessage:(CMessageType)type;

- (void)sendControlMessage:(CMessageType)type sequenceNumber:(long long)sequenceNumber;

- (void)sendData:(unsigned char *)buf length:(int)length;

- (void)endSession;

@end
