//
//  AudioStreamPlayer.m
//  LooCha
//
//  Created by XiongCaixing on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "AudioStreamPlayer.h"

void AudioStreamPlayer::AQBufferCallback(void *			inUserData,
                                         AudioQueueRef			inAQ,
                                         AudioQueueBufferRef		inCompleteAQBuffer) 
{
	AudioStreamPlayer *THIS = (AudioStreamPlayer *)inUserData;
    
    if(!THIS->write_start)
    {
        return;
    }
    
    printf("QueueDataCap=%ld\n", inCompleteAQBuffer->mAudioDataBytesCapacity);
    printf("QueueDataSize=%ld\n", inCompleteAQBuffer->mAudioDataByteSize);
    short* pData = THIS->getQueueItem();
    if(pData != NULL)
    {            
        memcpy(inCompleteAQBuffer->mAudioData, pData, BUFFER_SIZE);
        inCompleteAQBuffer->mAudioDataByteSize = BUFFER_SIZE;
        AudioQueueEnqueueBuffer(inAQ, inCompleteAQBuffer, 0, NULL);
    }
}

void AudioStreamPlayer::AddQueueBuffer(short* pBuffer)
{
    mFrameQueue.EnQueue(pBuffer, BUFFER_SIZE);
    if(!write_start)
    {
        AudioQueueBufferRef curbuf = mBuffers[mBufferIndex];
        memcpy(curbuf->mAudioData, getQueueItem(), BUFFER_SIZE);
        WriteAQ(mBuffers[mBufferIndex]);
        mBufferIndex++;
        if(mBufferIndex == kNumberBuffers)
        {
            write_start = true;
        }
    }
    printf("addQueue readindex=%d writeindex=%d\n", mReadIndex, mWriteIndex);
}


void AudioStreamPlayer::WriteAQ(AudioQueueBufferRef queueRef)
{
    AudioQueueEnqueueBuffer(mQueue, queueRef, 0, NULL);
}


short* AudioStreamPlayer::getQueueItem()
{
    return (short *)mFrameQueue.DeQueue();
}

AudioStreamPlayer::AudioStreamPlayer() :
    mQueue(0),
    mAudioFile(0),
    mIsRunning(false),
    mIsInitialized(false),
    mReadIndex(0),
    mWriteIndex(0),
    mNumPacketsToRead(0),
    mCurrentPacket(0),
    mIsDone(false),
    mIsLooping(false) 
{ 
    mBufferIndex = 0;
    write_start = false;	
    count = 0;
    mFrameQueue.InitQueue(QUEUE_SIZE, BUFFER_SIZE);
}

AudioStreamPlayer::~AudioStreamPlayer() 
{
	DisposeQueue(true);
}

OSStatus AudioStreamPlayer::StartQueue(BOOL inResume)
{		
	mIsDone = false;
	
	// if we are not resuming, we also should restart the file read index
	if (!inResume)
		mCurrentPacket = 0;	
    
	// prime the queue with some data before starting
	for (int i = 0; i < kNumberBuffers; ++i) {
		AQBufferCallback (this, mQueue, mBuffers[i]);			
	}
	return AudioQueueStart(mQueue, NULL);
}

OSStatus AudioStreamPlayer::StopQueue()
{
	OSStatus result = AudioQueueStop(mQueue, true);
	if (result) printf("ERROR STOPPING QUEUE!\n");
    
	return result;
}

OSStatus AudioStreamPlayer::PauseQueue()
{
	OSStatus result = AudioQueuePause(mQueue);
    
	return result;
}

void AudioStreamPlayer::SetStreamFormat() 
{	
   // UInt32 theSize;
    
    memset(&mDataFormat, 0, sizeof(mDataFormat));
    
    mDataFormat.mSampleRate = 8000.0;
	mDataFormat.mFormatID = kAudioFormatLinearPCM;
	mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
	mDataFormat.mChannelsPerFrame = 1;
	mDataFormat.mBitsPerChannel = 16; 
	mDataFormat.mFramesPerPacket = 1;
	mDataFormat.mBytesPerPacket = 2; 
	mDataFormat.mBytesPerFrame = 2; // not used, apparently required
	mDataFormat.mReserved = 0; 
    
  //  theSize = sizeof(mDataFormat);
    SetupNewQueue();
}

void AudioStreamPlayer::SetupNewQueue() 
{
    
    AudioQueueNewOutput(&mDataFormat, AudioStreamPlayer::AQBufferCallback, this, 
                        NULL, NULL, 0, &mQueue);	
	for (int i = 0; i < kNumberBuffers; ++i) {
		AudioQueueAllocateBuffer(mQueue, BUFFER_SIZE, &mBuffers[i]);
	}	
    AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, 100.0);
	
	mIsInitialized = true;
}

void AudioStreamPlayer::DisposeQueue(Boolean inDisposeFile)
{
	if (mQueue)
	{
		AudioQueueDispose(mQueue, true);
		mQueue = NULL;
	}
	if (inDisposeFile)
	{
		if (mAudioFile)
		{		
			AudioFileClose(mAudioFile);
			mAudioFile = 0;
		}
	}
	mIsInitialized = false;
}
