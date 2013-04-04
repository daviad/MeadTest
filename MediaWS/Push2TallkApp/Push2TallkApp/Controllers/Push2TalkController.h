//
//  Push2TalkController.h
//  LoochaCampus
//
//  Created by jinquan zhang on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

#import "TalkSessionInfo.h"
#import "Push2TalkManager.h"

typedef enum {
    kTalkStateReady,
    kTalkStateCanTalk,
    kTalkStateListening,
    kTalkStateTalking
} TalkState;

@class AudioStreamPlayer;
@class TalkSender;
@class TalkRecver;
@class TalkManager;

@interface Push2TalkController : UIViewController <Push2TalkManagerDelegate>
{
    UIImageView *controlView;
    UIButton *avatarBtn;
    UIImageView *adviceView;
    UILabel *stateLabel;
    UILabel *timeLabel;
    UILabel *tipLabel;
    
    AVAudioPlayer *ringPlayer;
    SystemSoundID beepSoundID;
    
    TalkManager *talkManager;
    
    TalkSender *sender;
    TalkRecver *recver;
    
    NSTimer *tickTimer;
    NSUInteger tickCount;
    
    TalkSessionInfo *sessionInfo;
    TalkState talkState;
    BOOL pressed;
}

@property (nonatomic, readonly) TalkSessionInfo *sessionInfo;

// 被叫
- (id)initWithSessionInfo:(TalkSessionInfo *)sessionInfo;

// 主叫
- (id)init;

- (id)initWithUser:(UserInfo *)user;

- (void)startConnect;

- (void)push2TalkConnected;

- (void)push2TalkEnded;

@end
