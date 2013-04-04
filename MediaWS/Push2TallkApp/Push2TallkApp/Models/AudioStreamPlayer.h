//
//  AudioStreamPlayer.h
//  LoochaEnterprise
//
//  Created by jinquan zhang on 12-8-20.
//  Copyright (c) 2012年 realcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioStreamPlayer : NSObject
{
    AudioStreamBasicDescription mDataFormat;  
    AudioQueueRef queue;//播放队列  
    UInt32 FrameCount;  
    UInt32              inBufferByteSize;
    BOOL                        playing;
}

- (void)setupSampleRate:(NSUInteger)samplerate channel:(NSUInteger)channel;

- (void)startPlaying;

- (void)stopPlaying;

- (AudioQueueBufferRef)getEmptyQueueBuffer;

- (void)putQueueBuffer:(AudioQueueBufferRef)queueBuffer;

- (BOOL)isPlaying;

- (UInt32)queueBufferByteSize;

@end
