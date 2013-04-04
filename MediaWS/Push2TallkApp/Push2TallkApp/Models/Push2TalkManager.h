//
//  Push2TalkManager.h
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-17.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TalkSessionInfo;
@class Push2TalkManager;

@protocol Push2TalkManagerDelegate <NSObject>
@optional
- (void)openPush2Talk:(NSString *)remoteUser;

- (void)startPush2Talk:(NSString *)remoteUser sessionInfo:(TalkSessionInfo *)sessionInfo;

- (void)closePush2Talk:(NSString *)remoteUser;

- (void)push2TalkDidConnectWithManager:(Push2TalkManager *)manager;

@end

@class Push2TalkController;
@class RCPromptPlayer;

@interface Push2TalkManager : NSObject
{
    UIViewController *rootViewController;
    Push2TalkController *push2TalkController;
    
    TalkSessionInfo *sessionInfo;
    NSString *remoteSDP;
    
    BOOL busy;
    
    int stream_id;
//    id<Push2TalkManagerDelegate> delegate;
    
    BOOL q_sdp_sent;
    BOOL r_sdp_sent;
    BOOL q_con_sent;
    BOOL r_con_sent;
    BOOL r_ack_sent;
    
    BOOL q_sdp_received;
    BOOL r_sdp_received;
    BOOL q_con_received;
    BOOL r_con_received;
    BOOL r_ack_received;
    
    BOOL ice_success;
    
    CFRunLoopRef rl;
    
    NSThread *thread;
    
    RCPromptPlayer *promptPlayer;
}

@property (nonatomic, retain) NSString *remoteSDP;
//@property (nonatomic, assign) id<Push2TalkManagerDelegate> delegate;
@property (nonatomic, assign) UIViewController *rootViewController;

@end
