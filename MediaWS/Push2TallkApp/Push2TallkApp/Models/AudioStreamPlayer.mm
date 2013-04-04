//
//  AudioStreamPlayer.m
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-20.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AudioStreamPlayer.h"

#define vQueueBufferByteSizeMin 2048
#define vQueueBufferByteSizeMax 8192

@implementation AudioStreamPlayer

- (void)audioQueueOutputWithQueue:(AudioQueueRef)audioQueue queueBuffer:(AudioQueueBufferRef)audioQueueBuffer 
{
    OSStatus status = AudioQueueFreeBuffer(audioQueue, audioQueueBuffer);
    if (status != 0) {
       // printf("Failed to free queue buffer\n");
        RCTrace(@"Failed to free queue buffer");
    }
}

static void BufferCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef buffer) {
    
    AudioStreamPlayer* player = (AudioStreamPlayer*)inUserData;
    
    if (player) {
        [player audioQueueOutputWithQueue:inAQ queueBuffer:buffer];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupSampleRate:8000 channel:1];
    }
    return self;
}

- (void)initAudioQueue
{
    // prime the queue with some data before starting
    OSStatus status = AudioQueueNewOutput(&mDataFormat, BufferCallback, self, nil, nil, 0, &queue);
    if (status != 0) {
		printf("Could not AudioQueueNewOutput new queue\n");
		return;
	}
    
    status = AudioQueueSetParameter (queue, kAudioQueueParam_Volume, 1.0);
    if (status != 0) {
        printf("Could not AudioQueueSetParameter\n");
        return;
    }
}

- (void)destoryAudioQueue
{
    AudioQueueFlush(queue);
    OSStatus result = AudioQueueStop(queue, true);
    if (result) 
        printf("ERROR STOPPING QUEUE!\n");
    playing = NO;
	AudioQueueDispose(queue, true);
}

- (void)setupSampleRate:(NSUInteger)samplerate channel:(NSUInteger)channel
{
    mDataFormat.mSampleRate = (Float64)samplerate;  
    mDataFormat.mFormatID = kAudioFormatLinearPCM;  
    mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
    mDataFormat.mBytesPerPacket = 2;  
    mDataFormat.mFramesPerPacket = 1;  
    mDataFormat.mBytesPerFrame = 2;  
    mDataFormat.mChannelsPerFrame = channel;  
    mDataFormat.mBitsPerChannel = 16; 
    
    inBufferByteSize = mDataFormat.mSampleRate * 2 * 0.06 * mDataFormat.mChannelsPerFrame;
    if (inBufferByteSize < vQueueBufferByteSizeMin) {
        inBufferByteSize = vQueueBufferByteSizeMin;
    }
    else if (inBufferByteSize > vQueueBufferByteSizeMax) {
        inBufferByteSize = vQueueBufferByteSizeMax;
    }
    
//    [self initAudioQueue];
}

- (void)dealloc
{
//    [self destoryAudioQueue];
    [super dealloc];
}

- (void)startPlaying
{   
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    [self initAudioQueue];
    OSStatus status;        
    status = AudioQueueStart(queue, NULL);
    if (status != 0) {
        printf("Could not AudioQueueStart\n");
        return;
    }
    
    playing = YES;
}

- (void)stopPlaying
{
#if 0
    AudioQueueFlush(queue);
    OSStatus result = AudioQueueStop(queue, true);
    if (result) 
        printf("ERROR STOPPING QUEUE!\n");
    playing = NO;
#endif
    [self destoryAudioQueue];
}

- (AudioQueueBufferRef)getEmptyQueueBuffer
{
    if (playing) {
        AudioQueueBufferRef queueBuffer = NULL;
        OSStatus status = AudioQueueAllocateBuffer(queue, inBufferByteSize, &queueBuffer);
        if (status != 0) {
            printf("Could not AudioQueueAllocateBuffer\n");
            return NULL;
        }
        return queueBuffer;
    }
    return NULL;
}

- (void)putQueueBuffer:(AudioQueueBufferRef)queueBuffer
{
    if (queueBuffer) {
        OSStatus status = AudioQueueEnqueueBuffer(queue, queueBuffer, 0, NULL);
        if (status != 0) {
            printf("Could not AudioQueueEnqueueBuffer\n");
            return;
        }
    }
}

- (BOOL)isPlaying
{
    return playing;
}

- (UInt32)queueBufferByteSize
{
    return inBufferByteSize;
}

@end
