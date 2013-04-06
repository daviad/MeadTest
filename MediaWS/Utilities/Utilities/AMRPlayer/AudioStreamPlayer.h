//
//  AudioStreamPlayer.h
//  LooCha
//
//  Created by XiongCaixing on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>

#include "CAStreamBasicDescription.h"
#include "CAXException.h"
#include "FrameQueue.h"

#define kNumberBuffers 3

class AudioStreamPlayer
{
public:
    AudioStreamPlayer();
    ~AudioStreamPlayer();
    
    FrameQueue mFrameQueue;
    
    OSStatus						StartQueue(BOOL inResume);
    OSStatus						StopQueue();		
    OSStatus						PauseQueue();
    
    AudioQueueRef					Queue()					{ return mQueue; }
    CAStreamBasicDescription		DataFormat() const		{ return mDataFormat; }		
    Boolean							IsRunning()	const		{ return (mIsRunning) ? true : false; }
    Boolean							IsInitialized()	const	{ return mIsInitialized; }		
    Boolean							IsLooping() const		{ return mIsLooping; }
    
    void SetLooping(Boolean inIsLooping)	{ mIsLooping = inIsLooping; }
    void SetStreamFormat();
    void DisposeQueue(Boolean inDisposeFile);	
    void AddQueueBuffer(short* pBuffer);
    short* getQueueItem();
    
private:
    const static int                BUFFER_SIZE = 320;
    const static int                QUEUE_SIZE = 1000;
    UInt32							GetNumPacketsToRead()				{ return mNumPacketsToRead; }
    SInt64							GetCurrentPacket()					{ return mCurrentPacket; }
    AudioFileID						GetAudioFileID()					{ return mAudioFile; }
    void							SetCurrentPacket(SInt64 inPacket)	{ mCurrentPacket = inPacket; }
    
    void							SetupNewQueue();
    void WriteAQ(AudioQueueBufferRef queueRef);
    
    AudioQueueRef					mQueue;
    AudioQueueBufferRef				mBuffers[kNumberBuffers];
    int                             mBufferIndex;
    int                             mReadIndex;
    int                             mWriteIndex;
    AudioFileID						mAudioFile;
    CAStreamBasicDescription		mDataFormat;
    Boolean							mIsInitialized;
    UInt32							mNumPacketsToRead;
    SInt64							mCurrentPacket;
    UInt32							mIsRunning;
    Boolean							mIsDone;
    Boolean							mIsLooping;
    int count;
    bool                            write_start;
    
    static void isRunningProc(		void *              inUserData,
                              AudioQueueRef           inAQ,
                              AudioQueuePropertyID    inID);
    
    static void AQBufferCallback(	void *					inUserData,
                                 AudioQueueRef			inAQ,
                                 AudioQueueBufferRef		inCompleteAQBuffer); 
};
