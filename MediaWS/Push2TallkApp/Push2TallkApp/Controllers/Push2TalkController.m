//
//  Push2TalkController.m
//  LoochaCampus
//
//  Created by jinquan zhang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Push2TalkController.h"
#import "OnlineFriendListViewController.h"

#import "TalkManager.h"
#import "TalkSender.h"
#import "TalkRecver.h"



@interface Push2TalkController () <TalkManagerControlingDelegate>

@property (nonatomic, readwrite) TalkState talkState;

@end

@implementation Push2TalkController

@synthesize talkState;
@synthesize sessionInfo;

- (id)initWithSessionInfo:(TalkSessionInfo *)theSessionInfo
{
    self = [super init];
    if (self) {
        if (theSessionInfo) {
            sessionInfo = [theSessionInfo retain];
        }
        else {
            sessionInfo = [[TalkSessionInfo alloc] init];
            sessionInfo.userType = kPush2TalkCaller;
        }
        NSURL *ringURL = [[NSBundle mainBundle] URLForResource:@"ringing" withExtension:@"wav"];
        ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ringURL error:NULL];
        ringPlayer.numberOfLoops = -1;
        
        NSURL *beepURL = [[NSBundle mainBundle] URLForResource:@"beep" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)beepURL, &beepSoundID);
        
        talkManager = [[TalkManager alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithSessionInfo:nil];
}

- (id)initWithUser:(UserInfo *)user
{
    self = [self init];
    if (self) {
        self.sessionInfo.remoteUserInfo = user;
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
    
    RCReleaseSafely(controlView);
    RCReleaseSafely(avatarBtn);
    RCReleaseSafely(adviceView);
    RCReleaseSafely(stateLabel);
    RCReleaseSafely(timeLabel);
    RCReleaseSafely(tipLabel);
    
    RCReleaseSafely(ringPlayer);
    RCReleaseSafely(talkManager);
    RCReleaseSafely(sender);
    RCReleaseSafely(recver);
    RCReleaseSafely(sessionInfo);
    [super dealloc];
}

//- (BOOL)handleLoochaBarActionItem:(LoochaBarActionItem *)loochaBarItem
//{
//    [self actionCallOff];
//    return YES;
//}

//- (void)setUpLoochaContainer
//{
//    [super setUpLoochaContainer];
//    
//    [self contentView].tiledImage = [UIImage imageNamed:@"push2talk_tiled_bg"];
//    [self contentView].lineColor = RCColorWithValue(0x9dc1d0);
//    [self contentView].borderColor = RCColorWithValue(0x7aabc1);
//    
//    if (self.loochaNavigationItem.leftBarItem == nil) {
//        self.loochaNavigationItem.leftBarItem = [LoochaBarActionItem homeLoochaBarItem];
//    }
//    self.loochaNavigationItem.title = @"免费电话";
//}
//
//// 由于某些图仅有一套，需按比例计算排版尺寸
//- (void)addImageViewToBottom:(UIImageView *)v
//{
//    CGRect r = [self contentView].bounds;
//    CGSize sz = v.image.size;
//    sz.height = sz.height*r.size.width/sz.width;
//    sz.width = r.size.width;
//    r.origin.y = r.size.height - sz.height;
//    r.size = sz;
//    v.frame = r;
//    [[self contentView] addSubview:v];
//}

- (void)configControlView
{
    controlView.userInteractionEnabled = YES;
    CGRect r = controlView.bounds;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, r.size.height - 120, r.size.width/2, 120)];
    btn.tag = 1;
    [btn addTarget:self action:@selector(actionLeaveMessage) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(actionBtnEvents:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside | UIControlEventTouchCancel];
    [controlView addSubview:btn];
    [btn release];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(r.size.width/2, r.size.height - 120, r.size.width/2, 120)];
    btn.tag = 2;
    [btn addTarget:self action:@selector(actionCallOff) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(actionBtnEvents:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside | UIControlEventTouchCancel];
    [controlView addSubview:btn];
    [btn release];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake((r.size.width - 120)/2 + 4.5/2, 37 + 7/2, 120, 120)];
    [btn setImage:[UIImage imageNamed:@"push2talk_control_push_btn"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"push2talk_control_push_btn_touch"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(actionPushed) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(actionReleased) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
    [controlView addSubview:btn];
    [btn release];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    // back ground
//    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push2talk_bg"]];
//    [self addImageViewToBottom:bgView];
//    [bgView release];
//    
//    // control view
//    controlView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"push2talk_control_normal"]];
//    [self addImageViewToBottom:controlView];
//    [self configControlView];
//    
//    // top cover
//    UIImageView *topCover = [[UIImageView alloc] initWithFrame:CGRectMake(([self contentView].bounds.size.width - 290)/2, 0, 290, 30)];
//    topCover.image = [UIImage imageNamed:@"push2talk_top_cover"];
//    [[self contentView] addSubview:topCover];
//    [topCover release];
//    
//    // contents
//    CGRect r = [[self contentView] contentArea];
//    CGFloat y = r.origin.y;
//        
//    // avatar button
//    y += 15;
//    avatarBtn = [[UIButton alloc] initWithFrame:CGRectMake(r.origin.x + (r.size.width - 94)/2, y, 94, 90)];
//    y += 90;
//    [avatarBtn addTarget:self action:@selector(actionAddUser) forControlEvents:UIControlEventTouchUpInside];
//    [[self contentView] addSubview:avatarBtn];
//    
//    // state label
//    y += 5;
//    stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(r.origin.x, y, r.size.width, 20)];
//    stateLabel.textAlignment = UITextAlignmentCenter;
//    stateLabel.backgroundColor = [UIColor clearColor];
//    [[self contentView] addSubview:stateLabel];
//    
//    adviceView = [[UIImageView alloc] initWithFrame:CGRectMake(r.origin.x, y + 20, r.size.width, 14)];
//    adviceView.backgroundColor = [UIColor clearColor];
//    adviceView.image = [UIImage imageNamed:@"push2talk_advertisement"];
//    adviceView.contentMode = UIViewContentModeScaleAspectFit;
//    [[self contentView] addSubview:adviceView];
//    y += 20;
//    
//    // time label
//    y += 5;
//    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(r.origin.x, y, r.size.width, 20)];
//    y += 20;
//    timeLabel.textAlignment = UITextAlignmentCenter;
//    timeLabel.backgroundColor = [UIColor clearColor];
//    [[self contentView] addSubview:timeLabel];
//    
//    // tip label
//    y += 5;
//    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(r.origin.x, y, r.size.width, 20)];
//    y += 20;
//    tipLabel.textAlignment = UITextAlignmentCenter;
//    tipLabel.backgroundColor = [UIColor clearColor];
//    tipLabel.textColor = [UIColor grayColor];
//    [[self contentView] addSubview:tipLabel];
//    
//    [self updateViews];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    RCReleaseSafely(controlView);
    RCReleaseSafely(avatarBtn);
    RCReleaseSafely(adviceView);
    RCReleaseSafely(stateLabel);
    RCReleaseSafely(timeLabel);
    RCReleaseSafely(tipLabel);
}

- (void)actionBtnEvents:(UIButton *)btn
{
    if (btn.isTracking && btn.touchInside) {
        if (btn.tag == 1) {
            controlView.image = [UIImage imageNamed:@"push2talk_control_leave_msg"];
        }
        else {
            controlView.image = [UIImage imageNamed:@"push2talk_control_call_off"];
        }
    }
    else {
        controlView.image = [UIImage imageNamed:@"push2talk_control_normal"];
    }
}

- (void)actionPushed
{
    RCDebug(@"before>> state:%@", stringOfTalkState(talkState));
    pressed = YES;
    switch (self.talkState) {
        case kTalkStateListening: {
            RCDebug(@"kTalkStateListening - push");
            [talkManager sendControlMessage:kCMT_WTT];
        }
            break;
            
        case kTalkStateReady: {
            RCDebug(@"kTalkStateTalking - push");
        }
            break;
            
        case kTalkStateTalking: {
            RCDebug(@"kTalkStateTalking - push");
        }
            break;
            
        case kTalkStateCanTalk: {
            RCDebug(@"kTalkStateCanTalk - push");
            self.talkState = kTalkStateTalking;
            [recver stop];
            [sender start];
        }
            break;
            
        default:
            break;
    }
    RCDebug(@"after>> state:%@", stringOfTalkState(talkState));
}

- (void)actionReleased
{
    tipLabel.text = @"等待应答，嘟嘟声后开始对讲...";
    pressed = NO;
    RCDebug(@"before>> state:%@", stringOfTalkState(talkState));
    
    switch (self.talkState) {
        case kTalkStateTalking: {
            self.talkState = kTalkStateListening;
            [sender stop];
            [recver start];
            [talkManager sendControlMessage:kCMT_DNT];
            RCDebug(@"kTalkStateTalking - release");
        }
            break;
            
        case kTalkStateCanTalk: {
            RCDebug(@"kTalkStateCanTalk - release");
        }
            break;
            
        case kTalkStateReady: {
            RCDebug(@"kTalkStateReady - release");
        }
            break;
            
        case kTalkStateListening: {
            RCDebug(@"kTalkStateListening - release");
        }
            
        default:
            break;
    }
    
    RCDebug(@"after>> state:%@", stringOfTalkState(talkState));
}

- (void)actionLeaveMessage
{
    RCTrace(@"leave message");
}

- (void)actionCallOff
{
    if (sessionInfo.remoteUserInfo) {
        [self stopConnect];
    }
    // 若已经被弹出，self.navigationController为nil，不执行
    // 用以确保控制器被弹出
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)actionAddUser
//{
//    LoochaContainerController *containerController = [[LoochaContainerController alloc] init];
//    OnlineFriendListViewController *controller = [[OnlineFriendListViewController alloc] init];
//    containerController.loochaNavigationItem.leftBarItem = [LoochaBarActionItem backLoochaBarItem];
//    containerController.loochaNavigationItem.rightBarItems = [NSArray arrayWithObject:[LoochaBarNavChildItem loochaBarItemWithChildController:controller]];
//    [controller release];
//    [self.navigationController pushViewController:containerController animated:YES];
//    [containerController release];
//}

//- (void)updateViews
//{
//    if (sessionInfo.remoteUserInfo) {
//        self.view.ignoreGlobalPanGesture = YES;
//        avatarBtn.titleEdgeInsets = UIEdgeInsetsZero;
//        [avatarBtn setTitle:nil forState:UIControlStateNormal];
//        [avatarBtn setBackgroundImageWithURL:[CampusSingleton convertNeedPath:sessionInfo.remoteUserInfo.avatar]
//                            placeholderImage:nil];
//        
//        avatarBtn.enabled = NO;
//        adviceView.hidden = YES;
//        stateLabel.hidden = NO;
//        timeLabel.hidden = NO;
//        tipLabel.hidden = NO;
//        
//        stateLabel.text = [NSString stringWithFormat:@"与 %@ 通话中...", sessionInfo.remoteUserInfo.name];
//        [self updateTime];
//        
//        if (sessionInfo.connected) {
//            
//        }
//        else {
//            tipLabel.text = @"等待应答，嘟嘟声后开始对讲...";
//        }
//    }
//    else {
//        self.view.ignoreGlobalPanGesture = NO;
//        [avatarBtn setBackgroundImage:[UIImage imageNamed:@"push2talk_add_user"] forState:UIControlStateNormal];
//        [avatarBtn setTitle:@"选择联系人" forState:UIControlStateNormal];
//        avatarBtn.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
//        [avatarBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        avatarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        
//        avatarBtn.enabled = YES;
//        adviceView.hidden = NO;
//        stateLabel.hidden = YES;
//        timeLabel.hidden = YES;
//        tipLabel.hidden = YES;
//    }
//}

- (void)updateTime
{
    NSUInteger h = tickCount/3600;
    NSUInteger t = tickCount%3600;
    NSUInteger m = t/60;
    NSUInteger s = t%60;
    timeLabel.text = [NSString stringWithFormat:@"%02u:%02u:%02u", h, m, s];
}

- (void)handleTimer:(NSTimer *)tm
{
    tickCount++;
    [self updateTime];
}

- (void)startTimer
{
    [self stopTimer];
    tickTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:tickTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    if (tickTimer) {
        if ([tickTimer isValid]) {
            [tickTimer invalidate];
        }
        tickTimer = nil;
    }
    tickCount = 0;
}

- (void)startConnect
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPush2TalkPushKey
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInt:kPush2TalkCallRemote], kPush2TalkPushType,
                                                                self, kPush2TalkPushValue, nil]];
    [self startTimer];
    [ringPlayer play];
}

- (void)stopConnect
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPush2TalkPushKey
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                [NSNumber numberWithInt:kPush2TalkQuit], kPush2TalkPushType,
                                                                self.sessionInfo.remoteUserInfo.user_id, kPush2TalkPushValue, nil]];
}

- (void)push2TalkConnected
{
    sender = [[TalkSender alloc] initWithSampleRate:sessionInfo.localSampleRate
                                        talkManager:talkManager];
    recver = [[TalkRecver alloc] initWithSampleRate:sessionInfo.localSampleRate];
    
    talkManager.dataDelegate = recver;
    talkManager.controlingDelegate = self;
    
    if (sessionInfo.userType == kPush2TalkCaller) {
        self.talkState = kTalkStateCanTalk;
        
        [ringPlayer stop];
    }
    else {
        [self startTimer];
        self.talkState = kTalkStateListening;
        [recver start];
    }
    
    [talkManager startPush2TalkWithSessionInfo:sessionInfo];
    
    [self updateViews];
}

- (void)endSession
{
    [talkManager endSession];
    
    [recver stop];
    [sender stop];
    
    RCDebug(@"Push-to-talk session ended");
}

- (void)push2TalkEnded
{
    if (sessionInfo.connected) {
        [self endSession];
    }
    else {
        if ([ringPlayer isPlaying]) {
            [ringPlayer stop];
        }
    }
//    if (sessionInfo.userType == kPush2TalkCaller) {
//        if (sessionInfo.connected) {
//            [self sendTalkRecordToUser:remoteUser contentType:TYPE_CALL duration:tickCount];
//        }
//        else {
//            [self sendTalkRecordToUser:remoteUser contentType:TYPE_MISS_CALL duration:0];
//        }
//    }
}

#pragma mark - Push2TalkManagerDelegate

- (void)push2TalkDidConnectWithManager:(Push2TalkManager *)manager
{
    RCTrace(@"connected");
}

#pragma mark - states

NSString *stringOfTalkState(TalkState ts)
{
    NSString *s = nil;
    switch (ts) {
        case kTalkStateCanTalk:
            s = @"kTalkStateCanTalk";
            break;
        case kTalkStateReady:
            s = @"kTalkStateReady";
            break;
        case kTalkStateListening:
            s = @"kTalkStateListening";
            break;
        case kTalkStateTalking:
            s = @"kTalkStateTalking";
            break;
        default:
            s = @"unkown talk state";
            break;
    }
    return s;
}

- (void)playBeep
{
    AudioServicesPlaySystemSound(beepSoundID);
}

- (void)didChangeTalkState
{
    switch (talkState) {
        case kTalkStateCanTalk:
            tipLabel.text = @"请按住说话";
            [self playBeep];
            break;
            
        case kTalkStateListening:
            tipLabel.text = @"按一下键表示您想说话";
            break;
            
        case kTalkStateTalking:
            tipLabel.text = @"说话中...";
            break;
            
        case kTalkStateReady:
            break;
            
        default:
            break;
    }
}

- (void)setTalkState:(TalkState)newTalkState
{
    RCTrace(@"old:%d, new:%d", talkState, newTalkState);
    
    if (talkState == newTalkState) {
        return;
    }
    talkState = newTalkState;
    [self performSelectorOnMainThread:@selector(didChangeTalkState) withObject:nil waitUntilDone:NO];
}

#pragma mark - LoochaAlertViewDelegate

//- (void)loochaAlertView:(LoochaAlertView *)alertView didSelectButtonAt:(NSUInteger)index
//{
//    alertView.delegate = nil;
//    [self stopConnect];
//}

#pragma mark - TalkManagerControlingDelegate

- (void)handleCMessageType:(NSNumber *)typeObj
{
    CMessageType type = [typeObj intValue];
    
    RCDebug(@"before>> state:%@ type:%@<%d>", stringOfTalkState(talkState), stringOfCMessageType(type), type);
    switch (self.talkState) {
        case kTalkStateTalking:
            if (type == kCMT_WTT) {
                tipLabel.text = @"您的朋友想说话";
            }
            break;
            
        case kTalkStateListening:
            if (type == kCMT_DNT) {
                [recver stop];
                if (pressed) {
                    [sender start];
                    self.talkState = kTalkStateTalking;
                }
                else {
                    self.talkState = kTalkStateCanTalk;
                }
            }
            else if (type == kCMT_WTT) {
                [sender stop];
                [recver start];
                //                [talkManager sendControlMessage:kCMT_DNT];
            }
            break;
            
        case kTalkStateCanTalk:
            if (type == kCMT_WTT) {
                self.talkState = kTalkStateListening;
                [sender stop];
                [recver start];
                [talkManager sendControlMessage:kCMT_DNT];
            }
            
        default:
            break;
    }
    RCDebug(@"after>> state:%@ type:%@<%d>", stringOfTalkState(talkState), stringOfCMessageType(type), type);
}

- (void)talkManager:(TalkManager *)theTalkManager responsedWithControlType:(CMessageType)type
{
    [self performSelectorOnMainThread:@selector(handleCMessageType:) withObject:[NSNumber numberWithInt:type] waitUntilDone:NO];
}

//- (void)timeoutFortalkManager:(TalkManager *)talkManager
//{
//    LoochaAlertView *alert = [[LoochaAlertView alloc] initWithTitle:sessionInfo.remoteUserInfo.name
//                                                            message:@"您的网络不稳定，请稍后再试！"
//                                                   buttonTitleArray:[NSArray arrayWithObject:@"确定"]];
//    [alert.imageView setImageWithURL:[CampusSingleton convertNeedPath:sessionInfo.remoteUserInfo.avatar]
//                    placeholderImage:nil];
//    alert.delegate = self;
//    [alert show];
//    [alert release];
//    
//    [self playBeep];
//}

//-(BOOL)handleMessage:(int)messageType withResult:(int)result withArg:(id)arg
//{
//    switch (messageType) {
//        case kTaskMsgPush2TalkUserSelected:
//        {
//            sessionInfo.remoteUserInfo = (UserInfo *)arg;
//            [self startConnect];
//            [self updateViews];
//            return YES;
//            break;
//        }
//    }
//    return NO;
//}

@end
