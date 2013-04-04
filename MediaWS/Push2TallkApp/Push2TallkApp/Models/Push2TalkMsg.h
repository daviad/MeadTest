//
//  Push2TalkMsg.h
//  LoochaData
//
//  Created by jinquan zhang on 12-8-16.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

// call remote
#define Q_SDP @"q_sdp:"

// remote auto report it's sdp
#define R_SDP @"r_sdp:"

// remote answered connectivity - ?
#define R_CON @"r_con:"

// remote answered connectivity - accept
#define R_ACK @"r_ack:"

//#define Q_ACK @"q_ack:"

// Disconnect/Cancel
#define D_CON @"d_con:"

// ?
#define Q_CON @"q_con:"

typedef enum {
    kContentNormal             = 0,
    kContentPhoneCallInterrupt = 1,
    kContentPeerBusy           = 2,
    kContentPeerReject         = 3,
    kContentPeerShutDown       = 4
} Push2TalkContent;

@interface Push2TalkMsg : NSObject
{
    NSString *otherUserId;
    NSString *connectivity;
    NSString *request;
    NSInteger content;
    NSInteger samplerate;
    NSInteger streamtype;
    NSInteger version;
}

@property (nonatomic, retain) NSString *otherUserId;
@property (nonatomic, retain) NSString *connectivity;
@property (nonatomic, retain) NSString *request;
@property (nonatomic, readwrite) NSInteger content;
@property (nonatomic, readwrite) NSInteger samplerate;
@property (nonatomic, readwrite) NSInteger streamtype;
@property (nonatomic, readwrite) NSInteger version;

- (id)initFromDictionary:(NSDictionary *)dic;

- (void)parseFromDictionary:(NSDictionary *)dic;

@end
