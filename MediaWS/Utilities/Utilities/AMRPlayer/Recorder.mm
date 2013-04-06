//
//  Recorder.m
//  LooCha
//
//  Created by XiongCaixing on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "Recorder.h"
#import "speexpreprocess.h"
#include "AMRFileHandle.h"

// Derive the Buffer Size. I punt with the max buffer size.
void DeriveBufferSize (
					   AudioQueueRef                audioQueue,
					   AudioStreamBasicDescription  ASBDescription,
					   Float64                      seconds,
					   UInt32                       *outBufferSize
                       ) {
    static const int maxBufferSize = 0x50000;   
	
    int maxPacketSize = ASBDescription.mBytesPerPacket; 
    if (maxPacketSize == 0) {                           
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty (
							   audioQueue,
							   kAudioConverterPropertyMaximumOutputPacketSize,
							   &maxPacketSize,
							   &maxVBRPacketSize
							   );
    }
	
    Float64 numBytesForTime =
	ASBDescription.mSampleRate * maxPacketSize * seconds;
    *outBufferSize =  (UInt32) ((numBytesForTime < maxBufferSize) ? numBytesForTime : maxBufferSize);                     // 9
}

// Forward Declaration to Input Buffer Handler
static void HandleInputBuffer (
							   void                                *aqData,
							   AudioQueueRef                       inAQ,   
							   AudioQueueBufferRef                 inBuffer,
							   const AudioTimeStamp                *inStartTime,
							   UInt32                              inNumPackets,
							   const AudioStreamPacketDescription  *inPacketDesc
                               );

// Assign the file metadata
OSStatus SetMagicCookieForFile (
								AudioQueueRef inQueue,                          
								AudioFileID   inFile                            
                                ) {
    OSStatus result = noErr;                                   
    UInt32 cookieSize;                                         
	
    if (
		AudioQueueGetPropertySize (                        
								   inQueue,
								   kAudioQueueProperty_MagicCookie,
								   &cookieSize
								   ) == noErr
		) {
        char* magicCookie = (char *) malloc (cookieSize);                     
        if (
			AudioQueueGetProperty (                       
								   inQueue,
								   kAudioQueueProperty_MagicCookie,
								   magicCookie,
								   &cookieSize
								   ) == noErr
			)
            result = AudioFileSetProperty (            
                                           inFile,
                                           kAudioFilePropertyMagicCookieData,
                                           cookieSize,
                                           magicCookie
                                           );
        free (magicCookie);                               
    }
    return result;                                        
}

// Write out current packets
static void HandleInputBuffer (
							   void                                 *aqData,
							   AudioQueueRef                        inAQ,
							   AudioQueueBufferRef                  inBuffer,
							   const AudioTimeStamp                 *inStartTime,
							   UInt32                               inNumPackets,
							   const AudioStreamPacketDescription   *inPacketDesc
                               ) {
    
    RecordState *pAqData = (RecordState *) aqData;
    
    if (inNumPackets == 0 &&
		pAqData->dataFormat.mBytesPerPacket != 0)
		inNumPackets =
		inBuffer->mAudioDataByteSize / pAqData->dataFormat.mBytesPerPacket;
    
    denoise_preprocess(pAqData->st, (short *)(inBuffer->mAudioData));
    unsigned char amrFrame[MAX_AMR_FRAME_SIZE];
    int byte_counter = Encoder_Interface_Encode(pAqData->enstate, MR122, (short *)inBuffer->mAudioData, amrFrame, 0);
    fwrite(amrFrame, sizeof (unsigned char), byte_counter, pAqData->fpamr);
    
//    if (AudioFileWritePackets (
//							   pAqData->audioFile,
//							   NO,
//							   inBuffer->mAudioDataByteSize,
//							   inPacketDesc,
//							   pAqData->currentPacket,
//							   &inNumPackets,
//							   inBuffer->mAudioData
//							   ) == noErr) {
//		pAqData->currentPacket += inNumPackets;
//		
//		if (pAqData->recording == 0)
//			return;
		
		AudioQueueEnqueueBuffer (                 
								 pAqData->queue,
								 inBuffer,
								 0,
								 NULL
								 );
//	}
}

// Write the buffers out
void AudioInputCallback(
						void *inUserData, 
						AudioQueueRef inAQ, 
						AudioQueueBufferRef inBuffer, 
						const AudioTimeStamp *inStartTime, 
						UInt32 inNumberPacketDescriptions, 
						const AudioStreamPacketDescription *inPacketDescs)
{
    RecordState* recordState = (RecordState*)inUserData;
    if(!recordState->recording)  { printf("Not recording, returning\n"); return;  }
	
    printf("Writing buffer %lld\n", recordState->currentPacket++);
    denoise_preprocess(recordState->st, (short *)(inBuffer->mAudioData));
    unsigned char amrFrame[MAX_AMR_FRAME_SIZE];
    int byte_counter = Encoder_Interface_Encode(recordState->enstate, MR122, (short *)inBuffer->mAudioData, amrFrame, 0);
    fwrite(amrFrame, sizeof (unsigned char), byte_counter, recordState->fpamr);

//    OSStatus status = AudioFileWritePackets(recordState->audioFile,
//											NO,
//											inBuffer->mAudioDataByteSize,
//											inPacketDescs,
//											recordState->currentPacket,
//											&inNumberPacketDescriptions,
//											inBuffer->mAudioData);
//    if(status == 0) // success
//    {
//        recordState->currentPacket += inNumberPacketDescriptions;
//    }
	
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
}


@implementation Recorder

// Initialize the recorder
- (id) init
{
	self = [super init];
    fileURL = nil;
	recordState.recording = NO;
    recordState.st = NULL;
    recordState.fpamr = NULL;
    recordState.enstate = NULL;
	return self;
}

// Set up the recording format as low quality mono wav
- (void)setupAudioFormat:(AudioStreamBasicDescription*)format
{
	format->mSampleRate = 8000.0;
	format->mFormatID = kAudioFormatLinearPCM;
	format->mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked; 
	
	format->mChannelsPerFrame = 1; // mono
	format->mBitsPerChannel = 16; 
	format->mFramesPerPacket = 1;
	format->mBytesPerPacket = 2; 
	
	format->mBytesPerFrame = 2; // not used, apparently required
	format->mReserved = 0; 
}

// Begin recording
- (void) startRecording: (NSString *) filePath
{
    int dtx = 0;
    recordState.st = denoise_init(recordState.st, 160, 8000);
    recordState.enstate = Encoder_Interface_init(dtx);
    // 创建并初始化amr文件
	recordState.fpamr = fopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "wb");
	if (recordState.fpamr != NULL)
	{
        /* write magic number to indicate single channel AMR file storage format */
        fwrite(AMR_MAGIC_NUMBER, sizeof(char), strlen(AMR_MAGIC_NUMBER), recordState.fpamr);
	}

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:NULL];
    
    [self setupAudioFormat:&recordState.dataFormat];
//	fileURL =  CFURLCreateFromFileSystemRepresentation (NULL, (const UInt8 *) [filePath UTF8String], [filePath length], NO);
    recordState.currentPacket = 0;
	
    OSStatus status;
    status = AudioQueueNewInput(&recordState.dataFormat,
								HandleInputBuffer, 
								&recordState,
								CFRunLoopGetCurrent(),
								kCFRunLoopCommonModes,
								0,
								&recordState.queue);
	
	
	if (status != 0) {
		printf("Could not establish new queue\n");
		return;
	}
	
//	status = AudioFileCreateWithURL(fileURL,
//									kAudioFileWAVEType,
//									&recordState.dataFormat,
//									kAudioFileFlags_EraseFile,
//									&recordState.audioFile);
//	if (status != 0)
//	{
//		printf("Could not create file to record audio\n");
//		return;
//	}
	
	DeriveBufferSize (                               
					  recordState.queue,                
					  recordState.dataFormat,            
					  0.02,
					  &recordState.bufferByteSize
					  );
	// printf("Buffer size: %d\n", recordState.bufferByteSize);
	
	for(int i = 0; i < NUM_BUFFERS; i++)
	{
		status = AudioQueueAllocateBuffer(recordState.queue,
										  recordState.bufferByteSize, 
										  &recordState.buffers[i]);
		if (status) {
			printf("Error allocating buffer %d\n", i);
			return;
		}
        
		status = AudioQueueEnqueueBuffer(recordState.queue, recordState.buffers[i], 0, NULL);
		if (status) {
			printf("Error enqueuing buffer %d\n", i);
			return;
		}
	}
	//enable metering
    UInt32 enableMetering = YES;
    status = AudioQueueSetProperty(recordState.queue, kAudioQueueProperty_EnableLevelMetering, &enableMetering,sizeof(enableMetering));
    if (status) {printf("Could not enable metering\n"); return;}
    
    
//	status = SetMagicCookieForFile(recordState.queue, recordState.audioFile);
//	if (status != 0)
//	{
//		printf("Magic cookie failed\n");
//		return;
//	}
	
	status = AudioQueueStart(recordState.queue, NULL);
	if (status != 0)
	{
		printf("Could not start Audio Queue\n");
		return;
	}
	
	recordState.currentPacket = 0;
	recordState.recording = YES;
	return;
}

// There's generally about a one-second delay before the buffers fully empty
- (void) reallyStopRecording:(NSString *)filePath
{
	AudioQueueFlush(recordState.queue);
    AudioQueueStop(recordState.queue, NO);
    recordState.recording = NO;
//	SetMagicCookieForFile(recordState.queue, recordState.audioFile);
	
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(recordState.queue,
							 recordState.buffers[i]);
    }
	
    AudioQueueDispose(recordState.queue, YES);
//    AudioFileClose(recordState.audioFile);
//    NSString *fileName = [filePath lastPathComponent];
    denoise_destroy(recordState.st);
    Encoder_Interface_exit(recordState.enstate);
    if (recordState.fpamr)
    {
        fclose(recordState.fpamr);
        recordState.fpamr = NULL;
    }
    
    if (fileURL)
    {
//        CFRelease(fileURL);
        fileURL = nil;
    }
    
    recordState.st = NULL;
//    EncodeWAVEFileToAMRFile(filePath, [[fileName substringToIndex:[fileName length] - 4] stringByAppendingString:@".amr"], 1, 16);
}

// Stop the recording after waiting just a second
- (void) stopRecording:(NSString *)filePath compleate:(dispatch_block_t) block
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self reallyStopRecording:filePath];
        block();
    });
    
}

// Automatically create a file in Documents and start/stop recording to it
- (void) toggleRecording:(NSString*)fileName compleate:(dispatch_block_t) block
{
    NSString *strName = [fileName stringByAppendingString:@".amr"];
    NSString *cachePath = [PersistentDirectory persistentDirectory:@"voice"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:strName];
    if(!recordState.recording)
    {
        printf("Starting recording\n");
        [self startRecording: filePath];
    } else {
        printf("Stopping recording\n");
        [self stopRecording:filePath compleate:block];
        
    }
}


-(float)redordDuration:(NSString *)fileName
{
    NSString *strName = [fileName stringByAppendingString:@".amr"];
    NSString *cachePath = [PersistentDirectory persistentDirectory:@"voice"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:strName];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    long fileSize = [[fileAttributes valueForKey:NSFileSize] longValue];
    return ((float)(fileSize - 6.0f)) / (32.0f)*0.02;
    
    
    
}

- (BOOL) isRecording
{
	return recordState.recording;
}


- (float) averagePower
{
    AudioQueueLevelMeterState state[1];
    UInt32  statesize = sizeof(state);
    OSStatus status;
    status = AudioQueueGetProperty(recordState.queue, kAudioQueueProperty_CurrentLevelMeter, &state, &statesize);
    if (status) {printf("Error retrieving meter data\n"); return 0.0f;}
    return state[0].mAveragePower;
}
- (float) peakPower
{
    AudioQueueLevelMeterState state[1];
    UInt32  statesize = sizeof(state);
    OSStatus status;
    status = AudioQueueGetProperty(recordState.queue, kAudioQueueProperty_CurrentLevelMeter, &state, &statesize);
    if (status) {printf("Error retrieving meter data\n"); return 0.0f;}
    return state[0].mPeakPower;
}
@end