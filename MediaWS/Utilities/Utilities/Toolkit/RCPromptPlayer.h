//
//  RCPromptPlayer.h
//  LoochaUtils
//
//  Created by jinquan zhang on 12-8-22.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface RCPromptPlayer : NSObject
{
    SystemSoundID soundID;
    NSURL *soundURL;
    BOOL registered;
    BOOL playing;
    BOOL playWithVibrate;
    NSTimeInterval repeatGapInterval;
    NSInteger repeatCount;
    NSInteger counter;
}

// default value is NO
@property (nonatomic) BOOL playWithVibrate;
// 0 means infinite, default value is 1
@property (nonatomic) NSInteger repeatCount;
// default value is 0
@property (nonatomic) NSTimeInterval repeatGapInterval;

+ (id)vibratePromptPlayer;

- (id)initWithSystemSoundID:(SystemSoundID)soundID;

- (id)initWithURL:(NSURL *)url;

- (BOOL)isPlaying;

- (void)start;

- (void)stop;

- (void)stopImmediately:(BOOL)immediately;

@end
