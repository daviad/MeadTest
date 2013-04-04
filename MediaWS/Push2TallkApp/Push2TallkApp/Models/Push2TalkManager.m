//
//  Push2TalkManager.m
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-17.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "Push2TalkManager.h"
#import "Push2TalkController.h"
#import "Push2TalkMsg.h"
#import "XMPPConnetHandle.h"
#import "CJSONSerializer.h"
#import "TalkSessionInfo.h"
//#import "XMPPCoreDataHander.h"
#import "LoochaAlertView.h"
#import "UIImageView+WebCache.h"

#import "RCPromptPlayer.h"
#import "FriendHandler.h"
#import "StudentDAO.h"

#import "CampusSingleton.h"
#import "FrontViewController.h"

# ifdef __cplusplus
extern "C" {
# endif
#import "Stunwapper.h"
# ifdef __cplusplus
}
# endif
#define kConfirmTimeLimit 20

#define kAlertTagRequested  1000
#define kAlertTagRemoteQuit 1001

@interface Push2TalkManager () <LoochaAlertViewDelegate>

@property (nonatomic, readwrite) BOOL q_sdp_sent;
@property (nonatomic, readwrite) BOOL r_sdp_sent;
@property (nonatomic, readwrite) BOOL q_con_sent;
@property (nonatomic, readwrite) BOOL r_con_sent;
@property (nonatomic, readwrite) BOOL r_ack_sent;

@property (nonatomic, readwrite) BOOL q_sdp_received;
@property (nonatomic, readwrite) BOOL r_sdp_received;
@property (nonatomic, readwrite) BOOL q_con_received;
@property (nonatomic, readwrite) BOOL r_con_received;
@property (nonatomic, readwrite) BOOL r_ack_received;

@property (nonatomic, readwrite) BOOL ice_success;

@property (nonatomic, retain) Push2TalkController *push2TalkController;
@property (nonatomic, retain) TalkSessionInfo *sessionInfo;

- (void)openPush2Talk;

- (void)closePush2Talk;

- (void)startPush2TalkhSession;

@end


@implementation Push2TalkManager

@synthesize remoteSDP;
//@synthesize delegate;
@synthesize rootViewController;

@synthesize q_sdp_sent;
@synthesize r_sdp_sent;
@synthesize q_con_sent;
@synthesize r_con_sent;
@synthesize r_ack_sent;

@synthesize q_sdp_received;
@synthesize r_sdp_received;
@synthesize q_con_received;
@synthesize r_con_received;
@synthesize r_ack_received;

@synthesize ice_success;

@synthesize push2TalkController;
@synthesize sessionInfo;

- (void)resetStates
{
    busy = NO;
    self.remoteSDP = nil;
    
    q_sdp_sent = NO;
    r_sdp_sent = NO;
    q_con_sent = NO;
    r_con_sent = NO;
    r_ack_sent = NO;
    
    q_sdp_received = NO;
    r_sdp_received = NO;
    q_con_received = NO;
    r_con_received = NO;
    r_ack_received = NO;
    
    ice_success = NO;
    
    thread = NULL;
    rl = NULL;
    
    self.sessionInfo = nil;
    /*
    Employee *e = [[XMPPCoreDataHander sharedInstance].looChaCoreDataStorage searchOtherEmployeeByOtherId:remoteUser];
    
    UIImage *image = nil;
    NSString *cachePath = [PersistentDirectory persistentDirectory:@"avatar"];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"loocha_friend%@.png", remoteUser]];
    image = [UIImage imageWithContentsOfFile:path];
    
    if (image == nil) {
        image = [UIImage imageNamed:@"push_to_talk_alert_head"];
    }
    sessionInfo.remoteUsername = e.name;
    sessionInfo.remoteUserHead = image;
    
    NSString *avatarStr = @"";
    if ([[CustomGlobalObject sharedInstance] isLoochaSide])  {
        avatarStr = [CustomGlobalObject sharedInstance].myselfUser.userAvatar ;
    }
    else  {
        Employee *myself = [[[XMPPCoreDataHander sharedInstance] looChaCoreDataStorage] searchEmployeeByEmployeeID];
        avatarStr = myself.avatar; 
    }
    cachePath = [PersistentDirectory persistentDirectory:@"storage"];
    avatarStr = [avatarStr stringByReplacingOccurrencesOfString:@"/" withString:@""];
    path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"thumbnail_%@",avatarStr]];
    image = [UIImage imageWithContentsOfFile:path];
    if (image == nil) {
        image = [UIImage imageNamed:@"push_to_talk_alert_head"];
    }
    sessionInfo.localUserHead = image;
     */
}

- (void)sendPacketRemoteUser:(NSString *)userID request:(NSString *)request connectivity:(NSString *)connectivity content:(NSInteger)content samplerate:(NSInteger)samplerate
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         connectivity, @"connectivity",
                         request, @"request",
                         [NSNumber numberWithInteger:content], @"content",
                         [NSNumber numberWithInteger:samplerate], @"samplerate",
                         [NSNumber numberWithInteger:1], @"streamtype",
                         [NSNumber numberWithInteger:1], @"version",
                         nil];
    NSData *data = [[CJSONSerializer serializer] serializeDictionary:dic error:NULL];
    if (data) {
        NSString *jsonBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [[XMPPConnetHandle sharedInstance] sendChatMessage:userID bodyString:jsonBody];
        [jsonBody release];
    }
}

- (void)sendPacketRemoteUser:(NSString *)userID request:(NSString *)request content:(NSInteger)content
{
    [self sendPacketRemoteUser:userID request:request connectivity:@"" content:content samplerate:0];
}

- (void)handleStunAddr:(NSString *)addr Stream:(int)theStream_id
{
    RCDebug(@"addr = %@", addr);

//    self->stream_id = stream_id;
    if (sessionInfo.userType == kPush2TalkCaller) {
        // send q_sdp, then wait for r_sdp
        [self sendPacketRemoteUser:sessionInfo.remoteUserInfo.user_id request:Q_SDP connectivity:addr content:0 samplerate:sessionInfo.localSampleRate];
    }
    else {
        [self sendPacketRemoteUser:sessionInfo.remoteUserInfo.user_id request:R_SDP connectivity:addr content:0 samplerate:sessionInfo.localSampleRate];
        GetSDPDec(self, stream_id, [self.remoteSDP UTF8String]);
    }
}

- (void)handleSelectPair:(NSString *)ip remotePort:(NSInteger)rport localPort:(NSInteger)lport
{
    if (ip == nil || [ip length] == 0 || rport == 0 || lport == 0) {
        // TODO:
        RCError(@"handleSelectPair:error ip or port");
        return;
    }
    sessionInfo.remoteIP = ip;
    sessionInfo.remotePort = rport;
    sessionInfo.localPort = lport;
    
    RCDebug(@"session info : %@", sessionInfo);
    
    self.ice_success = YES;
}

- (void)handlePush2TalkCallRemote:(id)value
{
    if (![value isKindOfClass:[Push2TalkController class]]) {
        return;
    }
    busy = YES;
    self.push2TalkController = value;
    self.sessionInfo = push2TalkController.sessionInfo;
    
#if 0
    // test:
    [self showRequestAlert];
    return;
#endif
    
    [self startStunThread:1];
//    
//    [self openPush2Talk];
}

- (void)startStun:(id)controllingObj 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    rl = CFRunLoopGetCurrent();
    NSString *StunAddress = kStunAddress;
    self->stream_id = StunCreate(self, [StunAddress UTF8String], kStunPort , [controllingObj intValue]); 
    CFRunLoopRun();
    
    RCDebug(@"stun thread stopped");
    [pool release];  
}

- (void)startStunThread:(int)controlling
{
    if (thread == NULL) 
    {
        RCDebug(@"starting stun thread");
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(startStun :) object:[NSNumber numberWithInt:controlling]];  
        [thread start];
    }
}

- (void)stopStunThread
{
    RCDebug(@"stopping stun thread");
    StunClose(self->stream_id, self->thread, rl);
    rl = NULL;
    thread = NULL;
    stream_id = 0;
}

- (void)showRequestAlert
{
    LoochaAlertView *alertView = [[LoochaAlertView alloc] initWithTitle:@"请求与您会话"
                                                                message:sessionInfo.remoteUserInfo.name
                                                       buttonTitleArray:[NSArray arrayWithObjects:@"接受", @"拒绝", nil]];
    alertView.tag = kAlertTagRequested;
    [alertView.imageView setImageWithURL:[CampusSingleton convertNeedPath:sessionInfo.remoteUserInfo.avatar]
                        placeholderImage:nil];
    alertView.userInfo = sessionInfo.remoteUserInfo.user_id;
    alertView.delegate = self;
    [alertView showWithLimitedTimeInterval:30];
    [alertView release];
    
    [promptPlayer start];
}

- (void)showMessageAlert:(NSString *)msg
{
    LoochaAlertView *alertView = [[LoochaAlertView alloc] initWithTitle:sessionInfo.remoteUserInfo.name
                                                                message:msg
                                                       buttonTitleArray:[NSArray arrayWithObjects:@"OK", nil]];
    alertView.tag = kAlertTagRemoteQuit;
    [alertView.imageView setImageWithURL:[CampusSingleton convertNeedPath:sessionInfo.remoteUserInfo.avatar]
                        placeholderImage:nil];
    alertView.userInfo = sessionInfo.remoteUserInfo.user_id;
    alertView.delegate = self;
    [alertView show];
    [alertView release];
}

- (void)makeSessionInfoWithMsg:(Push2TalkMsg *)msg
{
    self.remoteSDP = msg.connectivity;
    
    FriendHandler *handler = [[FriendHandler alloc] init];
    NSDictionary *dic = [handler getMyFriendWithFriendId:msg.otherUserId];
    [handler release];
    
    UserInfo *userInfo = [[UserInfo alloc] init];
    if (dic) {
        userInfo.user_id = msg.otherUserId;
        userInfo.avatar = [dic objectForKey:FRIEND_AVATAR];
        userInfo.name = [dic objectForKey:FRIEND_NAME];
    }
    else {
        StudentDAO *dao = [[StudentDAO alloc] init];
        NSArray *dicts = [dao searchStudentById:msg.otherUserId withType:0 waitUntilDone:YES];
        dic = [dicts lastObject];
        [dao release];
        if (dic) {
            userInfo.user_id = msg.otherUserId;
            userInfo.avatar = [dic objectForKey:STUDENT_AVATAR];
            userInfo.name = [dic objectForKey:STUDENT_NAME];
        }
    }
    
    if (userInfo.avatar == nil) {
        userInfo.avatar = [[NSBundle mainBundle] pathForResource:@"face_default" ofType:@"png"];
    }
    if (userInfo.name == nil) {
        userInfo.name = @"未知姓名";
    }
    
    TalkSessionInfo *tsi = [[TalkSessionInfo alloc] init];
    tsi.userType = kPush2TalkRecver;
    tsi.remoteSampleRate = msg.samplerate;
    tsi.remoteUserInfo = userInfo;
    self.sessionInfo = tsi;
    [tsi release];
    [userInfo release];
}

- (void)handlePush2TalkRemoteMsg:(id)value
{
    if (![value isKindOfClass:[Push2TalkMsg class]]) {
        return;
    }
    Push2TalkMsg *msg = (Push2TalkMsg *)value;
    if (msg) {
        // remote user is calling me
        if ([msg.request isEqualToString:Q_SDP]) {
            if (busy) {
                [self sendPacketRemoteUser:msg.otherUserId request:D_CON content:kContentPeerBusy];
            }
            else {
                [self resetStates];
                busy = YES;
                [self makeSessionInfoWithMsg:msg];
                
                [self startStunThread:0];
                
                [self showRequestAlert];
            }
        }
        else if (sessionInfo && [msg.otherUserId isEqualToString:sessionInfo.remoteUserInfo.user_id]) {
            // remote user accept my calling
            if ([msg.request isEqualToString:R_SDP]) {
                sessionInfo.remoteSampleRate = msg.samplerate;
                // get IP port with ICE
                GetSDPDec(self, self->stream_id, [msg.connectivity UTF8String]);
            }
            else if ([msg.request isEqualToString:Q_CON]) {
                // 
                self.q_con_received = YES;
            }
            else if ([msg.request isEqualToString:R_CON]) {
                // release agent <Talk connected>, wait for r_ack
                self.r_con_received = YES;
            }
            else if ([msg.request isEqualToString:R_ACK]) {
                // play beep, stop ringing, stop timer, <Talk started>, wait for connect
                self.r_ack_received = YES;
            }
            else if ([msg.request isEqualToString:D_CON]) {
                [self stopStunThread];
                [self closePush2Talk];
                
                LoochaAlertView *alertView = [[LoochaAlertView loochaAlertViews] lastObject];
                if (alertView) {
                    [alertView dismissAnimated:YES];
                }
                else {
                    NSString *msgText = nil;
                    
                    switch (msg.content) {
                        case kContentPeerBusy:
                            msgText = @"对方忙，请稍后再拨";
                            break;
                            
                        case kContentPeerReject:
                            msgText = @"对方忙，请稍后再拨";
                            break;
                            
                        case kContentPeerShutDown:
                            msgText = @"您的好友已结束对讲!";
                            break;
                            
                        case kContentPhoneCallInterrupt:
                            msgText = @"对不起，对方正在接听电话!";
                            break;
                            
                        default:
                            msgText = @"对方忙，请稍后再拨";
                            break;
                    }
                    [self showMessageAlert:msgText];
                }
                [self resetStates];
            }
        }
        else {
            RCInfo(@"xmpp message ignored:%@", msg);
        }
    }
}

- (void)handlePush2TalkQuit:(id)value
{
    if (![value isKindOfClass:[NSString class]]) {
        return;
    }
    RCTrace(@"attenpt to close push2talk with user : %@", value);
    RCTrace(@"current remote user : %@, busy = %d", sessionInfo.remoteUserInfo.user_id, busy);
    [self sendPacketRemoteUser:sessionInfo.remoteUserInfo.user_id request:D_CON content:kContentPeerShutDown];
    [self stopStunThread];
    if ([sessionInfo.remoteUserInfo.user_id isEqualToString:value]) {
        [self closePush2Talk];
    }
    [self resetStates];
}

- (void)handlePush2TalkPush:(NSNotification *)notification
{
    RCDebug(@"notification : %@", notification);
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *type = [userInfo objectForKey:kPush2TalkPushType];
    id value = [userInfo objectForKey:kPush2TalkPushValue];
    
    if (type == nil) {
        return;
    }
    switch ([type intValue]) {
        case kPush2TalkCallRemote:
            [self handlePush2TalkCallRemote:value];
            break;
            
        case kPush2TalkRemoteMsg:
            [self handlePush2TalkRemoteMsg:value];
            break;
            
        case kPush2TalkQuit:
            [self handlePush2TalkQuit:value];
            break;
            
        default:
            break;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
//        sessionInfo = [[TalkSessionInfo alloc] init];
//        sessionInfo.localSampleRate = vDefaultLocalSampleRate;
        
        NSURL *ringURL = [[NSBundle mainBundle] URLForResource:@"ringing" withExtension:@"wav"];
        promptPlayer = [[RCPromptPlayer alloc] initWithURL:ringURL];
        promptPlayer.playWithVibrate = YES;
        promptPlayer.repeatCount = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handlePush2TalkPush:)
                                                     name:kPush2TalkPushKey
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPush2TalkPushKey object:nil];
//    self.delegate = nil;
    [promptPlayer release];
    self.remoteSDP = nil;
    self.sessionInfo = nil;
    [super dealloc];
}

#pragma mark - LoochaAlertViewDelegate

- (void)loochaAlertView:(LoochaAlertView *)alertView didSelectButtonAt:(NSUInteger)index
{
    if (alertView.tag == kAlertTagRemoteQuit) {
        // busy = NO;
        // do nothing
    }
    else if (alertView.tag == kAlertTagRequested) {
        if (index == 0) {
            RCDebug(@"Push2TalkAlertView - OK");
            [self sendPacketRemoteUser:sessionInfo.remoteUserInfo.user_id request:R_ACK content:0];
            self.r_ack_sent = YES;
        }
        else {
            RCDebug(@"Push2TalkAlertView - IGNORE");
            
            [self sendPacketRemoteUser:sessionInfo.remoteUserInfo.user_id request:D_CON content:kContentPeerReject];
            [self resetStates];
        }
    }
}

- (void)timeoutShowingLoochaAlertView:(LoochaAlertView *)alertView
{
    RCDebug(@"Push2TalkAlertView - TIMEOUT");
    
    [self sendPacketRemoteUser:alertView.userInfo request:D_CON content:kContentPeerReject];
}

- (void)loochaAlertViewDidDismiss:(LoochaAlertView *)alertView
{
    if (alertView.tag == kAlertTagRequested) {
        [promptPlayer stopImmediately:YES];
    }
}

- (void)handleTalkStarted
{
    // play beep, stop ringing
    // start rtp session
    [self stopStunThread];
    [self startPush2TalkhSession];
}

- (void)handleTalkConnected
{
    // can talk state
}

- (void)handleListenConnected
{
    // release agent
    [self stopStunThread];
    [self startPush2TalkhSession];
}

- (void)setIce_success:(BOOL)val
{
    RCDebug(@"set ice_success = %d", val);
    
    if (val && !ice_success) {
        if (sessionInfo.userType == kPush2TalkCaller) {
            // send q_con, then wait for r_ack and r_con
            [self sendPacketRemoteUser:sessionInfo.remoteUserInfo.user_id request:Q_CON content:0];
            
            if (r_con_received) {
                // <talk connected>
                [self handleTalkConnected];
                
                if (r_ack_received) {
                    // <talk started>
                    [self performSelectorOnMainThread:@selector(handleTalkStarted) withObject:nil waitUntilDone:NO];
                }
            }
        }
        else {
            // send r_con
            [self sendPacketRemoteUser:sessionInfo.remoteUserInfo.user_id request:R_CON content:0];
            
            if (q_con_received && r_ack_sent) {
                // <listen connected>
                [self performSelectorOnMainThread:@selector(handleListenConnected) withObject:nil waitUntilDone:NO];
            }
        }
    }
    ice_success = val;
}

- (void)setR_con_received:(BOOL)val
{
    RCDebug(@"set r_con_received = %d", val);
    
    if (val && !r_con_received) {
        if (ice_success) {
            // <talk connected>
            [self handleTalkConnected];
            
            if (r_ack_received) {
                // <talk started>
                [self handleTalkStarted];
            }
        }
    }
    r_con_received = val;
}

- (void)setR_ack_received:(BOOL)val
{
    RCDebug(@"set r_ack_received = %d", val);
    
    if (val && !r_ack_received) {
        if (ice_success && r_con_received) {
            // <talk started>
            [self handleTalkStarted];
        }
    }
    r_ack_received = val;
}

- (void)setQ_con_received:(BOOL)val
{
    RCDebug(@"set q_con_received = %d", val);
    
    if (val && !q_con_received) {
        if (ice_success) {
            // <listen connected>
            if (r_ack_sent) {
                [self handleListenConnected];
            }
        }
    }
    q_con_received = val;
}

// r_ack = YES means push2talk is open
- (void)setR_ack_sent:(BOOL)val
{
    RCDebug(@"set r_ack_sent = %d", val);
    
    if (val && !r_ack_sent) {
        [self openPush2Talk];
        
        if (q_con_received && ice_success) {
            [self handleListenConnected];
        }
    }
    r_ack_sent = val;
}

#pragma mark - Push2TalkController operations

- (void)openPush2Talk
{
    if (self.push2TalkController) {
        RCError(@"another push2TalkController<reomteUser:%@> exist", self.push2TalkController.sessionInfo.remoteUserInfo.user_id);
    }
    else {
        [Global sendMessageToControllers:kTaskMsgRevealMainPage withResult:kTaskMsgRevealMainPage withArg:nil];
        Push2TalkController *controller = [[Push2TalkController alloc] initWithSessionInfo:sessionInfo];
        self.push2TalkController = controller;
        [self.rootViewController.navigationController pushViewController:controller animated:YES];
//        [self.rootViewController presentViewController:controller animated:YES completion:^(){
//            if (self.push2TalkController == nil) {
//                [self.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
//            }
//        }];
        [controller release];
    }
}

- (void)closePush2Talk
{
    if (self.push2TalkController) {
        if (sessionInfo != self.push2TalkController.sessionInfo) {
            RCError(@"push2TalkController remoteUser is %@, while manager wants to close push2talk with remoteUser %@",
                  push2TalkController.sessionInfo.remoteUserInfo.user_id, sessionInfo.remoteUserInfo.user_id);
        }
        [self.push2TalkController push2TalkEnded];
        if (self.rootViewController.navigationController.topViewController == self.push2TalkController) {
            [self.rootViewController.navigationController popViewControllerAnimated:YES];
        }
        self.push2TalkController = nil;
    }
}

- (void)startPush2TalkhSession
{
    sessionInfo.connected = YES;
    if (self.push2TalkController) {
        if (sessionInfo != self.push2TalkController.sessionInfo) {
            RCError(@"push2TalkController remoteUser is %@, while manager wants to start push2talk with remoteUser %@",
                  push2TalkController.sessionInfo.remoteUserInfo.user_id, sessionInfo.remoteUserInfo.user_id);
        }
        [self.push2TalkController push2TalkConnected];
    }
}


@end
