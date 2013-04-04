//
//  TalkSessionInfo.h
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-21.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"

#define vDefaultLocalSampleRate 24000

typedef enum {
    kPush2TalkCaller,
    kPush2TalkRecver
} Push2TalkUserType;

@interface TalkSessionInfo : NSObject
{
    Push2TalkUserType userType;
    NSString *remoteIP;
    NSUInteger remotePort;
    NSUInteger localPort;
    NSUInteger remoteSampleRate;
    NSUInteger localSampleRate;
    BOOL connected;
    UserInfo *remoteUserInfo;
}

@property (nonatomic, readwrite) Push2TalkUserType userType;
@property (nonatomic, retain)    NSString *remoteIP;
@property (nonatomic, readwrite) NSUInteger remotePort;
@property (nonatomic, readwrite) NSUInteger localPort;
@property (nonatomic, readwrite) NSUInteger remoteSampleRate;
@property (nonatomic, readwrite) NSUInteger localSampleRate;
@property (nonatomic, readwrite) BOOL connected;
@property (nonatomic, retain)    UserInfo *remoteUserInfo;

@end
