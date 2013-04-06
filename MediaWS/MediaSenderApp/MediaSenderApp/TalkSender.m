//
//  TalkSender.m
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-23.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import "TalkSender.h"
#import "RCLog.h"



#define ENCODE_BUFFER_SIZE 1440
#define CONDITION_HAS_DATA 1
#define CONDITION_NO_DATA  0

@interface TalkSender ()

@property (readwrite) BOOL talking;
@property (readwrite) BOOL running;

@end

@implementation TalkSender

@synthesize talking;
@synthesize running;
@synthesize delegate;

- (NSMutableData *)getFrameBuffer
{
    RCTrace(@"reuseFrames size : %d", [reuseFrames count]);
    
    NSMutableData *frameBuffer = nil;
    
    @synchronized(reuseFrames) {
        frameBuffer = [reuseFrames lastObject];
        if (frameBuffer) {
            [frameBuffer retain];
            [reuseFrames removeLastObject];
        }
    }
    if (frameBuffer == nil) {
        frameBuffer = [[NSMutableData alloc] initWithLength:frameSize * sizeof(short)];
    }
    return frameBuffer;
}

- (void)collectFrameBuffer:(NSMutableData *)frameBuffer
{
    @synchronized(reuseFrames) {
        [reuseFrames addObject:frameBuffer];
    }
    [frameBuffer release];
}

- (void)copyFrame
{
    NSMutableData *frameBuffer = [self getFrameBuffer];
    memcpy([frameBuffer mutableBytes], pkgBuffer, frameSize * sizeof(short));
    
    [lock lock];
    [frameQueue push:frameBuffer];
    [frameBuffer release];
    [lock unlockWithCondition:CONDITION_HAS_DATA];
}

// pick and encode one frame while the frameQueue is not empty
- (void)handleFrameBuffers
{
    static unsigned char enbuf [ENCODE_BUFFER_SIZE];
    static int roundCount = 0;
    NSMutableData *frameBuffer = nil;
    
    // ensure self object is valid when this thread is running
    self.running = YES;
    [self retain];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    while (YES) {
        // even if talk is stopped, but if data comes in, this thread must handle the datas
        if (![lock lockWhenCondition:CONDITION_HAS_DATA
                          beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.3]]) {
            if (self.talking) {
                // wait for data coming continue
                continue;
            }
            else {
                // if not talking, talk must be stopped
                break;
            }
        }
        
        RCTrace(@"frameQueue size : %d", [frameQueue length]);
        
        frameBuffer = [frameQueue peek];
        [frameBuffer retain];
        [frameQueue poll];
        
        [lock unlockWithCondition:[frameQueue length] != 0 ? CONDITION_HAS_DATA : CONDITION_NO_DATA];
        
        memset(enbuf, 0, ENCODE_BUFFER_SIZE);
        int enlen = opusEncode([frameBuffer bytes], enbuf, frameSize);
        if (enlen > 0) {
            // [talkManager sendData:enbuf length:enlen];
            NSData *data = [[NSData alloc] initWithBytes:enbuf length:enlen];
            @synchronized(dataQueue) {
                [dataQueue push:data];
            }
            [data release];
        }
        else {
            RCError(@"opusEncode ERROR");
        }
        [self collectFrameBuffer:frameBuffer];
        
        if (++roundCount % 64 == 0) {
            [pool drain];
            pool = [[NSAutoreleasePool alloc] init];
        }
    }
    [pool drain];
    self.running = NO;
    [self release];
}

- (void)handleAudioBuffer:(short *)buf length:(UInt32)length
{
    int newEnd = pkgBufferEnd + length;
    
    memcpy(pkgBuffer + pkgBufferEnd, buf, length * sizeof(short));
    
    if (newEnd > pkgBufferSize) {
        RCFatal(@"pkgBufferEnd + length > pkgBufferSize");
    }
    else if (newEnd >= frameSize) {
        [self copyFrame];
        memcpy(pkgBuffer, pkgBuffer + frameSize, (newEnd - frameSize) * sizeof(short));
        pkgBufferEnd = newEnd - frameSize;
    }
    else {
        pkgBufferEnd = newEnd;
    }
}

static void RecordBufferListen(id o, short *buf, UInt32 length) 
{
    RCTrace(@"recorded packets : %ld", length);
    [(TalkSender *)o handleAudioBuffer:buf length:length];
}

// pick and send one raw data pakage every 50ms from dataQueue
- (void)handleSending
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    while (self.talking || [dataQueue length]) {
        CFTimeInterval cur = [[NSDate date] timeIntervalSince1970];
        NSData *data = nil;
        @synchronized(dataQueue) {
            data = [dataQueue peek];
            if (data) {
                [data retain];
                [dataQueue poll];
            }
        }
        if (data) {
           // [talkManager sendData:(void *)[data bytes] length:[data length]];
            [data release];
        }
        CFTimeInterval waitTime = 0.050 - ([[NSDate date] timeIntervalSince1970] - cur);
        if (waitTime > 0) {
            [NSThread sleepForTimeInterval:waitTime];
        }
    }
    [delegate didFinishSendingWithSender:self];
    
    [pool drain];
}

//- (id)initWithSampleRate:(NSInteger)samplerate talkManager:(TalkManager *)tm
//{
//    self = [super init];
//    if (self) {
//        lock = [[NSConditionLock alloc] initWithCondition:CONDITION_NO_DATA];
//        frameQueue = [[RCQueue alloc] init];
//        dataQueue = [[RCQueue alloc] init];
//        reuseFrames = [[NSMutableArray alloc] init];
//        
//        talkManager = [tm retain];
//        opusEncodeOpen(samplerate, 1);
//        
//        recorder = [[AudioStreamRecord alloc] init];
//        [recorder setupAudioSample:samplerate Channel:1];
//        [recorder setupAudioCallback:RecordBufferListen AndObj:self];
//        
//        frameSize = samplerate * 60/1000;
//        pkgBufferSize = 2 * frameSize;
//        pkgBuffer = malloc(pkgBufferSize * sizeof(short));
//        pkgBufferEnd = 0;
//    }
//    return self;
//}

- (void)dealloc
{
    [self stop];
    self.delegate = nil;
    [recorder release];
   
    
    [lock release];
    [frameQueue release];
    [dataQueue release];
    [reuseFrames release];
    
    free(pkgBuffer);
    opusDecodeClose();
    [super dealloc];
}

- (void)prepare
{
    if (!self.running) {
        [self performSelectorInBackground:@selector(handleSending) withObject:nil];
        [self performSelectorInBackground:@selector(handleFrameBuffers) withObject:nil];
    }
}

- (void)start
{
    self.talking = YES;
    [self prepare];
    if (![recorder isRecording]) {
        [recorder startRecording];
    }
}

- (void)stop
{
    if ([recorder isRecording]) {
        [recorder stopRecording];
    }
    self.talking = NO;
}

- (void)reset
{
}

@end
