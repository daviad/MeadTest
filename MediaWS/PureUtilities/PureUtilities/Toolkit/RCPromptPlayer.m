//
//  PromptPlayer.m
//  LoochaUtils
//
//  Created by jinquan zhang on 12-8-22.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "RCPromptPlayer.h"

static CFMutableSetRef playerSet;

@implementation RCPromptPlayer

@synthesize playWithVibrate;
@synthesize repeatCount;
@synthesize repeatGapInterval;

+ (id)vibratePromptPlayer
{
    return [[[RCPromptPlayer alloc] initWithSystemSoundID:kSystemSoundID_Vibrate] autorelease];
}

- (void)handleCompletion
{
    if (playing && (repeatCount == 0 || counter < repeatCount)) {
        [self performSelector:@selector(play) withObject:nil afterDelay:repeatGapInterval];
    }
}

static void audioServicesSystemSoundCompletionProc(SystemSoundID  ssID, void *clientData)
{
    if (playerSet && CFSetContainsValue(playerSet, clientData)) {
        RCPromptPlayer *player = (RCPromptPlayer *)clientData;
        [player handleCompletion];
    }
}

static Boolean mySetEqualCallBack(const void *value1, const void *value2)
{
    return value1 == value2;
}

static CFHashCode mySetHashCallBack(const void *value)
{
    return (CFHashCode)value;
}

- (void)registerSound
{
    if (soundID == 0) {
        if (soundURL == nil) {
            return;
        }
        AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &soundID);
    }
    BOOL shouldRegister = YES;
    @synchronized([self class]) {
        if (playerSet == NULL) {
            CFSetCallBacks myCallBacks = {0, NULL, NULL, NULL, mySetEqualCallBack, mySetHashCallBack};
            playerSet = CFSetCreateMutable(CFAllocatorGetDefault(), 16, &myCallBacks);
        }
        if (CFSetContainsValue(playerSet, self)) {
            shouldRegister = NO;
        }
        else {
            CFSetAddValue(playerSet, self);
        }
    }
    if (shouldRegister) {
        AudioServicesAddSystemSoundCompletion(soundID, CFRunLoopGetMain(), kCFRunLoopDefaultMode, audioServicesSystemSoundCompletionProc, self);
        
        AudioServicesPropertyID flagIsUISound = 0;  // 0 means always play
        AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &soundID, sizeof(AudioServicesPropertyID), &flagIsUISound);
        AudioServicesPropertyID flagIfAppDies = 1;
        AudioServicesSetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, sizeof(SystemSoundID), &soundID, sizeof(AudioServicesPropertyID), &flagIfAppDies);

    }
    registered = YES;
}

- (void)unregisterSound
{
    @synchronized([self class]) {
        CFSetRemoveValue(playerSet, self);
    }
    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
    if (soundURL) {
        soundID = 0;
    }
    registered = NO;
}

- (void)commonInit
{
    repeatCount = 1;
    counter = 0;
    repeatGapInterval = 0;
    soundID = 0;
    registered = NO;
    playWithVibrate = NO;
}

- (id)initWithSystemSoundID:(SystemSoundID)theSoundID
{
    self = [super init];
    if (self) {
        [self commonInit];
        soundID = theSoundID;
    }
    return self;
}

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        [self commonInit];
        soundURL = [url retain];
    }
    return self;
}

- (void)dealloc
{
    if (registered) {
        [self unregisterSound];
    }
    [soundURL release];
    [super dealloc];
}

- (BOOL)isPlaying
{
    return playing;
}

- (void)play
{
    counter++;
    if (playWithVibrate) {
        AudioServicesPlayAlertSound(soundID);
    }
    else {
        AudioServicesPlaySystemSound(soundID);
    }
}

- (void)start
{
    if (!registered) {
        [self registerSound];
    }
    counter = 0;
    playing = YES;
    if (repeatCount >= 0) {
        [self play];
    }
}

- (void)stop
{
    [self stopImmediately:NO];
}

- (void)stopImmediately:(BOOL)immediately
{
    playing = NO;
    if (immediately && registered) {
        [self unregisterSound];
    }
}

@end
