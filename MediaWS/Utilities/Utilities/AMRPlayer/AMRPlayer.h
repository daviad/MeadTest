//
//  AMRPlayer.h
//  LooCha
//
//  Created by XiongCaixing on 12-4-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>

#define NUM_BUFFERS 3
#define kPlayFlag @"kPlayFlag"
@class AMRPlayer;

@protocol AMRPlayerDelegate <NSObject>

- (void)amrDidBeginPlayingWithPlayer:(AMRPlayer *)player;

- (void)amrDidEndPlayingWithPlayer:(AMRPlayer *)player;

@end

@interface AMRPlayer : NSObject {
    
    //播放音频文件ID
    AudioFileID audioFile;
    
    //音频流描述对象
    AudioStreamBasicDescription dataFormat;
    
    //音频队列
    AudioQueueRef queue;
    
    SInt64 packetIndex;
    
    UInt32 numPacketsToRead;
    
    UInt32 bufferByteSize;
    
    AudioStreamPacketDescription *packetDescs;
    
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    int * _destate;
    int _hasReadSize;
    FILE* _amrFile;
    void *st;
    
    id<AMRPlayerDelegate> delegate;
}

//定义队列为实例属性

@property AudioQueueRef queue;
@property (nonatomic, assign) id<AMRPlayerDelegate> delegate;
@property (nonatomic,copy) NSString *path;
@property (nonatomic, assign) BOOL playing;

+ (AMRPlayer *)sharedInstance;

//播放方法定义

- (void) startPlay:(const char*) path;//CFURLRef

- (void) stopPlay;

//定义缓存数据读取方法

- (void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue
                       queueBuffer:(AudioQueueBufferRef)audioQueueBuffer;

//定义回调（Callback）函数

static void BufferCallback(void *inUserData, AudioQueueRef inAQ,
                           AudioQueueBufferRef buffer);

static void isRunningProc(void * inUserData,AudioQueueRef queue,AudioQueuePropertyID  inID);

//定义包数据的读取方法

- (UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer;

@end
