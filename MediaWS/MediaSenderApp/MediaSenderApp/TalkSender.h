//
//  TalkSender.h
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-23.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCQueue.h"

@class AudioStreamRecord;
@class TalkSender;

@protocol TalkSenderDelegate <NSObject>

- (void)didFinishSendingWithSender:(TalkSender *)sender;

@end

@interface TalkSender : NSObject
{
    NSConditionLock *lock;
    RCQueue *frameQueue;
    RCQueue *dataQueue;
    NSMutableArray *reuseFrames;
    
    BOOL talking;
    BOOL running;

    AudioStreamRecord *recorder;
    
    short *pkgBuffer;
    int frameSize;
    int pkgBufferSize;
    int pkgBufferEnd;
    
    id<TalkSenderDelegate> delegate;
}

@property (nonatomic, assign) id<TalkSenderDelegate> delegate;

- (id)initWithSampleRate:(NSInteger)samplerate talkManager:(id *)talkManager;

- (void)prepare;

- (void)start;

- (void)stop;

- (void)reset;


- (void)handleAudioBuffer:(short *)buf length:(UInt32)length;

@end
